import { SignJWT, jwtVerify, type JWTPayload } from 'jose';

function getSecret(secret: string): Uint8Array {
  return new TextEncoder().encode(secret);
}

export async function createAccessToken(
  userId: string,
  email: string,
  secret: string,
  ttl: number,
): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  return new SignJWT({ sub: userId, email, jti: crypto.randomUUID() })
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt(now)
    .setExpirationTime(now + ttl)
    .sign(getSecret(secret));
}

export async function createRefreshToken(
  userId: string,
  deviceId: string,
  secret: string,
  ttl: number,
): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  return new SignJWT({ sub: userId, deviceId, jti: crypto.randomUUID() })
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt(now)
    .setExpirationTime(now + ttl)
    .sign(getSecret(secret));
}

export async function verifyToken(
  token: string,
  secret: string,
): Promise<JWTPayload | null> {
  try {
    const { payload } = await jwtVerify(token, getSecret(secret));
    return payload;
  } catch {
    return null;
  }
}

export async function createTokenPair(
  userId: string,
  email: string,
  deviceId: string,
  kv: KVNamespace,
  secret: string,
  accessTtl: number,
  refreshTtl: number,
): Promise<{ accessToken: string; refreshToken: string }> {
  const accessToken = await createAccessToken(userId, email, secret, accessTtl);
  const refreshToken = await createRefreshToken(userId, deviceId, secret, refreshTtl);

  await kv.put(
    `refresh:${userId}:${deviceId}`,
    JSON.stringify({ token: refreshToken, createdAt: Date.now() }),
    { expirationTtl: refreshTtl },
  );

  return { accessToken, refreshToken };
}
