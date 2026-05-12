import { neon } from '@neondatabase/serverless';

/**
 * Cloudflare Workers da Neon PostgreSQL ga HTTP orqali ulanish.
 * Har request uchun yangi neon() instance yaratiladi (Workers stateless).
 */
export function getSql(databaseUrl: string) {
  return neon(databaseUrl);
}

/** Generic qator tipi */
export type Row = Record<string, unknown>;
