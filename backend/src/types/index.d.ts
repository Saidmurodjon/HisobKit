export interface User {
  id: string;
  display_name: string | null;
  email: string;
  google_id: string | null;
  avatar_url: string | null;
  public_key: string | null;
  is_active: number;
  created_at: number;
  last_seen_at: number | null;
}

export interface GoogleUser {
  googleId: string;
  email: string;
  name: string;
  avatarUrl: string | null;
}

export interface OtpData {
  hash: string;
  attempts: number;
  createdAt: number;
}

export type VerifyResult =
  | { success: true }
  | {
      success: false;
      reason: 'expired' | 'blocked' | 'invalid';
      attemptsLeft?: number;
    };

export interface JWTUserPayload {
  sub: string;
  email: string;
  jti: string;
  iat: number;
  exp: number;
}

export interface JWTRefreshPayload {
  sub: string;
  deviceId: string;
  jti: string;
  iat: number;
  exp: number;
}
