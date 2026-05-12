import { Hono } from 'hono';
import type { Env } from '../types/env.d.ts';
import { authMiddleware } from '../middleware/auth.middleware.ts';
import { getSql } from '../db/neon.ts';

const settlement = new Hono<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>();

settlement.use('*', authMiddleware);

// ── Minimal o'tkazmalar algoritmi (greedy) ────────────────────────────────────
function calcMinimalTransfers(
  balances: { memberId: number; name: string; balance: number }[],
) {
  const creditors = balances
    .filter((b) => b.balance > 0.5)
    .sort((a, b) => b.balance - a.balance)
    .map((b) => ({ ...b }));

  const debtors = balances
    .filter((b) => b.balance < -0.5)
    .sort((a, b) => a.balance - b.balance)
    .map((b) => ({ ...b, balance: Math.abs(b.balance) }));

  const transfers: { fromId: number; fromName: string; toId: number; toName: string; amount: number }[] = [];

  while (creditors.length > 0 && debtors.length > 0) {
    const cred = creditors[0];
    const debt = debtors[0];
    const amount = Math.min(cred.balance, debt.balance);

    transfers.push({
      fromId: debt.memberId,
      fromName: debt.name,
      toId: cred.memberId,
      toName: cred.name,
      amount: Math.round(amount),
    });

    cred.balance -= amount;
    debt.balance -= amount;

    if (cred.balance < 0.5) creditors.shift();
    if (debt.balance < 0.5) debtors.shift();
  }

  return transfers;
}

// ── Davr balanslarini hisoblash ───────────────────────────────────────────────
async function computeBalances(sql: ReturnType<typeof getSql>, periodId: number) {
  // Barcha a'zolar
  const members = await sql<{ id: number; name: string }[]>`
    SELECT id, name FROM period_members WHERE period_id = ${periodId}
  `;

  // Xarajatlar + bo'linmalar
  const expenses = await sql<{ id: number; paid_by_id: number; amount: string }[]>`
    SELECT id, paid_by_id, amount FROM period_expenses WHERE period_id = ${periodId}
  `;

  const splits = await sql<{ expense_id: number; member_id: number; share_amt: string }[]>`
    SELECT s.expense_id, s.member_id, s.share_amt
    FROM period_expense_splits s
    JOIN period_expenses e ON e.id = s.expense_id
    WHERE e.period_id = ${periodId}
  `;

  // Balanslar: to'lagan - iste'mol qilgan
  const bal: Record<number, number> = {};
  for (const m of members) bal[m.id] = 0;

  for (const exp of expenses) {
    bal[exp.paid_by_id] = (bal[exp.paid_by_id] ?? 0) + Number(exp.amount);
  }
  for (const s of splits) {
    bal[s.member_id] = (bal[s.member_id] ?? 0) - Number(s.share_amt);
  }

  return members.map((m) => ({
    memberId: m.id,
    name: m.name,
    balance: Math.round(bal[m.id] ?? 0),
  }));
}

// ────────────────────────────────────────────────────────────────────────────
// DAVRLAR
// ────────────────────────────────────────────────────────────────────────────

// GET /settlement/periods?groupUuid=...
settlement.get('/periods', async (c) => {
  const userId = (c.get('user') as { sub: string }).sub;
  const groupUuid = c.req.query('groupUuid');
  if (!groupUuid) return c.json({ error: 'groupUuid talab qilinadi' }, 400);

  const sql = getSql(c.env.NEON_DATABASE_URL);
  const rows = await sql<{
    id: number; title: string; start_date: string; end_date: string;
    status: string; created_at: string; owner_id: string;
  }[]>`
    SELECT id, title, start_date, end_date, status, created_at, owner_id
    FROM settlement_periods
    WHERE group_uuid = ${groupUuid} AND owner_id = ${userId}
    ORDER BY created_at DESC
  `;

  return c.json({ success: true, periods: rows });
});

