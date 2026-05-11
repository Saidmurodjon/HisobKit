function emailTemplate(otp: string): string {
  const digits = otp.split('').map(d =>
    `<span style="display:inline-block;width:44px;height:54px;line-height:54px;text-align:center;font-size:28px;font-weight:700;background:#f0f4f8;border-radius:8px;margin:0 4px;color:#0A2540;">${d}</span>`
  ).join('');

  return `<!DOCTYPE html>
<html lang="uz">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"></head>
<body style="margin:0;padding:0;background:#f5f7fa;font-family:Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#f5f7fa;padding:40px 0;">
    <tr><td align="center">
      <table width="480" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);">
        <tr>
          <td style="background:linear-gradient(135deg,#0A2540,#163A5E);padding:32px;text-align:center;">
            <div style="font-size:28px;font-weight:800;color:#ffffff;letter-spacing:-0.5px;">HisobKit</div>
            <div style="font-size:13px;color:#00C896;margin-top:4px;">Moliyaviy boshqaruv</div>
          </td>
        </tr>
        <tr>
          <td style="padding:40px 32px;text-align:center;">
            <div style="font-size:16px;color:#4B5563;margin-bottom:8px;">Sizning tasdiqlash kodingiz:</div>
            <div style="margin:24px 0;">${digits}</div>
            <div style="display:inline-block;background:#FFF3CD;border-radius:8px;padding:10px 20px;font-size:13px;color:#856404;margin-bottom:24px;">
              ⏱ Kod <strong>5 daqiqa</strong> amal qiladi
            </div>
            <div style="font-size:13px;color:#9CA3AF;border-top:1px solid #f0f0f0;padding-top:20px;">
              Agar siz so'ramagan bo'lsangiz — ushbu xatni e'tiborsiz qoldiring.
            </div>
          </td>
        </tr>
        <tr>
          <td style="background:#f9fafb;padding:16px 32px;text-align:center;">
            <div style="font-size:11px;color:#9CA3AF;">© 2025 HisobKit. Barcha huquqlar himoyalangan.</div>
          </td>
        </tr>
      </table>
    </td></tr>
  </table>
</body>
</html>`;
}

export async function sendOtpEmail(
  to: string,
  otp: string,
  apiKey: string,
  from: string,
): Promise<{ ok: boolean; error?: string }> {
  try {
    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from,
        to: [to],
        subject: 'HisobKit — Tasdiqlash kodi',
        html: emailTemplate(otp),
      }),
    });
    if (!res.ok) {
      const body = await res.text().catch(() => '');
      console.error(`[Resend] ${res.status} ${res.statusText} — ${body}`);
      return { ok: false, error: `Resend ${res.status}: ${body}` };
    }
    return { ok: true };
  } catch (err) {
    console.error('[Resend] fetch error:', err);
    return { ok: false, error: String(err) };
  }
}
