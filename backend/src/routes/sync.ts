import { Hono } from 'hono';
import type { Env } from '../types/env.d.ts';
import { authMiddleware } from '../middleware/auth.middleware.ts';
import { getSql } from '../db/neon.ts';

const sync = new Hono<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>();

sync.use('*', authMiddleware);

// ── PUSH — ma'lumotlarni serverga yuborish ────────────────────────────────────
sync.post('/push', async (c) => {
  const user = c.get('user') as { sub: string };
  const userId = user.sub as string;
  if (!userId) return c.json({ error: 'Token noto\'g\'ri' }, 401);

  const body = await c.req.json<{ dataType: string; payload: string; version?: number }>();
  const { dataType, payload, version = 1 } = body;

  const validTypes = ['transactions', 'debts', 'house'];
  if (!dataType || !validTypes.includes(dataType)) {
    return c.json({ error: `dataType noto\'g\'ri: ${validTypes.join(', ')}` }, 400);
  }
  if (!payload || typeof payload !== 'string') {
    return c.json({ error: 'payload taqdim etilmagan' }, 400);
  }

  const sql = getSql(c.env.NEON_DATABASE_URL);
  const now = Math.floor(Date.now() / 1000);
  const id = crypto.randomUUID();

  await sql`
    INSERT INTO user_data (id, user_id, data_type, payload, version, synced_at)
    VALUES (${id}, ${userId}, ${dataType}, ${payload}, ${version}, ${now})
    ON CONFLICT (user_id, data_type) DO UPDATE
      SET payload    = EXCLUDED.payload,
          version    = EXCLUDED.version,
          synced_at  = EXCLUDED.synced_at
  `;

  return c.json({ success: true, syncedAt: now });
});

// ── PULL — barcha ma'lumotlarni yuklash ───────────────────────────────────────
sync.get('/pull', async (c) => {
  const user = c.get('user') as { sub: string };
  const userId = user.sub as string;
  if (!userId) return c.json({ error: 'Token noto\'g\'ri' }, 401);

  const sql = getSql(c.env.NEON_DATABASE_URL);
  const rows = await sql<{ data_type: string; payload: string; version: number; synced_at: number }[]>`
    SELECT data_type, payload, version, synced_at
    FROM user_data
    WHERE user_id = ${userId}
  `;

  const result: Record<string, { payload: string; version: number; syncedAt: number }> = {};
  for (const row of rows) {
    result[row.data_type] = {
      payload: row.payload,
      version: row.version,
      syncedAt: row.synced_at,
    };
  }

  return c.json({ success: true, data: result });
});

// ── STATUS — oxirgi sinxronlash vaqtlari ──────────────────────────────────────
sync.get('/status', async (c) => {
  const user = c.get('user') as { sub: string };
  const userId = user.sub as string;
  if (!userId) return c.json({ error: 'Token noto\'g\'ri' }, 401);

  const sql = getSql(c.env.NEON_DATABASE_URL);
  const rows = await sql<{ data_type: string; version: number; synced_at: number }[]>`
    SELECT data_type, version, synced_at
    FROM user_data
    WHERE user_id = ${userId}
  `;

  const status: Record<string, { version: number; syncedAt: number }> = {};
  for (const row of rows) {
    status[row.data_type] = { version: row.version, syncedAt: row.synced_at };
  }

  return c.json({ success: true, status });
});

export default sync;
