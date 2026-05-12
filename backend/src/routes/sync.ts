import { Hono } from 'hono';
import type { Env } from '../types/env.d.ts';
import { authMiddleware } from '../middleware/auth.middleware.ts';

const sync = new Hono<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>();

// All sync routes require a valid JWT
sync.use('*', authMiddleware);

// ── PUSH ──────────────────────────────────────────────────────────────────────
// POST /sync/push
// Body: { dataType: 'transactions' | 'debts' | 'house', payload: string (JSON), version?: number }
sync.post('/push', async (c) => {
  const user = c.get('user') as { sub: string };
  const userId = user.sub as string;

  if (!userId) return c.json({ error: 'User ID topilmadi' }, 401);

  const body = await c.req.json<{ dataType: string; payload: string; version?: number }>();
  const { dataType, payload, version } = body;

  const validTypes = ['transactions', 'debts', 'house'];
  if (!dataType || !validTypes.includes(dataType)) {
    return c.json({ error: `dataType noto\'g\'ri. Quyidagilardan biri bo\'lishi kerak: ${validTypes.join(', ')}` }, 400);
  }
  if (!payload || typeof payload !== 'string') {
    return c.json({ error: 'payload taqdim etilmagan yoki noto\'g\'ri' }, 400);
  }

  const now = Math.floor(Date.now() / 1000);
  const id = crypto.randomUUID();

  await c.env.DB.prepare(`
    INSERT INTO user_data (id, user_id, data_type, payload, version, synced_at)
    VALUES (?, ?, ?, ?, ?, ?)
    ON CONFLICT (user_id, data_type)
    DO UPDATE SET payload = excluded.payload,
                  version = excluded.version,
                  synced_at = excluded.synced_at
  `).bind(id, userId, dataType, payload, version ?? 1, now).run();

  return c.json({ success: true, syncedAt: now });
});

// ── PULL ──────────────────────────────────────────────────────────────────────
// GET /sync/pull
// Returns all data_type groups for the authenticated user
sync.get('/pull', async (c) => {
  const user = c.get('user') as { sub: string };
  const userId = user.sub as string;

  if (!userId) return c.json({ error: 'User ID topilmadi' }, 401);

  const rows = await c.env.DB.prepare(
    'SELECT data_type, payload, version, synced_at FROM user_data WHERE user_id = ?'
  ).bind(userId).all<{ data_type: string; payload: string; version: number; synced_at: number }>();

  const result: Record<string, { payload: string; version: number; syncedAt: number }> = {};
  for (const row of rows.results) {
    result[row.data_type] = {
      payload: row.payload,
      version: row.version,
      syncedAt: row.synced_at,
    };
  }

  return c.json({ success: true, data: result });
});

// ── STATUS ────────────────────────────────────────────────────────────────────
// GET /sync/status — returns last sync timestamps per data_type
sync.get('/status', async (c) => {
  const user = c.get('user') as { sub: string };
  const userId = user.sub as string;

  if (!userId) return c.json({ error: 'User ID topilmadi' }, 401);

  const rows = await c.env.DB.prepare(
    'SELECT data_type, version, synced_at FROM user_data WHERE user_id = ?'
  ).bind(userId).all<{ data_type: string; version: number; synced_at: number }>();

  const status: Record<string, { version: number; syncedAt: number }> = {};
  for (const row of rows.results) {
    status[row.data_type] = { version: row.version, syncedAt: row.synced_at };
  }

  return c.json({ success: true, status });
});

export default sync;
