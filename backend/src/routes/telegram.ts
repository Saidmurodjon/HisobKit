import { Hono } from 'hono';
import type { Env } from '../types/env.d.ts';
import { authMiddleware } from '../middleware/auth.middleware.ts';
import { generateOtp, saveOtp, verifyOtp } from '../services/otp.service.ts';
import { createTokenPair } from '../services/jwt.service.ts';
import { checkRateLimit } from '../middleware/rate-limit.ts';
import { getSql } from '../db/neon.ts';

const telegram = new Hono<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>();

function uuid(): string {
  return crypto.randomUUID();
}

/**
 * Telegram Bot API orqali xabar yuborish
 */
async function sendTelegramMessage(botToken: string, chatId: string, text: string): Promise<boolean> {
  try {
    const res = await fetch(`https://api.telegram.org/bot${botToken}/sendMessage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ chat_id: chatId, text, parse_mode: 'HTML' }),
    });
    const data = await res.json() as { ok: boolean };
    return data.ok === true;
  } catch (e) {
    console.error('Telegram sendMessage error:', e);
    return false;
  }
}

// ── STEP 1: Start — foydalanuvchi Telegram ni bog'lashni boshlaydi ─────────────
// POST /auth/telegram/start
// Returns a deep-link URL that opens the bot with a "connect" code
telegram.post('/start', authMiddleware, async (c) => {
  const user = c.get('user') as Record<string, unknown>;
  const userId = user['sub'] as string;

  // Generate a one-time connect code (10 min TTL)
  const connectCode = Math.random().toString(36).substring(2, 10).toUpperCase();
  await c.env.AUTH_KV.put(`tg_connect:${connectCode}`, userId, { expirationTtl: 600 });

  const botUsername = 'HisobKitBot';
  return c.json({
    connectUrl: `https://t.me/${botUsername}?start=${connectCode}`,
    code: connectCode,
    expiresIn: 600,
  });
});

// ── BOT WEBHOOK: /start <code> command handler ────────────────────────────────
// POST /auth/telegram/webhook  (called by Telegram)
telegram.post('/webhook', async (c) => {
  let body: { message?: { chat?: { id?: number; username?: string }; text?: string } };
  try {
    body = await c.req.json();
  } catch {
    return c.json({ ok: true });
  }

  const message = body.message;
  if (!message) return c.json({ ok: true });

  const chatId = String(message.chat?.id ?? '');
  const username = message.chat?.username ?? '';
  const text = (message.text ?? '').trim();

  if (text.startsWith('/start ')) {
    const connectCode = text.split(' ')[1]?.trim() ?? '';
    const userId = await c.env.AUTH_KV.get(`tg_connect:${connectCode}`);
    if (!userId) {
      await sendTelegramMessage(c.env.TELEGRAM_BOT_TOKEN, chatId,
        '❌ Kod noto\'g\'ri yoki muddati o\'tgan. HisobKit ilovasidan qaytadan urinib ko\'ring.');
      return c.json({ ok: true });
    }

    // Save chat_id to Neon user_profiles
    const sql = getSql(c.env.NEON_DATABASE_URL);
    try {
      await sql`
        UPDATE user_profiles
        SET telegram_chat_id  = ${chatId},
            telegram_username = ${username || null}
        WHERE user_id = ${userId}
      `;
    } catch (e) {
      console.error('Telegram link update error:', e);
    }

    // Remove connect code
    await c.env.AUTH_KV.delete(`tg_connect:${connectCode}`);

    await sendTelegramMessage(c.env.TELEGRAM_BOT_TOKEN, chatId,
      '✅ <b>HisobKit</b> hisobingiz Telegram ga muvaffaqiyatli bog\'landi!\n\nEndi kirish kodlarini Telegram orqali olasiz.');
  } else if (text === '/start') {
    await sendTelegramMessage(c.env.TELEGRAM_BOT_TOKEN, chatId,
      '👋 Salom! Bu <b>HisobKit</b> bot.\n\nHisobingizni bog\'lash uchun HisobKit ilovasidagi "Telegram orqali kirish" tugmasini bosing.');
  }

  return c.json({ ok: true });
});

