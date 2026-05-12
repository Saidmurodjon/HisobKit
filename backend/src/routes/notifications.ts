import { Hono } from 'hono';
import type { Env } from '../types/env.d.ts';
import { authMiddleware } from '../middleware/auth.middleware.ts';
import { getSql } from '../db/neon.ts';

const notifications = new Hono<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>();

// ── GET notifications (unread + last 50) ──────────────────────────────────────
notifications.get('/', authMiddleware, async (c) => {
  const userId = (c.get('user') as Record<string, unknown>)['sub'] as string;
  const onlyUnread = c.req.query('unread') === '1';
  const sql = getSql(c.env.NEON_DATABASE_URL);

  try {
    const rows = onlyUnread
      ? await sql`
          SELECT id, sender_id, sender_name, type, title, body, data, is_read, created_at
          FROM notifications
          WHERE recipient_id = ${userId} AND is_read = FALSE
          ORDER BY created_at DESC
          LIMIT 50
        `
      : await sql`
          SELECT id, sender_id, sender_name, type, title, body, data, is_read, created_at
          FROM notifications
          WHERE recipient_id = ${userId}
          ORDER BY created_at DESC
          LIMIT 50
        `;

    const unreadCount = await sql`
      SELECT COUNT(*) AS cnt FROM notifications
      WHERE recipient_id = ${userId} AND is_read = FALSE
    `;

    return c.json({
      notifications: rows.map(r => ({
        id: r['id'],
        senderId: r['sender_id'],
        senderName: r['sender_name'],
        type: r['type'],
        title: r['title'],
        body: r['body'],
        data: r['data'] ?? {},
        isRead: r['is_read'],
        createdAt: r['created_at'],
      })),
      unreadCount: Number(unreadCount[0]?.['cnt'] ?? 0),
    });
  } catch (e) {
    console.error('Get notifications error:', e);
    return c.json({ error: 'Xabarnomalarni olishda xato' }, 500);
  }
});

// ── MARK single notification as read ──────────────────────────────────────────
notifications.post('/:id/read', authMiddleware, async (c) => {
  const userId = (c.get('user') as Record<string, unknown>)['sub'] as string;
  const notifId = c.req.param('id');
  const sql = getSql(c.env.NEON_DATABASE_URL);

  try {
    await sql`
      UPDATE notifications
      SET is_read = TRUE
      WHERE id = ${Number(notifId)} AND recipient_id = ${userId}
    `;
    return c.json({ success: true });
  } catch (e) {
    console.error('Mark read error:', e);
    return c.json({ error: 'Belgilashda xato' }, 500);
  }
});

// ── MARK ALL as read ───────────────────────────────────────────────────────────
notifications.post('/read-all', authMiddleware, async (c) => {
  const userId = (c.get('user') as Record<string, unknown>)['sub'] as string;
  const sql = getSql(c.env.NEON_DATABASE_URL);

  try {
    await sql`
      UPDATE notifications SET is_read = TRUE
      WHERE recipient_id = ${userId} AND is_read = FALSE
    `;
    return c.json({ success: true });
  } catch (e) {
    console.error('Mark all read error:', e);
    return c.json({ error: 'Belgilashda xato' }, 500);
  }
});

// ── INTERNAL helper: create notification (used by other routes) ───────────────
export async function createNotification(
  sql: ReturnType<typeof getSql>,
  opts: {
    recipientId: string;
    senderId?: string;
    senderName?: string;
    type: string;
    title: string;
    body: string;
    data?: Record<string, unknown>;
  },
) {
  try {
    await sql`
      INSERT INTO notifications (recipient_id, sender_id, sender_name, type, title, body, data)
      VALUES (
        ${opts.recipientId},
        ${opts.senderId ?? null},
        ${opts.senderName ?? ''},
        ${opts.type},
        ${opts.title},
        ${opts.body},
        ${JSON.stringify(opts.data ?? {})}::jsonb
      )
    `;
  } catch (e) {
    console.error('createNotification error:', e);
  }
}

export default notifications;
