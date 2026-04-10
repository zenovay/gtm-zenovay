# Zenovay Analytics — Google Tag Manager Template

Deploy [Zenovay Analytics](https://zenovay.com) on your website through Google Tag Manager without touching a single line of code.

[![Template Gallery](https://img.shields.io/badge/GTM-Community%20Template-blue?logo=googletagmanager)](https://tagmanager.google.com/gallery/)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)

---

## Installation

### Option A — GTM Community Template Gallery (Recommended)

1. Open [Google Tag Manager](https://tagmanager.google.com) and select your container
2. Go to **Templates** in the left sidebar
3. Click **Search Gallery** in the Tag Templates section
4. Search for **"Zenovay"**
5. Click **Zenovay Analytics** → **Add to workspace**
6. Go to **Tags** → **New** → choose **Zenovay Analytics** under Custom
7. Enter your **Tracking Code** (from your [Zenovay dashboard](https://app.zenovay.com) under Settings → General)
8. Set trigger to **All Pages**
9. **Save** → **Submit** → **Publish**

Done. Your visitors are being tracked.

---

### Option B — Import from this Repository

If the template is not yet in the gallery:

1. Download [`template.tpl`](template.tpl) from this repository
2. In GTM, go to **Templates** → **New** (Tag Templates)
3. Click the **⋮** menu in the top-right → **Import**
4. Select the downloaded `template.tpl` file
5. Click **Save**
6. Follow steps 6–9 from Option A above

---

## Configuration

| Field | Required | Default | Description |
|---|---|---|---|
| **Tracking Code** | Yes | — | Your unique site ID from the Zenovay dashboard |
| **Cookieless Mode** | No | Off | Track without cookies (GDPR-safe, no consent needed) |
| **Track Outbound Links** | No | Off | Auto-track clicks to external domains |
| **Custom API URL** | No | `https://api.zenovay.com` | First-party proxy URL (all plans, requires proxy setup) |
| **Debug Mode** | No | Off | Verbose console logging — disable in production |

---

## First-Party Proxy (Ad-Blocker Bypass)

Available on **all plans**. Set up a proxy subdomain on your own domain, then paste the URL into the **Custom API URL** field in the template:

```
https://analytics.yourdomain.com
```

The template will load `z.js` from your proxy and route all tracking requests through it — completely bypassing ad-blockers.

See the [First-Party Proxy guide](https://docs.zenovay.com/guides/first-party-tracking) for setup instructions.

---

## How It Works

The template uses GTM's sandboxed JavaScript APIs:

1. `setInWindow('ZENOVAY_TRACKER_CONFIG', config)` — writes your configuration to `window` **before** the script loads, so the tracker picks it up in its highest-priority config path
2. `injectScript('https://api.zenovay.com/z.js')` — loads the tracker from the Zenovay CDN (or your proxy)

No tracking source code is included in this template — it only references the CDN URL.

---

## SPA (React, Next.js, Vue, Angular)

The Zenovay script automatically detects SPA route changes via the History API. The **All Pages** trigger is all you need — no History Change trigger required.

---

## Consent Mode

If you use a CMP (CookieYes, OneTrust, Cookiebot):

1. Edit your Zenovay Analytics tag
2. Go to **Advanced Settings** → **Consent Settings**
3. Set **Require additional consent**: `analytics_storage`

Or enable **Cookieless Mode** — then no consent is required at all.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Tag shows as "paused" in Preview | Check that the trigger is set to **All Pages** |
| No data in dashboard | Verify the Tracking Code matches your dashboard |
| Duplicate page views | Ensure Zenovay is only loaded via GTM, not also in `<head>` |
| Script blocked by ad-blocker | Enable the First-Party Proxy (Scale+ plan) |

---

## Links

- [Zenovay Dashboard](https://app.zenovay.com)
- [Documentation](https://docs.zenovay.com/integrations/gtm)
- [Full Tracking Script Reference](https://docs.zenovay.com/tracking/tracking-script)
- [Support](mailto:support@zenovay.com)
