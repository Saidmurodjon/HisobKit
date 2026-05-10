import { Hono } from 'hono';
import type { Env } from '../types/env.d.ts';
import { verifyGoogleToken } from '../services/google.service.ts';
import { generateOtp, saveOtp, verifyOtp } from '../services/otp.service.ts';
import { createTokenPair, verifyToken } from '../services/jwt.service.ts';
import { sendOtpEmail } from '../services/email.service.ts';
import { checkRateLimit } from '../middleware/rate-limit.ts';
import { authMiddleware } from '../middleware/auth.middleware.ts';

const auth = new Hono<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>();

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function maskEmail(email: string): string {
  const [name, domain] = email.split('@');
  if (name.length <= 2) return email;
  return `${name[0]}***${name[name.length - 1]}@${domain}`;
}

function uuid(): string {
  return crypto.randomUUID();
}

// ── GOOGLE INIT ───────────────────────────────────────────────────────────────
auth.post('/google/init', async (c) => {
  const ip = c.req.header('CF-Connecting-IP') ?? 'unknown';
  const rl = await checkRateLimit(`ip:${ip}`, 10, 3600, c.env.AUTH_KV);
  if (!rl.allowed) return c.json({ error: 'Juda ko\'p urinish. Keyinroq urinib ko\'ring.' }, 429);

  const { idToken } = await c.req.json<{ idToken: string }>();
  if (!idToken) return c.json({ error: 'idToken taqdim etilmagan' }, 400);

  const gUser = await verifyGoogleToken(idToken, c.env.GOOGLE_CLIENT_ID);
  if (!gUser) return c.json({ error: 'Google token noto\'g\'ri' }, 400);

  const otp = generateOtp();
  const ttl = parseInt(c.env.OTP_TTL);
  await saveOtp(gUser.email, otp, c.env.AUTH_KV, ttl);
  await sendOtpEmail(gUser.email, otp, c.env.RESEND_API_KEY, c.env.RESEND_FROM_EMAIL);

  return c.json({
    success: true,
    email: gUser.email,
    maskedEmail: maskEmail(gUser.email),
    name: gUser.name,
    avatarUrl: gUser.avatarUrl,
    expiresIn: ttl,
  });
});

// ── GOOGLE VERIFY ─────────────────────────────────────────────────────────────
auth.post('/google/verify', async (c) => {
  const { idToken, otp, deviceName } = await c.req.json<{
    idToken: string;
    otp: string;
    deviceName?: string;
  }>();

  const gUser = await verifyGoogleToken(idToken, c.env.GOOGLE_CLIENT_ID);
  if (!gUser) return c.json({ error: 'Google token noto\'g\'ri' }, 400);

  const maxAttempts = parseInt(c.env.OTP_MAX_ATTEMPTS);
  const result = await verifyOtp(gUser.email, otp, c.env.AUTH_KV, maxAttempts);
  if (!result.success) {
    return c.json({ error: otpErrorMessage(result.reason), code: result.reason, attemptsLeft: result.attemptsLeft }, 400);
  }

  // Find or create user
  let user = await c.env.DB.prepare(
    'SELECT * FROM users WHERE google_id = ?',
  ).bind(gUser.googleId).first<{ id: string; email: string; display_name: string | null; avatar_url: string | null; created_at: number }>();

  const isNewUser = !user;
  const now = Math.floor(Date.now() / 1000);

  if (!user) {
    const userId = uuid();
    await c.env.DB.prepare(
      `INSERT INTO users (id, email, google_id, display_name, avatar_url, last_seen_at)
       VALUES (?, ?, ?, ?, ?, ?)`,
    ).bind(userId, gUser.email, gUser.googleId, gUser.name, gUser.avatarUrl, now).run();
    await c.env.DB.prepare(
      `INSERT INTO user_auth_providers (id, user_id, provider, provider_id) VALUES (?, ?, 'google', ?)`,
    ).bind(uuid(), userId, gUser.googleId).run();
    user = { id: userId, email: gUser.email, display_name: gUser.name, avatar_url: gUser.avatarUrl, created_at: now };
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
      providers: ['google'],
      createdAt: user.created_at,
    },
  });
});