// POST /settlement/periods — yangi davr yaratish
settlement.post('/periods', async (c) => {
  const userId = (c.get('user') as { sub: string }).sub;
  const body = await c.req.json<{
    groupUuid: string; title: string; startDate: string; endDate: string;
    members: { name: string; color?: string; userId?: string; localId?: number }[];
  }>();

  if (!body.groupUuid || !body.title || !body.startDate || !body.endDate) {
    return c.json({ error: 'groupUuid, title, startDate, endDate talab qilinadi' }, 400);
  }

  const sql = getSql(c.env.NEON_DATABASE_URL);

  // Davr yaratish
  const [period] = await sql<{ id: number }[]>`
    INSERT INTO settlement_periods (group_uuid, owner_id, title, start_date, end_date)
    VALUES (${body.groupUuid}, ${userId}, ${body.title}, ${body.startDate}, ${body.endDate})
    RETURNING id
  `;

  // A'zolarni qo'shish
  const memberIds: number[] = [];
  for (const m of (body.members ?? [])) {
    const [mem] = await sql<{ id: number }[]>`
      INSERT INTO period_members (period_id, name, color, user_id, local_id)
      VALUES (${period.id}, ${m.name}, ${m.color ?? '#00C896'}, ${m.userId ?? null}, ${m.localId ?? null})
      RETURNING id
    `;
    memberIds.push(mem.id);
  }

  // Audit log
  await sql`
    INSERT INTO settlement_events (period_id, event_type, actor, data)
    VALUES (${period.id}, 'created', ${userId}, ${JSON.stringify({ title: body.title })})
  `;

  return c.json({ success: true, periodId: period.id, memberIds });
});

// GET /settlement/periods/:id — davr tafsilotlari
settlement.get('/periods/:id', async (c) => {
  const periodId = Number(c.req.param('id'));
  const sql = getSql(c.env.NEON_DATABASE_URL);

  const [period] = await sql<{
    id: number; title: string; start_date: string; end_date: string;
    status: string; owner_id: string;
  }[]>`
    SELECT * FROM settlement_periods WHERE id = ${periodId}
  `;
  if (!period) return c.json({ error: 'Davr topilmadi' }, 404);

  const members = await sql<{ id: number; name: string; color: string; local_id: number | null }[]>`
    SELECT id, name, color, local_id FROM period_members WHERE period_id = ${periodId}
  `;

  const expenses = await sql<{
    id: number; paid_by_id: number; title: string; amount: string;
    currency: string; date: string; category: string; note: string;
  }[]>`
    SELECT id, paid_by_id, title, amount, currency, date, category, note
    FROM period_expenses WHERE period_id = ${periodId}
    ORDER BY date DESC
  `;

  const splits = await sql<{ id: number; expense_id: number; member_id: number; share_amt: string }[]>`
    SELECT s.id, s.expense_id, s.member_id, s.share_amt
    FROM period_expense_splits s
    JOIN period_expenses e ON e.id = s.expense_id
    WHERE e.period_id = ${periodId}
  `;

  return c.json({ success: true, period, members, expenses, splits });
});

// ────────────────────────────────────────────────────────────────────────────
// XARAJATLAR
// ────────────────────────────────────────────────────────────────────────────

// POST /settlement/periods/:id/expenses
settlement.post('/periods/:id/expenses', async (c) => {
  const periodId = Number(c.req.param('id'));
  const body = await c.req.json<{
    paidById: number; title: string; amount: number; currency?: string;
    date?: string; category?: string; note?: string;
    splits: { memberId: number; shareAmt: number }[];
  }>();

  const sql = getSql(c.env.NEON_DATABASE_URL);

  const [exp] = await sql<{ id: number }[]>`
    INSERT INTO period_expenses
      (period_id, paid_by_id, title, amount, currency, date, category, note)
    VALUES (
      ${periodId}, ${body.paidById}, ${body.title}, ${body.amount},
      ${body.currency ?? 'UZS'}, ${body.date ?? new Date().toISOString().slice(0, 10)},
      ${body.category ?? 'other'}, ${body.note ?? ''}
    )
    RETURNING id
  `;

  for (const s of body.splits) {
    await sql`
      INSERT INTO period_expense_splits (expense_id, member_id, share_amt)
      VALUES (${exp.id}, ${s.memberId}, ${s.shareAmt})
    `;
  }

  return c.json({ success: true, expenseId: exp.id });
});

