import { createMiddleware } from 'hono/factory';
import { verifyToken } from '../services/jwt.service.ts';
import type { Env } from '../types/env.d.ts';

export const authMiddleware = createMiddleware<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>(
  async (c, next) => {
    const auth = c.req.header('Authorization');
    if (!auth?.startsWith('Bearer ')) {
      return c.json({ error: 'Token taqdim etilmagan' }, 401);
    }

    const token = auth.slice(7);
    const payload = await verifyToken(token, c.env.JWT_SECRET);
    if (!payload) return c.json({ error: 'Token noto\'g\'ri yoki muddati o\'tgan' }, 401);

    const jti = payload['jti'] as string | undefined;
    if (jti) {
      const blacklisted = await c.env.AUTH_KV.get(`blacklist:${jti}`);
      if (blacklisted) return c.json({ error: 'Token bekor qilingan' }, 401);
    }

    c.set('user', payload as Record<string, unknown>);
    await next();
  },
);
