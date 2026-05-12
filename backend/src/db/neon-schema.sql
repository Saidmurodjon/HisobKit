-- ═══════════════════════════════════════════════════════════════════
-- HisobKit — Neon PostgreSQL sxemasi
-- Neon console → SQL Editor da bir marta ishga tushiring
-- ═══════════════════════════════════════════════════════════════════

-- ── Foydalanuvchi ma'lumotlari (account-based sync) ────────────────
CREATE TABLE IF NOT EXISTS user_data (
  id          TEXT        PRIMARY KEY DEFAULT gen_random_uuid()::text,
  user_id     TEXT        NOT NULL,
  data_type   TEXT        NOT NULL,   -- 'transactions' | 'debts' | 'house'
  payload     TEXT        NOT NULL,   -- JSON string
  version     INTEGER     NOT NULL DEFAULT 1,
  synced_at   BIGINT      NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT,
  UNIQUE (user_id, data_type)
);
CREATE INDEX IF NOT EXISTS idx_user_data_user ON user_data(user_id);

-- ── Hisob-kitob davrlari ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS settlement_periods (
  id          SERIAL      PRIMARY KEY,
  group_uuid  TEXT        NOT NULL,          -- local group identifier
  owner_id    TEXT        NOT NULL,          -- user who created
  title       TEXT        NOT NULL,
  start_date  DATE        NOT NULL,
  end_date    DATE        NOT NULL,
  status      TEXT        NOT NULL DEFAULT 'draft',
  -- draft | proposed | confirming | disputed | signed | archived
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_sp_group  ON settlement_periods(group_uuid);
CREATE INDEX IF NOT EXISTS idx_sp_owner  ON settlement_periods(owner_id);

-- ── Davr a'zolari ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS period_members (
  id          SERIAL      PRIMARY KEY,
  period_id   INTEGER     NOT NULL REFERENCES settlement_periods(id) ON DELETE CASCADE,
  name        TEXT        NOT NULL,
  color       TEXT        NOT NULL DEFAULT '#00C896',
  user_id     TEXT,                          -- linked HisobKit user (optional)
  local_id    INTEGER                        -- local Drift member id
);

-- ── Davr xarajatlari ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS period_expenses (
  id              SERIAL      PRIMARY KEY,
  period_id       INTEGER     NOT NULL REFERENCES settlement_periods(id) ON DELETE CASCADE,
  paid_by_id      INTEGER     NOT NULL REFERENCES period_members(id),
  title           TEXT        NOT NULL,
  amount          NUMERIC(15,2) NOT NULL DEFAULT 0,
  currency        TEXT        NOT NULL DEFAULT 'UZS',
  date            DATE        NOT NULL DEFAULT CURRENT_DATE,
  category        TEXT        NOT NULL DEFAULT 'other',
  note            TEXT        NOT NULL DEFAULT '',
  is_recurring    BOOLEAN     NOT NULL DEFAULT FALSE
);

-- ── Xarajat bo'limlari ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS period_expense_splits (
  id          SERIAL      PRIMARY KEY,
  expense_id  INTEGER     NOT NULL REFERENCES period_expenses(id) ON DELETE CASCADE,
  member_id   INTEGER     NOT NULL REFERENCES period_members(id),
  share_amt   NUMERIC(15,2) NOT NULL DEFAULT 0
);

-- ── Hisob-kitob takliflari ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS settlement_proposals (
  id           SERIAL      PRIMARY KEY,
  period_id    INTEGER     NOT NULL REFERENCES settlement_periods(id) ON DELETE CASCADE,
  proposed_by  TEXT        NOT NULL,         -- user_id
  proposed_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  signed_at    TIMESTAMPTZ
);

-- ── A'zolar tasdiqlash holati ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS settlement_confirmations (
  id              SERIAL      PRIMARY KEY,
  proposal_id     INTEGER     NOT NULL REFERENCES settlement_proposals(id) ON DELETE CASCADE,
  member_id       INTEGER     NOT NULL REFERENCES period_members(id),
  status          TEXT        NOT NULL DEFAULT 'pending',
  -- pending | confirmed | disputed
  dispute_reason  TEXT,
  responded_at    TIMESTAMPTZ
);

-- ── Minimal o'tkazmalar ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS settlement_transfers (
  id            SERIAL      PRIMARY KEY,
  period_id     INTEGER     NOT NULL REFERENCES settlement_periods(id) ON DELETE CASCADE,
  from_member   INTEGER     NOT NULL REFERENCES period_members(id),
  to_member     INTEGER     NOT NULL REFERENCES period_members(id),
  amount        NUMERIC(15,2) NOT NULL,
  is_paid       BOOLEAN     NOT NULL DEFAULT FALSE
);

-- ── Audit log (o'zgarmas) ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS settlement_events (
  id          SERIAL      PRIMARY KEY,
  period_id   INTEGER     NOT NULL REFERENCES settlement_periods(id) ON DELETE CASCADE,
  event_type  TEXT        NOT NULL,
  actor       TEXT,                          -- user_id or member name
  data        JSONB,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_se_period ON settlement_events(period_id);
