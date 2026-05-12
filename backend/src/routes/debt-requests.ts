import { Hono } from 'hono';
import type { Env } from '../types/env.d.ts';
import { authMiddleware } from '../middleware/auth.middleware.ts';
import { getSql } from '../db/neon.ts';
import { createNotification } from './notifications.ts';

const debtRequests = new Hono<{ Bindings: Env; Variables: { user: Record<string, unknown> } }>();

// ─────────────────────────────────────────────────────────────────────────────
// POST /debt-requests
// Qarz so'rash YOKI qarz berish uchun shartnoma yaratish
// body: {
//   targetUserId?: string      — agar HisobKit foydalanuvchisi bo'lsa
//   targetEmail?: string       — agar foydalanuvchi topilmasa, email orqali taklif
//   amount: number
//   currency: string           — default 'UZS'
//   note?: string
//   debtType: 'borrowed' | 'lent'
//   dueDate?: string           — ISO date
//   contractData?: object      — Islamic contract fields
// }
// ─────────────────────────────────────────────────────────────────────────────
debtRequests.post('/', authMiddleware, async (c) => {
  const user = c.get('user') as Record<string, unknown>;
  const requesterId = user['sub'] as string;
  const requesterEmail = user['email'] as string | undefined;

  const body = await c.req.json<{
    targetUserId?: string;
    targetEmail?: string;
    amount: number;
    currency?: string;
    note?: string;
    debtType: 'borrowed' | 'lent';
    dueDate?: string;
    contractData?: Record<string, unknown>;
  }>();

  if (!body.amount || body.amount <= 0) {
    return c.json({ error: 'Summa noto\'g\'ri' }, 400);
  }
  if (!body.debtType) {
    return c.json({ error: 'debtType shart' }, 400);
  }

  const sql = getSql(c.env.NEON_DATABASE_URL);

  // Requester displayName
  let requesterName = requesterEmail ?? 'Noma\'lum';
  try {
    const profileRows = await sql`
      SELECT display_name FROM user_profiles WHERE user_id = ${requesterId} LIMIT 1
    `;
    if (profileRows[0]) requesterName = String(profileRows[0]['display_name'] || requesterEmail || 'Noma\'lum');
  } catch { /* ignore */ }

  // Resolve targetUserId if only email given
  let targetUserId = body.targetUserId ?? null;
  if (!targetUserId && body.targetEmail) {
    try {
      const rows = await sql`
        SELECT user_id FROM user_profiles WHERE LOWER(email) = ${body.targetEmail.toLowerCase()} LIMIT 1
      `;
      if (rows[0]) targetUserId = String(rows[0]['user_id']);
    } catch { /* ignore */ }
  }

  // Insert debt_requests row
  let requestId: string;
  try {
    const rows = await sql`
      INSERT INTO debt_requests (
        requester_id, requester_name, target_user_id, target_email,
        amount, currency, note, debt_type, due_date, contract_data
      ) VALUES (
        ${requesterId},
        ${requesterName},
        ${targetUserId},
        ${body.targetEmail ?? null},
        ${body.amount},
        ${body.currency ?? 'UZS'},
        ${body.note ?? ''},
        ${body.debtType},
        ${body.dueDate ?? null},
        ${JSON.stringify(body.contractData ?? {})}::jsonb
      )
      RETURNING id
    `;
    requestId = String(rows[0]['id']);
  } catch (e) {
    console.error('Insert debt_request error:', e);
    return c.json({ error: 'Qarz so\'rovini saqlashda xato' }, 500);
  }

  // Send notification to target user (if they exist in HisobKit)
  if (targetUserId) {
    const isLending = body.debtType === 'lent';
    // If requester is lending → notify borrower to confirm
    // If requester is borrowing → notify lender to approve
    const title = isLending
      ? `${requesterName} sizga qarz bermoqchi`
      : `${requesterName} sizdan qarz so'ramoqda`;

    const amtFormatted = Number(body.amount).toLocaleString('uz-UZ');
    const currency = body.currency ?? 'UZS';
    const body2 = isLending
      ? `Summa: ${amtFormatted} ${currency}. Tasdiqlaysizmi?`
      : `Summa: ${amtFormatted} ${currency}. Qabul qilasizmi?`;

    await createNotification(sql, {
      recipientId: targetUserId,
      senderId: requesterId,
      senderName: requesterName,
      type: isLending ? 'debt_offer' : 'debt_request',
      title,
      body: body2,
      data: {
        debtRequestId: requestId,
        amount: body.amount,
        currency: body.currency ?? 'UZS',
        debtType: body.debtType,
        dueDate: body.dueDate ?? null,
        note: body.note ?? '',
        contractData: body.contractData ?? {},
      },
    });
  }

  return c.json({ success: true, requestId });
});