// ── EMAIL SEND OTP ────────────────────────────────────────────────────────────
auth.post('/email/send-otp', async (c) => {
  const { email } = await c.req.json<{ email: string }>();
  if (!email || !EMAIL_REGEX.test(email)) {
    return c.json({ error: 'Email formati noto\'g\'ri' }, 400);
  }

  const ip = c.req.header('CF-Connecting-IP') ?? 'unknown';
  const [ipRl, emailRl] = await Promise.all([
    checkRateLimit(`ip:${ip}`, 10, 3600, c.env.AUTH_KV),
    checkRateLimit(`send:${email}`, 1, 60, c.env.AUTH_KV),
  ]);

  if (!ipRl.allowed || !emailRl.allowed) {
    return c.json({ error: 'Juda tez urinish. Biroz kuting.' }, 429);
  }

  const blocked = await c.env.AUTH_KV.get(`block:otp:${email}`);
  if (blocked) return c.json({ error: 'Email vaqtincha bloklangan' }, 429);

  const otp = generateOtp();
  const ttl = parseInt(c.env.OTP_TTL);
  await saveOtp(email, otp, c.env.AUTH_KV, ttl);
  await sendOtpEmail(email, otp, c.env.RESEND_API_KEY, c.env.RESEND_FROM_EMAIL);

  return c.json({ success: true, expiresIn: ttl });
});

// ── EMAIL VERIFY OTP ──────────────────────────────────────────────────────────
auth.post('/email/verify-otp', async (c) => {
  const { email, otp, displayName, deviceName } = await c.req.json<{
    email: string;
    otp: string;
    displayName?: string;
    deviceName?: string;
  }>();

  const maxAttempts = parseInt(c.env.OTP_MAX_ATTEMPTS);
  const result = await verifyOtp(email, otp, c.env.AUTH_KV, maxAttempts);
  if (!result.success) {
    return c.json({ error: otpErrorMessage(result.reason), code: result.reason, attemptsLeft: result.attemptsLeft }, 400);
  }

  let user = await c.env.DB.prepare(
    'SELECT * FROM users WHERE email = ?',
  ).bind(email).first<{ id: string; email: string; display_name: string | null; avatar_url: string | null; created_at: number }>();

  const isNewUser = !user;
  const now = Math.floor(Date.now() / 1000);

  if (!user) {
    if (!displayName) {
      return c.json({ error: 'Ism kiritilmagan', code: 'needs_profile', isNewUser: true }, 400);
    }
    const userId = uuid();
    await c.env.DB.prepare(
      `INSERT INTO users (id, email, display_name, last_seen_at) VALUES (?, ?, ?, ?)`,
    ).bind(userId, email, displayName, now).run();
    await c.env.DB.prepare(
      `INSERT INTO user_auth_providers (id, user_id, provider, provider_id) VALUES (?, ?, 'email', ?)`,
    ).bind(uuid(), userId, email).run();
    user = { id: userId, email, display_name: displayName, avatar_url: null, created_at: now };
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
      providers: ['email'],
      createdAt: user.created_at,
    },
  });
});

// ── RESEND OTP ────────────────────────────────────────────────────────────────
auth.post('/resend-otp', async (c) => {
  const { email } = await c.req.json<{ email: string }>();
  if (!email || !EMAIL_REGEX.test(email)) return c.json({ error: 'Email noto\'g\'ri' }, 400);

  const rl = await checkRateLimit(`send:${email}`, 1, 60, c.env.AUTH_KV);
  if (!rl.allowed) return c.json({ error: 'Biroz kuting (1 daqiqa)' }, 429);

  await c.env.AUTH_KV.delete(`otp:${email}`);
  const otp = generateOtp();
  const ttl = parseInt(c.env.OTP_TTL);
  await saveOtp(email, otp, c.env.AUTH_KV, ttl);
  await sendOtpEmail(email, otp, c.env.RESEND_API_KEY, c.env.RESEND_FROM_EMAIL);

  return c.json({ success: true, expiresIn: ttl });
});

