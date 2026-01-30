# Browser-Based Credential Setup (Permanent)

When the agent needs to fetch Shopify (or GitHub/Cloudflare) credentials using **your** browser, this flow is used. The agent uses the Cursor browser extension to control your browser—no separate or headless browser.

## Permanent setup (one-time, secure)

- **Where credentials live**: Only in **`.env.local`** in the repo root. This file is in `.gitignore` and is never committed.
- **One-time**: Get your Admin API token (`shpat_...`) once (see options below), then run `.\scripts\shopify\browser\save-token-to-env.ps1` (with token in clipboard or `-Token 'shpat_...'`). All scripts and the runbook load from `.env.local`.
- **Secure**: The agent may read/write `.env.local` only for setup. It must never commit `.env.local` or any file containing secrets, and never log or echo tokens or passwords. See `.cursor/rules/env-credentials.mdc`.

**Note (Shopify Admin API token):** In the current Shopify Admin and Dev Dashboard (dev.shopify.com), the Admin API access token (`shpat_...`) is not shown on the app installation or version pages. You can still complete setup using one of the options below.

## One-time: Log in when asked

1. The agent will navigate to the service (e.g. Shopify login, GitHub tokens).
2. **You** log in in that tab (email/password or passkey). The agent never sees or stores your password.
3. Once you're in (e.g. Shopify Admin), tell the agent **"logged in"** or **"done"**.
4. The agent will then navigate to the credentials page (e.g. Apps → Development → API credentials), extract the token from the page, and write it to `.env.local`.

## What the agent does

- **Navigate**: Opens the correct URL (Shopify Admin, GitHub tokens, etc.).
- **Snapshot**: Reads the page (accessibility tree) to find the access token or "Reveal" button.
- **Click** (if needed): Clicks "Reveal" / "Show" to expose the token.
- **Extract**: Gets the token value (e.g. `shpat_...`) from the page.
- **Save**: Updates `.env.local` with the new value (never commits).

## Client credentials (Dev Dashboard apps)

If your app is in the **Dev Dashboard** (dev.shopify.com) and you have **Client ID** and **Secret** from App → Settings → Credentials:

1. Put `SHOPIFY_API_KEY` (Client ID) and `SHOPIFY_API_SECRET` (Secret) in `.env.local`.
2. Run: `.\scripts\shopify\browser\get-token-client-credentials.ps1`
3. The script gets an access token via the client credentials grant and writes `SHOPIFY_ACCESS_TOKEN` to `.env.local`.
4. Verify with: `.\scripts\run-runbook.ps1`

(For custom domains like aodrop.com, the script uses the store’s myshopify domain for the OAuth endpoint.)

## If the token isn't visible in the browser

Shopify’s new Admin/Dev Dashboard often doesn’t show the Admin API access token on the UI. Use one of these:

1. **Dev Dashboard:** In [Dev Dashboard](https://dev.shopify.com/dashboard) → your app (AO) → check for "API credentials", "Reveal token", or install-specific credentials. If your app version exposes a token there, copy it and run: `.\scripts\shopify\browser\save-token-to-env.ps1` (with token in clipboard).
2. **Playwright + your Chrome:** Close Chrome, run `.\scripts\shopify\browser\launch-chrome-for-agent.ps1`, log in to Shopify in the opened window, then run `.\scripts\shopify\browser\get-access-token.ps1`. The script connects to that Chrome and may be able to extract the token from the app’s OAuth/credentials flow.
3. **Manual:** In Shopify Admin → Settings → Apps and sales channels → Develop apps (or App development), if there is a "Custom app" or "API credentials" section that shows or reveals the Admin API access token, copy it, then run `.\scripts\shopify\browser\save-token-to-env.ps1` (paste token when prompted or from clipboard).

## Optional: Use your existing Chrome with Playwright

If you prefer the repo's Playwright scripts (e.g. `.\scripts\shopify\browser\get-access-token.ps1`) to connect to **your** Chrome:

1. Close Chrome.
2. Launch Chrome with remote debugging:
   ```powershell
   & "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222
   ```
   Or use the shortcut in `scripts/shopify/browser/` if provided.
3. Log in to Shopify (or the service) in that Chrome window.
4. Run: `.\scripts\shopify\browser\get-access-token.ps1`
5. The script connects to your Chrome, navigates to Apps → Development, extracts the token, and saves to `.env.local`.

## Security (permanent)

- Credentials are written only to `.env.local` (gitignored); this is the single source of truth.
- The agent may edit `.env.local` only to complete setup; it must never commit it or log secrets.
- Passwords are never entered by the agent; you log in yourself.
- Rule `.cursor/rules/env-credentials.mdc` enforces: no commit of `.env.local`, no logging of tokens or API keys.
