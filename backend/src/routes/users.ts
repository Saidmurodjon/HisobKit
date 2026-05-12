import { Hono } from 'hono';
import type { Env } from '../types/env.d.ts';
import { authMiddleware } from '../middleware/auth.middleware.ts';
import { getSql } from '../db/neon.ts';

const users = new Hono<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>();

// ── PROFILE UPSERT (login da chaqiriladi) ─────────────────────────────────────
users.post('/profile', authMiddleware, async (c) => {
  const user = c.get('user');
  const userId = user['sub'] as string;
  const email = user['email'] as string | undefined;

  const { displayName, avatarUrl, telegramUsername } = await c.req.json<{
    displayName?: string;
    avatarUrl?: string;
    telegramUsername?: string;
  }>();

  const sql = getSql(c.env.NEON_DATABASE_URL);

  try {
    await sql`
      INSERT INTO user_profiles (user_id, display_name, email, telegram_username, avatar_url, last_seen)
      VALUES (
        ${userId},
        ${displayName ?? ''},
        ${email ?? null},
        ${telegramUsername ?? null},
        ${avatarUrl ?? null},
        NOW()
      )
      ON CONFLICT (user_id) DO UPDATE SET
        display_name = COALESCE(EXCLUDED.display_name, user_profiles.display_name),
        email        = COALESCE(EXCLUDED.email, user_profiles.email),
        avatar_url   = COALESCE(EXCLUDED.avatar_url, user_profiles.avatar_url),
        telegram_username = COALESCE(EXCLUDED.telegram_username, user_profiles.telegram_username),
        last_seen    = NOW()
    `;
    return c.json({ success: true });
  } catch (e) {
    console.error('Profile upsert error:', e);
    return c.json({ error: 'Profil saqlashda xato' }, 500);
  }
});

// ── USER SEARCH by email ──────────────────────────────────────────────────────
// GET /users/search?q=email@example.com
users.get('/search', authMiddleware, async (c) => {
  const q = (c.req.query('q') ?? '').trim().toLowerCase();
  if (!q || q.length < 3) {
    return c.json({ user: null, message: 'Kamida 3 ta belgi kiriting' });
  }

  const meId = (c.get('user') as Record<string, unknown>)['sub'] as string;
  const sql = getSql(c.env.NEON_DATABASE_URL);

  try {
    const rows = await sql`
      SELECT user_id, display_name, email, telegram_username, avatar_url
      FROM user_profiles
      WHERE (LOWER(email) = ${q} OR LOWER(telegram_username) = ${q})
        AND user_id <> ${meId}
      LIMIT 1
    `;

    if (rows.length === 0) {
      return c.json({ user: null });
    }

    const row = rows[0];
    return c.json({
      user: {
        id: row['user_id'],
        displayName: row['display_name'],
        email: row['email'],
        telegramUsername: row['telegram_username'],
        avatarUrl: row['avatar_url'],
      },
    });
  } catch (e) {
    console.error('User search error:', e);
    return c.json({ error: 'Qidirishda xato' }, 500);
  }
});

// ── LINK TELEGRAM CHAT ID ─────────────────────────────────────────────────────
// Called by the Telegram bot webhook after /start
users.post('/link-telegram', async (c) => {
  const { userId, chatId, username } = await c.req.json<{
    userId: string;
    chatId: string;
    username?: string;
  }>();

  if (!userId || !chatId) return c.json({ error: 'userId va chatId shart' }, 400);

  // Simple shared secret check (bot-to-server call)
  const secret = c.req.header('X-Bot-Secret');
  if (!secret || secret !== c.env.TELEGRAM_BOT_TOKEN) {
    return c.json({ error: 'Ruxsat yo\'q' }, 403);
  }

  const sql = getSql(c.env.NEON_DATABASE_URL);
  try {
    await sql`
      UPDATE user_profiles
      SET telegram_chat_id = ${chatId},
          telegram_username = COALESCE(${username ?? null}, telegram_username)
      WHERE user_id = ${userId}
    `;
    return c.json({ success: true });
  } catch (e) {
    console.error('Link telegram error:', e);
    return c.json({ error: 'Bog\'lashda xato' }, 500);
  }
});

export default users;
