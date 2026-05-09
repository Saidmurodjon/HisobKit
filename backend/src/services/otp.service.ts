import type { OtpData, VerifyResult } from '../types/index.d.ts';

export function generateOtp(): string {
  const array = new Uint32Array(1);
  crypto.getRandomValues(array);
  return String(array[0] % 1000000).padStart(6, '0');
}

export async function saveOtp(
  email: string,
  otp: string,
  kv: KVNamespace,
  ttl: number,
): Promise<void> {
  const createdAt = Date.now();
  const raw = `${otp}:${email}:${createdAt}`;
  const hashBuffer = await crypto.subtle.digest(
    'SHA-256',
    new TextEncoder().encode(raw),
  );
  const hash = btoa(String.fromCharCode(...new Uint8Array(hashBuffer)));
  const data: OtpData = { hash, attempts: 0, createdAt };
  await kv.put(`otp:${email}`, JSON.stringify(data), { expirationTtl: ttl });
}

export async function verifyOtp(
  email: string,
  otp: string,
  kv: KVNamespace,
  maxAttempts: number,
): Promise<VerifyResult> {
  // Bloklangan?
  const blocked = await kv.get(`block:otp:${email}`);
  if (blocked) return { success: false, reason: 'blocked' };

  const raw = await kv.get(`otp:${email}`);
  if (!raw) return { success: false, reason: 'expired' };

  const data: OtpData = JSON.parse(raw);

  // Hash solishtirish
  const candidate = `${otp}:${email}:${data.createdAt}`;
  const hashBuffer = await crypto.subtle.digest(
    'SHA-256',
    new TextEncoder().encode(candidate),
  );
  const candidateHash = btoa(String.fromCharCode(...new Uint8Array(hashBuffer)));

  if (candidateHash !== data.hash) {
    data.attempts += 1;
    if (data.attempts >= maxAttempts) {
      await kv.put(`block:otp:${email}`, '1', { expirationTtl: 1800 });
      await kv.delete(`otp:${email}`);
      return { success: false, reason: 'blocked' };
    }
    await kv.put(`otp:${email}`, JSON.stringify(data), { expirationTtl: 300 });
    return {
      success: false,
      reason: 'invalid',
      attemptsLeft: maxAttempts - data.attempts,
    };
  }

  await kv.delete(`otp:${email}`);
  return { success: true };
}
