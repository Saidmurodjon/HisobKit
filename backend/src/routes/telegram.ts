import { Hono } from 'hono';
import type { Env } from '../types/env.d.ts';
import { authMiddleware } from '../middleware/auth.middleware.ts';
import { createTokenPair } from '../services/jwt.service.ts';
import { getSql } from '../db/neon.ts';

const telegram = new Hono<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>();

function uuid(): string {
  return crypto.randomUUID();
}

// ─── Telegram Bot API helpers ─────────────────────────────────────────────────

async function sendTelegramMessage(
  botToken: string,
  chatId: string,
  text: string,
): Promise<boolean> {
  try {
    const res = await fetch(`https://api.telegram.org/bot${botToken}/sendMessage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ chat_id: chatId, text, parse_mode: 'HTML' }),
    });
    const data = await res.json() as { ok: boolean };
    return data.ok;
  } catch { return false; }
}

async function sendInlineKeyboard(
  botToken: string,
  chatId: string,
  text: string,
  buttons: Array<Array<{ text: string; callback_data: string }>>,
): Promise<void> {
  await fetch(`https://api.telegram.org/bot${botToken}/sendMessage`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      chat_id: chatId,
      text,
      parse_mode: 'HTML',
      reply_markup: { inline_keyboard: buttons },
    }),
  });
}

async function answerCallbackQuery(
  botToken: string,
  queryId: string,
  text: string,
): Promise<void> {
  await fetch(`https://api.telegram.org/bot${botToken}/answerCallbackQuery`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ callback_query_id: queryId, text, show_alert: false }),
  });
}

async function editMessageText(
  botToken: string,
  chatId: string,
  messageId: number,
  text: string,
): Promise<void> {
  await fetch(`https://api.telegram.org/bot${botToken}/editMessageText`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      chat_id: chatId,
      message_id: messageId,
      text,
      parse_mode: 'HTML',
    }),
  });
}

// ─── STEP 1: Login start (no auth) ───────────────────────────────────────────
// GET /auth/telegram/login-start
// Returns { code, deepLink, expiresIn }
telegram.get('/login-start', async (c) => {
  const randomPart = Math.random().toString(36).substring(2, 10).toUpperCase();
  const code = `login_${randomPart}`;
  await c.env.AUTH_KV.put(`tg_login:${code}`, 'pending', { expirationTtl: 300 });

  const deepLink = `https://t.me/HisobKitBot?start=${code}`;
  return c.json({ code, deepLink, expiresIn: 300 });
});

// ─── STEP 2: Polling — check if confirmed ────────────────────────────────────
// GET /auth/telegram/check?code=login_XXXX
telegram.get('/check', async (c) => {
  const code = c.req.query('code') ?? '';
  if (!code.startsWith('login_')) return c.json({ status: 'invalid' }, 400);

  // Check if result is ready
  const result = await c.env.AUTH_KV.get(`tg_login_result:${code}`);
  if (result) {
    await c.env.AUTH_KV.delete(`tg_login_result:${code}`);
    return c.json({ status: 'confirmed', ...JSON.parse(result) });
  }

  // Check if still pending
  const pending = await c.env.AUTH_KV.get(`tg_login:${code}`);
  if (!pending) return c.json({ status: 'expired' });

  return c.json({ status: 'pending' });
});