// ── STEP 2: Send OTP via Telegram ─────────────────────────────────────────────
// POST /auth/telegram/send-otp  { userId? }
// Also usable without auth (for login flow) — pass email instead
telegram.post('/send-otp', async (c) => {
  const ip = c.req.header('CF-Connecting-IP') ?? 'unknown';
  const rl = await checkRateLimit(`tg_otp_ip:${ip}`, 5, 3600, c.env.AUTH_KV);
  if (!rl.allowed) return c.json({ error: 'Juda ko\'p urinish' }, 429);

  const { email } = await c.req.json<{ email: string }>();
  if (!email) return c.json({ error: 'Email taqdim etilmagan' }, 400);

  const emailRl = await checkRateLimit(`tg_otp_email:${email}`, 1, 60, c.env.AUTH_KV);
  if (!emailRl.allowed) return c.json({ error: 'Biroz kuting (1 daqiqa)' }, 429);

  // Find telegram_chat_id from Neon
  const sql = getSql(c.env.NEON_DATABASE_URL);
  let chatId: string | null = null;
  try {
    const rows = await sql`
      SELECT telegram_chat_id FROM user_profiles WHERE LOWER(email) = ${email.toLowerCase()}
      LIMIT 1
    `;
    chatId = rows[0]?.['telegram_chat_id'] as string | null ?? null;
  } catch (e) {
    console.error('Neon lookup error:', e);
    return c.json({ error: 'Server xatosi' }, 500);
  }

  if (!chatId) {
    return c.json({
      error: 'Bu email uchun Telegram bog\'lanmagan',
      code: 'telegram_not_linked',
    }, 404);
  }

  const otp = generateOtp();
  const ttl = parseInt(c.env.OTP_TTL);
  await saveOtp(`tg:${email}`, otp, c.env.AUTH_KV, ttl);

  const sent = await sendTelegramMessage(
    c.env.TELEGRAM_BOT_TOKEN,
    chatId,
    `🔐 <b>HisobKit kirish kodi</b>\n\nKodingiz: <code>${otp}</code>\n\nAmal qilish muddati: ${ttl / 60} daqiqa.\n\n⚠️ Bu kodni hech kimga bermang.`,
  );

  if (!sent) {
    return c.json({ error: 'Telegram xabar yuborishda xato' }, 502);
  }

  return c.json({ success: true, expiresIn: ttl });
});

// ── STEP 3: Verify Telegram OTP ───────────────────────────────────────────────
telegram.post('/verify-otp', async (c) => {
  const { email, otp, displayName, deviceName } = await c.req.json<{
    email: string;
    otp: string;
    displayName?: string;
    deviceName?: string;
  }>();

  if (!email || !otp) return c.json({ error: 'email va otp shart' }, 400);

  const maxAttempts = parseInt(c.env.OTP_MAX_ATTEMPTS);
  const result = await verifyOtp(`tg:${email.toLowerCase()}`, otp, c.env.AUTH_KV, maxAttempts);
  if (!result.success) {
    const messages: Record<string, string> = {
      expired: 'Kod muddati o\'tdi.',
      blocked: 'Juda ko\'p urinish. 30 daqiqa kuting.',
      invalid: 'Noto\'g\'ri kod.',
    };
    return c.json({
      error: messages[result.reason] ?? 'Xato',
      code: result.reason,
      attemptsLeft: result.attemptsLeft,
    }, 400);
  }

  // Find or create user in D1
  let user = await c.env.DB.prepare(
    'SELECT * FROM users WHERE email = ?',
  ).bind(email.toLowerCase()).first<{ id: string; email: string; display_name: string | null; avatar_url: string | null; created_at: number }>();

  const isNewUser = !user;
  const now = Math.floor(Date.now() / 1000);

  if (!user) {
    if (!displayName) {
      await c.env.AUTH_KV.put(`pre_verified:${email.toLowerCase()}`, '1', { expirationTtl: 600 });
      return c.json({ error: 'Ism kiritilmagan', code: 'needs_profile', isNewUser: true }, 400);
    }
    const userId = uuid();
    await c.env.DB.prepare(
      `INSERT INTO users (id, email, display_name, last_seen_at) VALUES (?, ?, ?, ?)`,
    ).bind(userId, email.toLowerCase(), displayName, now).run();
    await c.env.DB.prepare(
      `INSERT INTO user_auth_providers (id, user_id, provider, provider_id) VALUES (?, ?, 'telegram', ?)`,
    ).bind(uuid(), userId, email.toLowerCase()).run();
    user = { id: userId, email: email.toLowerCase(), display_name: displayName, avatar_url: null, created_at: now };
  } else {
    await c.env.DB.prepare('UPDATE users SET last_seen_at = ? WHERE id = ?').bind(now, user.id).run();
  }

  const deviceId = uuid();
  await c.env.DB.prepare(
    `INSERT INTO user_devices (id, user_id, device_name, platform, last_active) VALUES (?, ?, ?, 'android', ?)`,
  ).bind(deviceId, user.id, deviceName ?? 'Unknown', now).run();

  const { accessToken, refreshToken } = await createTokenPair(
    user.id, user.email, deviceId, c.env.AUTH_KV, c.env.JWT_SECRET,
    parseInt(c.env.ACCESS_TOKEN_TTL), parseInt(c.env.REFRESH_TOKEN_TTL),
  );

  return c.json({
    accessToken,
    refreshToken,
    isNewUser,
    user: {
      id: user.id,
      displayName: user.display_name,
      email: user.email,
      avatarUrl: user.avatar_url,
      providers: ['telegram'],
      createdAt: user.created_at,
    },
  });
});

export default telegram;