// ─────────────────────────────────────────────────────────────────────────────
// GET /debt-requests/incoming  — o'zimga kelgan so'rovlar
// ─────────────────────────────────────────────────────────────────────────────
debtRequests.get('/incoming', authMiddleware, async (c) => {
  const userId = (c.get('user') as Record<string, unknown>)['sub'] as string;
  const sql = getSql(c.env.NEON_DATABASE_URL);

  try {
    const rows = await sql`
      SELECT id, requester_id, requester_name, amount, currency, note,
             debt_type, due_date, status, contract_data, created_at, expires_at
      FROM debt_requests
      WHERE target_user_id = ${userId} AND status = 'pending'
        AND expires_at > NOW()
      ORDER BY created_at DESC
    `;
    return c.json({ requests: rows });
  } catch (e) {
    console.error('Get incoming requests error:', e);
    return c.json({ error: 'Server xatosi' }, 500);
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// GET /debt-requests/outgoing  — men yuborgan so'rovlar
// ─────────────────────────────────────────────────────────────────────────────
debtRequests.get('/outgoing', authMiddleware, async (c) => {
  const userId = (c.get('user') as Record<string, unknown>)['sub'] as string;
  const sql = getSql(c.env.NEON_DATABASE_URL);

  try {
    const rows = await sql`
      SELECT id, target_user_id, target_email, amount, currency, note,
             debt_type, due_date, status, contract_data, created_at, expires_at
      FROM debt_requests
      WHERE requester_id = ${userId}
      ORDER BY created_at DESC
      LIMIT 30
    `;
    return c.json({ requests: rows });
  } catch (e) {
    console.error('Get outgoing requests error:', e);
    return c.json({ error: 'Server xatosi' }, 500);
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// POST /debt-requests/:id/accept
// ─────────────────────────────────────────────────────────────────────────────
debtRequests.post('/:id/accept', authMiddleware, async (c) => {
  const user = c.get('user') as Record<string, unknown>;
  const userId = user['sub'] as string;
  const requestId = c.req.param('id');
  const sql = getSql(c.env.NEON_DATABASE_URL);

  try {
    const rows = await sql`
      SELECT * FROM debt_requests
      WHERE id = ${requestId} AND target_user_id = ${userId} AND status = 'pending'
      LIMIT 1
    `;

    if (rows.length === 0) {
      return c.json({ error: 'So\'rov topilmadi yoki allaqachon ko\'rib chiqilgan' }, 404);
    }

    const req = rows[0];

    await sql`
      UPDATE debt_requests SET status = 'accepted' WHERE id = ${requestId}
    `;

    // Notify requester about acceptance
    const accepterName = String(await getDisplayName(sql, userId));
    await createNotification(sql, {
      recipientId: String(req['requester_id']),
      senderId: userId,
      senderName: accepterName,
      type: 'debt_accepted',
      title: `${accepterName} qabul qildi`,
      body: `${Number(req['amount']).toLocaleString('uz-UZ')} ${req['currency']} qarz so\'rovi qabul qilindi.`,
      data: {
        debtRequestId: requestId,
        amount: req['amount'],
        currency: req['currency'],
        debtType: req['debt_type'],
      },
    });

    return c.json({ success: true });
  } catch (e) {
    console.error('Accept debt request error:', e);
    return c.json({ error: 'Server xatosi' }, 500);
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// POST /debt-requests/:id/reject
// ─────────────────────────────────────────────────────────────────────────────
debtRequests.post('/:id/reject', authMiddleware, async (c) => {
  const user = c.get('user') as Record<string, unknown>;
  const userId = user['sub'] as string;
  const requestId = c.req.param('id');
  const { reason } = await c.req.json<{ reason?: string }>().catch(() => ({ reason: undefined }));
  const sql = getSql(c.env.NEON_DATABASE_URL);

  try {
    const rows = await sql`
      SELECT * FROM debt_requests
      WHERE id = ${requestId} AND target_user_id = ${userId} AND status = 'pending'
      LIMIT 1
    `;

    if (rows.length === 0) {
      return c.json({ error: 'So\'rov topilmadi' }, 404);
    }

    const req = rows[0];

    await sql`
      UPDATE debt_requests SET status = 'rejected' WHERE id = ${requestId}
    `;

    // Notify requester about rejection
    const rejecterName = String(await getDisplayName(sql, userId));
    await createNotification(sql, {
      recipientId: String(req['requester_id']),
      senderId: userId,
      senderName: rejecterName,
      type: 'debt_rejected',
      title: `${rejecterName} rad etdi`,
      body: reason
        ? `Sabab: ${reason}`
        : `${Number(req['amount']).toLocaleString('uz-UZ')} ${req['currency']} qarz so\'rovi rad etildi.`,
      data: {
        debtRequestId: requestId,
        reason: reason ?? '',
        amount: req['amount'],
        currency: req['currency'],
      },
    });

    return c.json({ success: true });
  } catch (e) {
    console.error('Reject debt request error:', e);
    return c.json({ error: 'Server xatosi' }, 500);
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// Helper: get display_name from user_profiles
// ─────────────────────────────────────────────────────────────────────────────
async function getDisplayName(
  sql: ReturnType<typeof getSql>,
  userId: string,
): Promise<string> {
  try {
    const rows = await sql`SELECT display_name FROM user_profiles WHERE user_id = ${userId} LIMIT 1`;
    return String(rows[0]?.['display_name'] ?? 'Noma\'lum');
  } catch {
    return 'Noma\'lum';
  }
}

export default debtRequests;