// ─── BOT WEBHOOK ──────────────────────────────────────────────────────────────
// POST /auth/telegram/webhook  (called by Telegram servers)
telegram.post('/webhook', async (c) => {
  let body: {
    message?: {
      message_id?: number;
      chat?: { id?: number; username?: string };
      text?: string;
    };
    callback_query?: {
      id: string;
      data?: string;
      message?: { message_id?: number; chat?: { id?: number } };
      from?: { id?: number; username?: string; first_name?: string };
    };
  };

  try { body = await c.req.json(); }
  catch { return c.json({ ok: true }); }

  // ── callback_query: user tapped an inline button ──────────────────────────
  if (body.callback_query) {
    const query = body.callback_query;
    const chatId = String(query.message?.chat?.id ?? query.from?.id ?? '');
    const callbackData = query.data ?? '';
    const queryId = query.id;
    const messageId = query.message?.message_id ?? 0;

    if (callbackData.startsWith('login:')) {
      const code = callbackData.slice(6);

      // Verify still pending
      const pending = await c.env.AUTH_KV.get(`tg_login:${code}`);
      if (!pending) {
        await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, 'Kod muddati o\'tgan');
        return c.json({ ok: true });
      }

      // Look up user by telegram_chat_id in Neon
      const sql = getSql(c.env.NEON_DATABASE_URL);
      let userId: string | null = null;
      let displayName: string = '';
      let email: string | null = null;

      try {
        const rows = await sql`
          SELECT user_id, display_name, email
          FROM user_profiles
          WHERE telegram_chat_id = ${chatId}
          LIMIT 1
        `;
        if (rows.length > 0) {
          userId = String(rows[0]['user_id']);
          displayName = String(rows[0]['display_name'] ?? '');
          email = rows[0]['email'] as string | null;
        }
      } catch (e) {
        console.error('Neon lookup in callback:', e);
        await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, 'Server xatosi');
        return c.json({ ok: true });
      }

      if (!userId) {
        await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId,
          'Hisobingiz bog\'lanmagan. Ilovada "Telegram bog\'lash" ni bajaring.');
        return c.json({ ok: true });
      }

      // Get user from D1 for email fallback
      const d1User = await c.env.DB.prepare('SELECT * FROM users WHERE id = ?').bind(userId)
        .first<{ id: string; email: string; display_name: string | null; avatar_url: string | null; created_at: number }>();

      const finalEmail = email || d1User?.email || '';

      // Create JWT token pair
      const deviceId = uuid();
      try {
        await c.env.DB.prepare(
          `INSERT INTO user_devices (id, user_id, device_name, platform, last_active) VALUES (?, ?, ?, 'android', ?)`,
        ).bind(deviceId, userId, 'Telegram Login', Math.floor(Date.now() / 1000)).run();
      } catch { /* table may not have this row yet */ }

      const { accessToken, refreshToken } = await createTokenPair(
        userId, finalEmail, deviceId, c.env.AUTH_KV, c.env.JWT_SECRET,
        parseInt(c.env.ACCESS_TOKEN_TTL), parseInt(c.env.REFRESH_TOKEN_TTL),
      );

      // Store result for app to pick up (60s TTL — app polls every 2s)
      await c.env.AUTH_KV.put(`tg_login_result:${code}`, JSON.stringify({
        accessToken,
        refreshToken,
        user: {
          id: userId,
          displayName: displayName || d1User?.display_name || '',
          email: finalEmail,
          avatarUrl: d1User?.avatar_url ?? null,
          providers: ['telegram'],
          createdAt: d1User?.created_at ?? Math.floor(Date.now() / 1000),
        },
      }), { expirationTtl: 60 });

      // Delete pending key
      await c.env.AUTH_KV.delete(`tg_login:${code}`);

      // Answer callback + update message
      await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, '✅ Kirish tasdiqlandi!');
      if (messageId) {
        await editMessageText(
          c.env.TELEGRAM_BOT_TOKEN, chatId, messageId,
          `✅ <b>HisobKit</b>ga muvaffaqiyatli kirdingiz!\n\nIlovaga qayting — kirish avtomatik amalga oshadi.`,
        );
      }
    } else if (callbackData.startsWith('cancel:')) {
      const code = callbackData.slice(7);
      await c.env.AUTH_KV.delete(`tg_login:${code}`);
      await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, 'Bekor qilindi');
      if (messageId) {
        await editMessageText(
          c.env.TELEGRAM_BOT_TOKEN, chatId, messageId,
          '❌ Kirish bekor qilindi. Agar siz bo\'lsangiz, ilovadan qaytadan urinib ko\'ring.',
        );
      }
    } else if (callbackData.startsWith('link:')) {
      // Telegram account linking (existing user)
      const connectCode = callbackData.slice(5);
      const storedUserId = await c.env.AUTH_KV.get(`tg_connect:${connectCode}`);
      if (!storedUserId) {
        await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, 'Kod muddati o\'tgan');
        return c.json({ ok: true });
      }

      const username = String(query.from?.username ?? '');
      const sql = getSql(c.env.NEON_DATABASE_URL);
      try {
        await sql`
          UPDATE user_profiles
          SET telegram_chat_id  = ${chatId},
              telegram_username = ${username || null}
          WHERE user_id = ${storedUserId}
        `;
      } catch (e) {
        console.error('Link update error:', e);
        await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, 'Xato yuz berdi');
        return c.json({ ok: true });
      }
      await c.env.AUTH_KV.delete(`tg_connect:${connectCode}`);
      await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, '✅ Muvaffaqiyatli bog\'landi!');
      if (messageId) {
        await editMessageText(
          c.env.TELEGRAM_BOT_TOKEN, chatId, messageId,
          '✅ Telegram muvaffaqiyatli bog\'landi! Endi siz Telegram orqali kirishingiz mumkin.',
        );
      }
    } else if (callbackData.startsWith('register:')) {
      // ── NEW USER REGISTRATION via Telegram ──────────────────────────────
      const code = callbackData.slice(9);

      const pending = await c.env.AUTH_KV.get(`tg_login:${code}`);
      if (!pending) {
        await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, 'Kod muddati o\'tgan');
        return c.json({ ok: true });
      }

      const tgUsername = String(query.from?.username ?? '');
      const firstName  = String(query.from?.first_name ?? '');
      const displayName = tgUsername ? `@${tgUsername}` : (firstName || 'Foydalanuvchi');
      const placeholderEmail = `tg_${chatId}@hisobkit.local`;
      const now = Math.floor(Date.now() / 1000);

      // ── 1. Create D1 user (INSERT OR IGNORE to be idempotent) ──────────
      const newUserId = uuid();
      let userId = newUserId;
      try {
        await c.env.DB.prepare(
          `INSERT OR IGNORE INTO users (id, email, display_name, created_at) VALUES (?, ?, ?, ?)`,
        ).bind(newUserId, placeholderEmail, displayName, now).run();

        // If the email already exists (race), look it up
        const existing = await c.env.DB.prepare(
          `SELECT id FROM users WHERE email = ?`,
        ).bind(placeholderEmail).first<{ id: string }>();
        if (existing) userId = existing.id;
      } catch (e) {
        console.error('D1 register insert:', e);
        await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, 'Server xatosi');
        return c.json({ ok: true });
      }

      // ── 2. Upsert Neon profile with telegram_chat_id ────────────────────
      const sql = getSql(c.env.NEON_DATABASE_URL);
      try {
        await sql`
          INSERT INTO user_profiles (user_id, display_name, email, telegram_chat_id, telegram_username)
          VALUES (${userId}, ${displayName}, ${placeholderEmail}, ${chatId}, ${tgUsername || null})
          ON CONFLICT (user_id) DO UPDATE SET
            telegram_chat_id  = EXCLUDED.telegram_chat_id,
            telegram_username = EXCLUDED.telegram_username
        `;
      } catch (e) {
        console.error('Neon register upsert:', e);
        await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, 'Server xatosi');
        return c.json({ ok: true });
      }

      // ── 3. Device + JWT ─────────────────────────────────────────────────
      const deviceId = uuid();
      try {
        await c.env.DB.prepare(
          `INSERT INTO user_devices (id, user_id, device_name, platform, last_active) VALUES (?, ?, ?, 'android', ?)`,
        ).bind(deviceId, userId, 'Telegram Registration', now).run();
      } catch { /* ignore duplicate */ }

      const { accessToken, refreshToken } = await createTokenPair(
        userId, placeholderEmail, deviceId, c.env.AUTH_KV, c.env.JWT_SECRET,
        parseInt(c.env.ACCESS_TOKEN_TTL), parseInt(c.env.REFRESH_TOKEN_TTL),
      );

      // ── 4. Store result for app to pick up ──────────────────────────────
      await c.env.AUTH_KV.put(`tg_login_result:${code}`, JSON.stringify({
        accessToken,
        refreshToken,
        user: {
          id: userId,
          displayName,
          email: placeholderEmail,
          avatarUrl: null,
          providers: ['telegram'],
          createdAt: now,
        },
      }), { expirationTtl: 60 });
      await c.env.AUTH_KV.delete(`tg_login:${code}`);

      // ── 5. Confirm in bot ────────────────────────────────────────────────
      await answerCallbackQuery(c.env.TELEGRAM_BOT_TOKEN, queryId, '✅ Hisob yaratildi!');
      if (messageId) {
        await editMessageText(
          c.env.TELEGRAM_BOT_TOKEN, chatId, messageId,
          `✅ <b>HisobKit</b> hisobi muvaffaqiyatli yaratildi!\n\n`
          + `👤 Ism: <b>${displayName}</b>\n\n`
          + `Ilovaga qayting — kirish avtomatik amalga oshadi.`,
        );
      }
    }

    return c.json({ ok: true });
  }

  // ── message: /start command ───────────────────────────────────────────────
  const message = body.message;
  if (!message) return c.json({ ok: true });

  const chatId = String(message.chat?.id ?? '');
  const username = String(message.chat?.username ?? '');
  const text = (message.text ?? '').trim();

  if (!text.startsWith('/start')) {
    return c.json({ ok: true });
  }

  const param = text.split(' ')[1]?.trim() ?? '';

  // ── Case 1: LOGIN flow — /start login_XXXX ──────────────────────────────
  if (param.startsWith('login_')) {
    const code = param;
    const pending = await c.env.AUTH_KV.get(`tg_login:${code}`);
    if (!pending) {
      await sendTelegramMessage(c.env.TELEGRAM_BOT_TOKEN, chatId,
        '❌ Kirish kodi muddati o\'tgan yoki noto\'g\'ri.\n\nIlovadan qaytadan urinib ko\'ring.');
      return c.json({ ok: true });
    }

    // Check if this Telegram chat_id is linked to any HisobKit account
    const sql = getSql(c.env.NEON_DATABASE_URL);
    let displayName = 'Foydalanuvchi';
    let isLinked = false;

    try {
      const rows = await sql`
        SELECT user_id, display_name FROM user_profiles
        WHERE telegram_chat_id = ${chatId}
        LIMIT 1
      `;
      if (rows.length > 0) {
        isLinked = true;
        displayName = String(rows[0]['display_name'] || 'Foydalanuvchi');
      }
    } catch (e) {
      console.error('Neon check in /start login:', e);
    }

    if (!isLinked) {
      // Offer to create a new account directly via Telegram
      await sendInlineKeyboard(
        c.env.TELEGRAM_BOT_TOKEN,
        chatId,
        '👋 Salom!\n\n'
        + 'Bu Telegram hisobi HisobKit ga bog\'lanmagan.\n\n'
        + '✨ Yangi hisob yaratib, darhol kirishni xohlaysizmi?\n'
        + '(Email talab qilinmaydi)',
        [
          [{ text: '✅ Yangi hisob yaratish', callback_data: `register:${code}` }],
          [{ text: '❌ Bekor qilish',          callback_data: `cancel:${code}` }],
        ],
      );
      return c.json({ ok: true });
    }

    // Send confirmation keyboard
    await sendInlineKeyboard(
      c.env.TELEGRAM_BOT_TOKEN,
      chatId,
      `🔐 <b>HisobKit — Kirish so'rovi</b>\n\n`
      + `Salom, <b>${displayName}</b>!\n\n`
      + `Hisobingizga kirish so'rovi keldi.\n\n`
      + `Bu siz bo'lsangiz — <b>Tasdiqlash</b> tugmasini bosing.\n`
      + `⚠️ Agar siz kirish so'ramagan bo'lsangiz — <b>Bekor qilish</b>ni bosing.`,
      [
        [{ text: '✅ Tasdiqlash', callback_data: `login:${code}` }],
        [{ text: '❌ Bekor qilish', callback_data: `cancel:${code}` }],
      ],
    );
    return c.json({ ok: true });
  }

  // ── Case 2: LINK flow — /start CONNECT_CODE ─────────────────────────────
  if (param.length > 0) {
    const connectCode = param;
    const storedUserId = await c.env.AUTH_KV.get(`tg_connect:${connectCode}`);
    if (!storedUserId) {
      await sendTelegramMessage(c.env.TELEGRAM_BOT_TOKEN, chatId,
        '❌ Bog\'lash kodi muddati o\'tgan.\n\nIlovadan qaytadan urinib ko\'ring.');
      return c.json({ ok: true });
    }

    // Ask for confirmation before linking
    await sendInlineKeyboard(
      c.env.TELEGRAM_BOT_TOKEN,
      chatId,
      '🔗 <b>HisobKit — Telegram bog\'lash</b>\n\n'
      + 'Bu Telegram hisobingizni HisobKit ga bog\'lamoqchi.\n\n'
      + 'Tasdiqlaysizmi?',
      [
        [{ text: '✅ Ha, bog\'lash', callback_data: `link:${connectCode}` }],
        [{ text: '❌ Yo\'q', callback_data: `cancel:x` }],
      ],
    );
    return c.json({ ok: true });
  }

  // ── Case 3: Plain /start ─────────────────────────────────────────────────
  await sendTelegramMessage(c.env.TELEGRAM_BOT_TOKEN, chatId,
    '👋 Salom! Bu <b>HisobKit</b> bot.\n\n'
    + '📱 Kirish uchun HisobKit ilovasida "Telegram orqali kirish" tugmasini bosing.\n\n'
    + '🔗 Telegram ni bog\'lash uchun: Sozlamalar → Telegram bog\'lash.');

  return c.json({ ok: true });
});

// ─── Telegram linking start (authenticated user) ──────────────────────────────
// POST /auth/telegram/start  (requires JWT)
telegram.post('/start', authMiddleware, async (c) => {
  const user = c.get('user') as Record<string, unknown>;
  const userId = user['sub'] as string;

  const connectCode = Math.random().toString(36).substring(2, 10).toUpperCase();
  await c.env.AUTH_KV.put(`tg_connect:${connectCode}`, userId, { expirationTtl: 600 });

  return c.json({
    connectUrl: `https://t.me/HisobKitBot?start=${connectCode}`,
    code: connectCode,
    expiresIn: 600,
  });
});

export default telegram;
