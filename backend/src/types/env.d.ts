export interface Env {
  DB: D1Database;
  AUTH_KV: KVNamespace;
  JWT_SECRET: string;
  GOOGLE_CLIENT_ID: string;
  RESEND_API_KEY: string;
  RESEND_FROM_EMAIL: string;
  APP_NAME: string;
  ACCESS_TOKEN_TTL: string;
  REFRESH_TOKEN_TTL: string;
  OTP_TTL: string;
  OTP_MAX_ATTEMPTS: string;
  RATE_LIMIT_WINDOW: string;
}