// DELETE /settlement/expenses/:id
settlement.delete('/expenses/:id', async (c) => {
  const id = Number(c.req.param('id'));
  const sql = getSql(c.env.NEON_DATABASE_URL);
  await sql`DELETE FROM period_expenses WHERE id = ${id}`;
  return c.json({ success: true });
});

// ────────────────────────────────────────────────────────────────────────────
// BALANSLAR VA HISOB-KITOB
// ────────────────────────────────────────────────────────────────────────────

// GET /settlement/periods/:id/balances
settlement.get('/periods/:id/balances', async (c) => {
  const periodId = Number(c.req.param('id'));
  const sql = getSql(c.env.NEON_DATABASE_URL);

  const balances = await computeBalances(sql, periodId);
  const transfers = calcMinimalTransfers(balances);

  const total = await sql<{ s: string }[]>`
    SELECT COALESCE(SUM(amount), 0) AS s FROM period_expenses WHERE period_id = ${periodId}
  `;
  const totalAmount = Number(total[0]?.s ?? 0);

  return c.json({ success: true, balances, transfers, totalAmount });
});

// POST /settlement/periods/:id/propose — hisob-kitob taklif qilish
settlement.post('/periods/:id/propose', async (c) => {
  const periodId = Number(c.req.param('id'));
  const userId = (c.get('user') as { sub: string }).sub;
  const sql = getSql(c.env.NEON_DATABASE_URL);

  // Balanslar va minimal o'tkazmalar
  const balances = await computeBalances(sql, periodId);
  const transfers = calcMinimalTransfers(balances);

  // Proposal yaratish
  const [proposal] = await sql<{ id: number }[]>`
    INSERT INTO settlement_proposals (period_id, proposed_by)
    VALUES (${periodId}, ${userId})
    RETURNING id
  `;

  // Minimal o'tkazmalar saqlanadi
  await sql`DELETE FROM settlement_transfers WHERE period_id = ${periodId}`;
  for (const t of transfers) {
    await sql`
      INSERT INTO settlement_transfers (period_id, from_member, to_member, amount)
      VALUES (${periodId}, ${t.fromId}, ${t.toId}, ${t.amount})
    `;
  }

  // Har a'zo uchun confirmation = pending
  const members = await sql<{ id: number }[]>`
    SELECT id FROM period_members WHERE period_id = ${periodId}
  `;
  for (const m of members) {
    await sql`
      INSERT INTO settlement_confirmations (proposal_id, member_id)
      VALUES (${proposal.id}, ${m.id})
      ON CONFLICT DO NOTHING
    `;
  }

  // Davr statusini 'proposed' ga o'zgartirish
  await sql`
    UPDATE settlement_periods SET status = 'proposed' WHERE id = ${periodId}
  `;

  // Audit log
  await sql`
    INSERT INTO settlement_events (period_id, event_type, actor, data)
    VALUES (${periodId}, 'proposed', ${userId},
      ${JSON.stringify({ transfersCount: transfers.length, balances })})
  `;

  return c.json({ success: true, proposalId: proposal.id, balances, transfers });
});

