import type { GoogleUser } from '../types/index.d.ts';

export async function verifyGoogleToken(
  idToken: string,
  clientId: string,
): Promise<GoogleUser | null> {
  try {
    const url = `https://oauth2.googleapis.com/tokeninfo?id_token=${idToken}`;
    const res = await fetch(url);
    if (!res.ok) return null;

    const payload = await res.json() as Record<string, string>;

    if (payload['aud'] !== clientId) return null;
    if (Number(payload['exp']) < Math.floor(Date.now() / 1000)) return null;
    if (payload['email_verified'] !== 'true') return null;

    return {
      googleId: payload['sub'],
      email: payload['email'],
      name: payload['name'] ?? payload['email'],
      avatarUrl: payload['picture'] ?? null,
    };
  } catch {
    return null;
  }
}
