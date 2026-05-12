import type { GoogleUser } from '../types/index.d.ts';

export async function verifyGoogleToken(
  idToken: string,
  clientId: string,
): Promise<GoogleUser | null> {
  try {
    const url = `https://oauth2.googleapis.com/tokeninfo?id_token=${idToken}`;
    const res = await fetch(url);
    if (!res.ok) {
      console.error('[Google] tokeninfo failed:', res.status);
      return null;
    }

    const payload = await res.json() as Record<string, string>;

    // aud must match our web client ID (or azp for Android clients)
    const audMatch = payload['aud'] === clientId || payload['azp'] === clientId;
    if (!audMatch) {
      // Log both values so we can diagnose mismatches
      console.error('[Google] aud mismatch. token_aud:', payload['aud'], 'token_azp:', payload['azp'], 'expected_clientId:', clientId);
      return null;
    }
    if (Number(payload['exp']) < Math.floor(Date.now() / 1000)) {
      console.error('[Google] token expired');
      return null;
    }
    if (payload['email_verified'] !== 'true') {
      console.error('[Google] email not verified');
      return null;
    }

    return {
      googleId: payload['sub'],
      email: payload['email'],
      name: payload['name'] ?? payload['email'],
      avatarUrl: payload['picture'] ?? null,
    };
  } catch (e) {
    console.error('[Google] exception:', e);
    return null;
  }
}
