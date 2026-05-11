function emailTemplate(otp: string): string {
  const cells = otp.split('').map(d =>
    `<td style="padding:0 5px;"><div style="width:48px;height:56px;line-height:56px;text-align:center;background:#F4F6F9;border:2px solid #0A2540;border-radius:10px;font-size:28px;font-weight:700;font-family:monospace,Courier,sans-serif;color:#0A2540;">${d}</div></td>`
  ).join('');

  return `<!DOCTYPE html>
<html lang="uz">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>HisobKit — Tasdiqlash kodi</title>
</head>
<body style="margin:0;padding:0;background-color:#F0F2F5;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" role="presentation" style="background:#F0F2F5;padding:40px 16px;">
    <tr><td align="center">
      <table width="100%" cellpadding="0" cellspacing="0" role="presentation" style="max-width:480px;">

        <!-- Card -->
        <tr>
          <td style="background:#ffffff;border-radius:20px;box-shadow:0 4px 32px rgba(0,0,0,0.08);overflow:hidden;">
            <table width="100%" cellpadding="0" cellspacing="0" role="presentation">

              <!-- Header -->
              <tr>
                <td style="background:#0A2540;padding:28px 32px 24px;text-align:center;">
                  <div style="font-size:24px;font-weight:800;color:#ffffff;letter-spacing:-0.5px;">&#128176; HisobKit</div>
                  <div style="font-size:14px;color:rgba(255,255,255,0.65);margin-top:6px;">Bir martalik tasdiqlash kodi</div>
                </td>
              </tr>

              <!-- OTP digits — 6 boxes in one row -->
              <tr>
                <td style="padding:36px 32px 24px;text-align:center;">
                  <div style="font-size:12px;font-weight:600;color:#6B7280;letter-spacing:0.8px;text-transform:uppercase;margin-bottom:16px;">Tasdiqlash kodi</div>
                  <table cellpadding="0" cellspacing="0" role="presentation" style="margin:0 auto;">
                    <tr>${cells}</tr>
                  </table>
                </td>
              </tr>

              <!-- Warning block -->
              <tr>
                <td style="padding:0 32px 32px;">
                  <table width="100%" cellpadding="0" cellspacing="0" role="presentation">
                    <tr>
                      <td style="background:#FFF8E7;border-left:4px solid #FFAB00;border-radius:0 10px 10px 0;padding:14px 16px;">
                        <div style="font-size:13px;font-weight:600;color:#92400E;margin-bottom:3px;">&#9888;&#65039; Muhim</div>
                        <div style="font-size:12px;color:#92400E;line-height:1.5;">Kodni <strong>hech kimga bermang</strong>. HisobKit xodimlari hech qachon sizdan kodni so'ramaydi.</div>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

            </table>
          </td>
        </tr>

        <!-- Footer -->
        <tr>
          <td style="padding:20px 0;text-align:center;">
            <div style="font-size:12px;color:#9CA3AF;">HisobKit &bull; 5 daqiqa amal qiladi</div>
            <div style="font-size:11px;color:#D1D5DB;margin-top:4px;">Ushbu xat avtomatik yuborilgan. Javob bermang.</div>
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