// ── REFRESH ───────────────────────────────────────────────────────────────────
auth.post('/refresh', async (c) => {
  const { refreshToken, deviceId } = await c.req.json<{
    refreshToken: string;
    deviceId: string;
  }>();

  const payload = await verifyToken(refreshToken, c.env.JWT_SECRET);
  if (!payload) return c.json({ error: 'Refresh token noto\'g\'ri' }, 401);

  const userId = payload['sub'] as string;
  const stored = await c.env.AUTH_KV.get(`refresh:${userId}:${deviceId}`);
  if (!stored) return c.json({ error: 'Token bekor qilingan' }, 401);

  const { token: storedToken } = JSON.parse(stored) as { token: string };
  if (storedToken !== refreshToken) return c.json({ error: 'Token mos kelmadi' }, 401);

  const user = await c.env.DB.prepare('SELECT email FROM users WHERE id = ?').bind(userId).first<{ email: string }>();
  if (!user) return c.json({ error: 'Foydalanuvchi topilmadi' }, 401);

  // Delete old refresh token (rotation)
  await c.env.AUTH_KV.delete(`refresh:${userId}:${deviceId}`);

  const tokens = await createTokenPair(
    userId, user.email, deviceId, c.env.AUTH_KV, c.env.JWT_SECRET,
    parseInt(c.env.ACCESS_TOKEN_TTL), parseInt(c.env.REFRESH_TOKEN_TTL),
  );

  return c.json(tokens);
});

// ── LOGOUT ────────────────────────────────────────────────────────────────────
auth.post('/logout', authMiddleware, async (c) => {
  const user = c.get('user');
  const jti = user['jti'] as string | undefined;
  const userId = user['sub'] as string;
  const { deviceId } = await c.req.json<{ deviceId?: string }>().catch(() => ({ deviceId: undefined }));

  if (jti) {
    const exp = user['exp'] as number;
    const ttl = Math.max(1, exp - Math.floor(Date.now() / 1000));
    await c.env.AUTH_KV.put(`blacklist:${jti}`, '1', { expirationTtl: ttl });
  }

  if (deviceId) {
    await c.env.AUTH_KV.delete(`refresh:${userId}:${deviceId}`);
  }

  return c.json({ success: true });
});

// ── ME ────────────────────────────────────────────────────────────────────────
auth.get('/me', authMiddleware, async (c) => {
  const user = c.get('user');
  const userId = user['sub'] as string;

  const row = await c.env.DB.prepare('SELECT * FROM users WHERE id = ?').bind(userId).first<{
    id: string; display_name: string | null; email: string; avatar_url: string | null; created_at: number;
  }>();
  if (!row) return c.json({ error: 'Foydalanuvchi topilmadi' }, 404);

  const providers = await c.env.DB.prepare(
    'SELECT provider FROM user_auth_providers WHERE user_id = ?',
  ).bind(userId).all<{ provider: string }>();

  return c.json({
    id: row.id,
    displayName: row.display_name,
    email: row.email,
    avatarUrl: row.avatar_url,
    providers: providers.results.map(p => p.provider),
    createdAt: row.created_at,
  });
});

function otpErrorMessage(reason: string): string {
  switch (reason) {
    case 'expired': return 'Kod muddati o\'tdi. Yangi kod so\'rang.';
    case 'blocked': return 'Juda ko\'p noto\'g\'ri urinish. 30 daqiqadan keyin urinib ko\'ring.';
    case 'invalid': return 'Noto\'g\'ri kod.';
    default: return 'Tasdiqlash xatosi.';
  }
}

export default auth;
