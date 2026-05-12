import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { logger } from 'hono/logger';
import { secureHeaders } from 'hono/secure-headers';
import authRoutes from './routes/auth.ts';
import syncRoutes from './routes/sync.ts';
import type { Env } from './types/env.d.ts';

const app = new Hono<{ Bindings: Env }>();

app.use('*', logger());
app.use('*', secureHeaders());
app.use('*', cors({
  origin: ['*'],
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowHeaders: ['Content-Type', 'Authorization'],
}));

app.get('/', c => c.json({
  name: 'HisobKit API',
  status: 'ok',
  version: '1.0.0',
}));

app.route('/auth', authRoutes);
app.route('/sync', syncRoutes);

app.notFound(c => c.json({ error: 'Topilmadi' }, 404));
app.onError((err, c) => {
  console.error(err);
  return c.json({ error: 'Server xatosi' }, 500);
});

export default app;
