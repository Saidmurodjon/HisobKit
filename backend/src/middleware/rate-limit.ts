export async function checkRateLimit(
  key: string,
  max: number,
  windowSec: number,
  kv: KVNamespace,
): Promise<{ allowed: boolean; remaining: number }> {
  const raw = await kv.get(`rl:${key}`);
  const count = raw ? parseInt(raw, 10) : 0;

  if (count >= max) return { allowed: false, remaining: 0 };

  await kv.put(`rl:${key}`, String(count + 1), { expirationTtl: windowSec });
  return { allowed: true, remaining: max - count - 1 };
}
