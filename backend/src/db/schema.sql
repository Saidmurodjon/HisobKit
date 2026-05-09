-- Foydalanuvchilar
CREATE TABLE IF NOT EXISTS users (
  id           TEXT PRIMARY KEY,
  display_name TEXT,
  email        TEXT UNIQUE NOT NULL,
  google_id    TEXT UNIQUE,
  avatar_url   TEXT,
  public_key   TEXT,
  is_active    INTEGER DEFAULT 1,
  created_at   INTEGER DEFAULT (unixepoch()),
  last_seen_at INTEGER
);

-- Auth providerlar
CREATE TABLE IF NOT EXISTS user_auth_providers (
  id          TEXT PRIMARY KEY,
  user_id     TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  provider    TEXT NOT NULL,
  provider_id TEXT NOT NULL,
  linked_at   INTEGER DEFAULT (unixepoch()),
  UNIQUE(provider, provider_id)
);

-- Qurilmalar
CREATE TABLE IF NOT EXISTS user_devices (
  id          TEXT PRIMARY KEY,
  user_id     TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  device_name TEXT,
  platform    TEXT,
  last_active INTEGER,
  created_at  INTEGER DEFAULT (unixepoch())
);

-- Indekslar
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_google ON users(google_id);
CREATE INDEX IF NOT EXISTS idx_providers_user ON user_auth_providers(user_id);
CREATE INDEX IF NOT EXISTS idx_devices_user ON user_devices(user_id);
