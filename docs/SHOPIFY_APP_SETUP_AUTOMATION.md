# Shopify app setup automation (permanent use from Cursor)

**Purpose:** One place for how to navigate, edit, and set up the Shopify app for full API access from the Cursor desktop app—using e2e (Playwright), optional desktop automation (screen/PC control), and scripts.

---

## One-command setup (recommended)

From repo root in Cursor (or any terminal):

```powershell
.\scripts\shopify\setup-app-access.ps1
```

- If Chrome is **already** running with remote debugging (port 9222) and you’re logged into Shopify Admin, the script connects to it, navigates to **Apps → Development** (using store ID when set), extracts the Admin API token, and saves it to `.env.local`. Then it runs the runbook and verify-pipeline.
- If Chrome is **not** running with debugging, run with **launch first**:

```powershell
.\scripts\shopify\setup-app-access.ps1 -LaunchChrome
```

Then in the opened Chrome window: log in to Shopify, go to **Apps → Development → [your app] → API credentials**, click **Reveal**, and when the token is visible press Enter in the terminal. The script continues with extraction and verification.

Optional:

- `-StoreDomain aodrop.com` (default if not in `.env.local`)
- `-SkipVerify` to only extract/save the token and skip runbook + pipeline

---

## How navigation works (e2e)

1. **Store ID for direct URL**
   The automation can go straight to
   `https://admin.shopify.com/store/<storeId>/apps/development`
   when a store ID is available, so it doesn’t depend on the current browser tab.

2. **Where the store ID comes from**
   - Env: `SHOPIFY_STORE_ID` (e.g. in `.env.local`)
   - Default for aodrop.com: `nbxwpf-z1` (from admin URL)
   - The script `get-access-token.ps1` reads `.env.local` and sets `ATO_SHOPIFY_STORE_ID` for the Node/Playwright flow.

3. **Flow in code**
   - `src/browser-automation/shopify-admin.js`:
     - `navigateToAppsDevelopmentByStoreId(page, storeId)` — direct goto Apps > Development
     - `navigateToAppsDevelopment(page)` — uses store ID from env if set, else derives from current URL
   - Then: open first app → API credentials → click Reveal → extract `shpat_...` from page/inputs.

4. **Chrome connection**
   - Playwright connects to Chrome via CDP at `http://localhost:9222`.
   - To get that: run `.\scripts\shopify\browser\launch-chrome-for-agent.ps1` (or use `-LaunchChrome` in setup-app-access.ps1).

---

## Fallbacks when e2e can’t get the token

1. **Manual copy + save**
   - In Shopify Admin: **Apps → Development → [your app] → API credentials** → **Reveal** → copy the Admin API token (`shpat_...`).
   - In repo root:
     `.\scripts\shopify\browser\save-token-to-env.ps1`
     (reads from clipboard), or
     `.\scripts\shopify\browser\save-token-to-env.ps1 -Token 'shpat_...'`
   - Then run runbook and pipeline:
     `.\scripts\run-runbook.ps1` and `.\scripts\verify-pipeline.ps1`

2. **Desktop automation (PC control)**
   - If you can’t use CDP (e.g. no Chrome with 9222), you can use desktop automation to focus Chrome and open the admin URL:
   - `src/desktop-automation/`: `activateBrowser('chrome')`, then `typeText()` or send keys to type
     `https://admin.shopify.com/store/nbxwpf-z1/apps/development`
     and press Enter.
   - After that, log in or use the already-open tab; then either run `get-access-token.ps1` (if you later start Chrome with 9222) or use manual copy + `save-token-to-env.ps1`.

3. **Screen reading (OCR)**
   - `src/desktop-automation/ocr-reader.js` can read text from screenshots. For “find Apps in sidebar and click”, you could capture the screen, run OCR, find “Apps” coordinates, and use `mouse-control.js` to click—possible but heavier; e2e + direct URL is preferred when CDP is available.

---

## Files and entrypoints

| Item                                                  | Purpose                                                                                                   |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `scripts/shopify/setup-app-access.ps1`                | One-shot setup: optional Chrome launch, token extraction, save, runbook + verify-pipeline                 |
| `scripts/shopify/browser/get-access-token.ps1`        | E2E: connect to Chrome, navigate to Apps > Development (with store ID), extract token, write `.env.local` |
| `scripts/shopify/browser/launch-chrome-for-agent.ps1` | Start Chrome with `--remote-debugging-port=9222` for CDP                                                  |
| `scripts/shopify/browser/save-token-to-env.ps1`       | Write clipboard or `-Token` to `SHOPIFY_ACCESS_TOKEN` in `.env.local`                                     |
| `src/browser-automation/shopify-admin.js`             | Playwright: connect, ensure login, navigate by store ID or URL, Reveal, extract token                     |
| `docs/status/CREDENTIAL_SETUP_STEPS.md`               | Step-by-step credential setup (including optional GitHub token)                                           |

---

## Optional .env.local

- `SHOPIFY_STORE_DOMAIN=aodrop.com`
- `SHOPIFY_STORE_ID=nbxwpf-z1` — optional; used for direct admin URL in automation
- `SHOPIFY_ACCESS_TOKEN=shpat_...` — set by get-access-token or save-token-to-env
- `GITHUB_TOKEN=ghp_...` — optional, for GitHub API checks in runbook/CI

---

## Cursor tasks

Use Cursor tasks for one-click runs where available, e.g. **Run Runbook**, **Verify Pipeline**, **Shopify: Theme Pull**. For full app access setup, run in terminal:

```powershell
.\scripts\shopify\setup-app-access.ps1
```

or with Chrome launch:

```powershell
.\scripts\shopify\setup-app-access.ps1 -LaunchChrome
```

This gives a single, repeatable way to “navigate/edit/setup the app in Shopify for full access” from the Cursor desktop app, with e2e first and manual/desktop fallbacks when needed.

**Broader store operations** (future store changes, Printify, image optimization, creating orders): **docs/STORE_OPERATIONS_AUTOMATION.md**.
