# Update Your Shopify Store from Cursor

Use this guide to update your Shopify store (aodrop.com) from the Cursor desktop app (the app you're talking to the agent in now).

## Prerequisites

1. **Credentials** in `.env.local` (in this repo root). Copy from `.env.example` if needed. You need at least:
   - `SHOPIFY_STORE_DOMAIN` (e.g. `aodrop.com`)
   - `SHOPIFY_ACCESS_TOKEN` (from Shopify Admin → Apps → Your app → API credentials)
   - `SHOPIFY_THEME_ID` (optional; get via `shopify theme list`)

2. **Shopify CLI** installed:  
   `npm install -g @shopify/cli @shopify/theme`  
   Then: `shopify auth login` and select your store.

---

## Option A: Theme updates (code → store)

**When**: You change theme files in this repo (e.g. under `src/shopify/themes/`) and want the live or dev store to use them.

1. **Open Cursor’s terminal** (Terminal → New Terminal or `` Ctrl+` ``).
2. **Go to repo root**:
   ```powershell
   cd C:\Users\LegiT\against-the-odds
   ```
3. **Log in (if needed)**:
   ```powershell
   shopify auth login
   ```
   Select your Partner account and store (aodrop.com).

4. **Run theme dev (live preview)**:
   ```powershell
   shopify theme dev --store=aodrop.com --theme=live
   ```
   This serves your local theme and hot-reloads. Use the URL it prints to preview. When satisfied, push your branch to GitHub; if the store is connected via the **Shopify GitHub App**, theme deploys can happen from the connected branch (see OPERATOR_RUNBOOK.md).

5. **Or push theme to store** (without GitHub App):
   ```powershell
   .\scripts\shopify\update-theme.ps1
   ```
   (Or use `shopify theme push` with the path to your theme.)

---

## Option B: Test connection from Cursor

**When**: You want to confirm Cursor (and this repo) can talk to Shopify.

1. In Cursor, open Terminal and go to repo root:
   ```powershell
   cd C:\Users\LegiT\against-the-odds
   ```
2. Load env and run the test script:
   ```powershell
   .\scripts\run-runbook.ps1
   ```
   This runs `scripts\shopify\test-connection.ps1` (and GitHub verify).  
   Or run only Shopify:
   ```powershell
   .\scripts\shopify\test-connection.ps1
   ```
   Ensure `.env.local` has `SHOPIFY_ACCESS_TOKEN` and `SHOPIFY_STORE_DOMAIN`.

---

## Option C: Products / data (API)

**When**: You want to sync products or pull store data from Cursor.

- **Test connection**:  
  `.\scripts\shopify\test-connection.ps1`
- **Fetch store data** (products, collections, themes):  
  `.\scripts\shopify\fetch-store-data.ps1`
- **Sync products** (from repo data to store):  
  `.\scripts\shopify\sync-products.ps1`

Run these in Cursor’s terminal from repo root; they use `.env.local` for credentials.

---

## Option D: Deploy via GitHub (theme auto-deploy)

If your store is connected to this repo with the **Shopify GitHub App**:

1. In Cursor: commit and push your theme/code changes to the branch connected in Shopify (often `main`).
2. Shopify will deploy from that branch (see Shopify Admin → Settings → Apps → GitHub).
3. No need to run `shopify theme push` from Cursor for that connected branch; push to GitHub is enough.

---

## Quick reference (run in Cursor terminal from repo root)

| Goal                     | Command |
|--------------------------|--------|
| Test Shopify connection  | `.\scripts\shopify\test-connection.ps1` |
| Theme dev (live preview) | `shopify theme dev --store=aodrop.com --theme=live` |
| Login to Shopify CLI     | `shopify auth login` |
| Run runbook (Shopify + GitHub checks) | `.\scripts\run-runbook.ps1` |

See also: `OPERATOR_RUNBOOK.md`, `docs/SHOPIFY_SETUP.md`.