// POST /settlement/proposals/:id/confirm — tasdiqlash yoki ixtilof
settlement.post('/proposals/:id/confirm', async (c) => {
  const proposalId = Number(c.req.param('id'));
  const userId = (c.get('user') as { sub: string }).sub;
  const body = await c.req.json<{
    memberId: number;
    status: 'confirmed' | 'disputed';
    disputeReason?: string;
  }>();

  const sql = getSql(c.env.NEON_DATABASE_URL);

  // Confirmation yangilash
  await sql`
    UPDATE settlement_confirmations
    SET status = ${body.status},
        dispute_reason = ${body.disputeReason ?? null},
        responded_at = NOW()
    WHERE proposal_id = ${proposalId} AND member_id = ${body.memberId}
  `;

  // Period id ni topish
  const [prop] = await sql<{ period_id: number }[]>`
    SELECT period_id FROM settlement_proposals WHERE id = ${proposalId}
  `;

  if (body.status === 'disputed') {
    // Davr 'disputed' holatiga o'tadi
    await sql`
      UPDATE settlement_periods SET status = 'disputed'
      WHERE id = ${prop.period_id}
    `;
    await sql`
      INSERT INTO settlement_events (period_id, event_type, actor, data)
      VALUES (${prop.period_id}, 'disputed', ${userId},
        ${JSON.stringify({ memberId: body.memberId, reason: body.disputeReason })})
    `;
    return c.json({ success: true, newStatus: 'disputed' });
  }

  // Barcha confirmed bo'ldimi?
  const [counts] = await sql<{ total: number; confirmed: number }[]>`
    SELECT
      COUNT(*) AS total,
      COUNT(*) FILTER (WHERE status = 'confirmed') AS confirmed
    FROM settlement_confirmations
    WHERE proposal_id = ${proposalId}
  `;

  const allSigned = Number(counts.confirmed) >= Number(counts.total) && Number(counts.total) > 0;

  if (allSigned) {
    await sql`
      UPDATE settlement_periods SET status = 'signed' WHERE id = ${prop.period_id}
    `;
    await sql`
      UPDATE settlement_proposals SET signed_at = NOW() WHERE id = ${proposalId}
    `;
    await sql`
      INSERT INTO settlement_events (period_id, event_type, actor, data)
      VALUES (${prop.period_id}, 'signed', ${userId},
        ${JSON.stringify({ proposalId, confirmedBy: body.memberId })})
    `;
  } else {
    await sql`
      UPDATE settlement_periods SET status = 'confirming' WHERE id = ${prop.period_id}
    `;
  }

  return c.json({
    success: true,
    newStatus: allSigned ? 'signed' : 'confirming',
    confirmedCount: Number(counts.confirmed),
    totalCount: Number(counts.total),
  });
});

// POST /settlement/periods/:id/archive — arxivlash (signed bo'lgan davr)
settlement.post('/periods/:id/archive', async (c) => {
  const periodId = Number(c.req.param('id'));
  const userId = (c.get('user') as { sub: string }).sub;
  const sql = getSql(c.env.NEON_DATABASE_URL);

  await sql`
    UPDATE settlement_periods SET status = 'archived' WHERE id = ${periodId}
  `;
  await sql`
    INSERT INTO settlement_events (period_id, event_type, actor)
    VALUES (${periodId}, 'archived', ${userId})
  `;

  return c.json({ success: true });
});

// POST /settlement/periods/:id/reopen — ixtilof tuzatib qayta taklif
settlement.post('/periods/:id/reopen', async (c) => {
  const periodId = Number(c.req.param('id'));
  const sql = getSql(c.env.NEON_DATABASE_URL);
  await sql`
    UPDATE settlement_periods SET status = 'draft' WHERE id = ${periodId}
  `;
  return c.json({ success: true });
});

// GET /settlement/periods/:id/events — audit log
settlement.get('/periods/:id/events', async (c) => {
  const periodId = Number(c.req.param('id'));
  const sql = getSql(c.env.NEON_DATABASE_URL);
  const events = await sql<{
    id: number; event_type: string; actor: string | null;
    data: unknown; occurred_at: string;
  }[]>`
    SELECT id, event_type, actor, data, occurred_at
    FROM settlement_events
    WHERE period_id = ${periodId}
    ORDER BY occurred_at DESC
  `;
  return c.json({ success: true, events });
});

export default settlement;
