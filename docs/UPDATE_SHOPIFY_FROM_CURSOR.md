# Update Your Shopify Store from Cursor

Edit your store in Cursor, push to GitHub, and have changes go live—the best way when Shopify is already connected to your GitHub account.

**Browser-first, no headless:** Use your open browser (Cursor browser MCP) when you want to watch the agent work in Shopify Admin; the agent stops before Save and asks for your approval. Unattended headless automation of Shopify Admin is not recommended per Shopify API terms. For theme and product sync, use the flows below (preview → approve in chat → apply).

---

## Recommended: Edit in Cursor → Push to GitHub → Store updates

**This is the intended workflow** when you've connected Shopify to GitHub (Shopify GitHub App): all changes go through the repository; theme changes land on `main`, CI updates `shopify-theme`, and Shopify deploys from that connected branch. No need to run `shopify theme push` from your machine for that branch.

### One-time setup (get theme into the repo)

If `src/shopify/themes/aodrop-theme` is empty or you haven't pulled your live theme yet:

1. **Store:** Create `.env.local` in repo root with `SHOPIFY_STORE_DOMAIN=aodrop.com` (optional but recommended; scripts load it automatically).
2. **Auth (choose one):**
   - **Device code:** Run `node scripts/shared/run-powershell.cjs scripts/shopify/theme-auth-then-pull.ps1` (opens browser for login, then pulls). If you get **"not authorized"**: log into Shopify Admin at least once as owner or staff with theme access, or have the owner add you in **Settings → Users and permissions**, then run again.
   - **Token (browser):** Run `node scripts/shared/run-powershell.cjs scripts/shopify/theme-auth-via-browser.ps1` — launches Chrome at the resolved Shopify Admin URL, you log in, script extracts an Admin API token, saves `SHOPIFY_ACCESS_TOKEN`, and then pulls via REST. Use when device-code auth fails or you prefer token-based auth for theme pull.
   - **Token (manual):** Add `SHOPIFY_CLI_THEME_TOKEN` to `.env.local` for non-interactive theme dev/push. `SHOPIFY_ACCESS_TOKEN` is for Admin API / REST flows and theme pull REST fallback.
3. **Pull:** Run `node scripts/shared/run-powershell.cjs scripts/shopify/theme-pull.ps1` from repo root (or use theme-auth-then-pull.ps1 for auth + pull in one go). The script **installs Shopify CLI automatically** if missing and reads the store from `.env.local`.
4. Commit and push to `main`; CI updates the Shopify-connected `shopify-theme` branch.

In **Shopify Admin**: Confirm the store is connected to this repo (Settings → Apps and sales channels → GitHub). Set the connected branch to `shopify-theme`; CI populates that branch from `src/shopify/themes/aodrop-theme` on `main`.

### Daily workflow

1. Edit theme files in Cursor (e.g. under `src/shopify/themes/aodrop-theme`)
2. **Preview before commit**: Run **Tasks → Shopify: Theme Dev** or press **Ctrl+Alt+T**. Scripts load `.env.local` and install Shopify CLI if needed; the preview URL opens in your browser (or click it in the terminal / **View → Simple Browser**). Edit and refresh; no commit needed to preview.
3. Commit and push to `main`
4. CI updates `shopify-theme`
5. Shopify deploys from `shopify-theme`

### Store theme not updating?

If the live store (aodrop.com) doesn’t show your brand changes:

1. **One-time**: Pull the live theme: run `node scripts/shared/run-powershell.cjs scripts/shopify/theme-auth-then-pull.ps1` (opens browser to log in, then pulls), or `node scripts/shared/run-powershell.cjs scripts/shopify/theme-pull.ps1` — on "not authorized" the script opens login in your browser; sign in, then run theme-pull again.
2. **Apply and push**: Run `node scripts/shared/run-powershell.cjs scripts/shopify/theme-update-store.ps1` — this merges AO brand CSS/snippet into the theme, copies PNGs from `assets/brand/` into the theme assets, and pushes the theme to Shopify. Use `-Live` only when you intend to update the **live** theme.
3. **Preview first**: Open `docs/guides/theme-preview-mock.html` in a browser for a static mock, or use **Tasks → Shopify: Theme Dev** / `node scripts/shared/run-powershell.cjs scripts/shopify/theme-dev.ps1` for a live preview before pushing. **Theme dev requires a full theme:** if you see "missing layout/theme.liquid" or "127.0.0.1 refused to connect", run `theme-pull.ps1` once so the folder has layout/config; the script uses `npx shopify theme dev` so the correct theme CLI runs.

**Summary**: Edit in Cursor → push to GitHub → store updates. The Admin API token in `.env.local` is **not** required for this flow (only for product sync, backups, or CLI push).

---

## Option A: Theme updates via CLI (no GitHub deploy)

**When**: You want to push the theme directly from Cursor (e.g. before GitHub is connected, or to a dev theme).

- **Prerequisites**: `.env.local` with `SHOPIFY_STORE_DOMAIN` (optional; scripts load it). Run `npx shopify auth login` once if you are not using a saved token. Shopify CLI is **installed automatically** by `theme-pull` / `theme-dev` / `update-theme` if missing.
- **Push theme to store**: `node scripts/shared/run-powershell.cjs scripts/shopify/update-theme.ps1` from repo root
- **Live preview**: **Tasks → Shopify: Theme Dev** or `node scripts/shared/run-powershell.cjs scripts/shopify/theme-dev.ps1`

---

## Option B: Test connection from Cursor

**When**: You want to confirm Cursor (and this repo) can talk to Shopify.

1. In Cursor, open Terminal and go to repo root
2. Load env and run: `node scripts/shared/run-powershell.cjs scripts/run-runbook.ps1` (Shopify + GitHub checks), or only Shopify: `node scripts/shared/run-powershell.cjs scripts/shopify/test-connection.ps1`
3. Ensure `.env.local` has `SHOPIFY_ACCESS_TOKEN` and `SHOPIFY_STORE_DOMAIN` if you use API-based scripts

---

## Option C: Products / data (API)

**When**: You want to sync products or pull store data from Cursor.

- **Test connection**: `node scripts/shared/run-powershell.cjs scripts/shopify/test-connection.ps1`
- **Fetch store data** (products, collections, themes): `node scripts/shared/run-powershell.cjs scripts/shopify/fetch-store-data.ps1`
- **Sync products** (from repo data to store): `node scripts/shared/run-powershell.cjs scripts/shopify/sync-products.ps1`

Run from repo root; they use `.env.local` for credentials (Admin API token required).

---

## Quick reference (run in Cursor terminal from repo root)

| Goal                                    | Command                                                                                                  |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **Push changes to store (GitHub flow)** | Commit and push to `main` (CI updates the connected `shopify-theme` branch)                              |
| Pull live theme into repo               | `node scripts/shared/run-powershell.cjs scripts/shopify/theme-pull.ps1`                                  |
| Theme dev (live preview)                | **Tasks → Shopify: Theme Dev** or `node scripts/shared/run-powershell.cjs scripts/shopify/theme-dev.ps1` |
| Push theme via CLI                      | `node scripts/shared/run-powershell.cjs scripts/shopify/update-theme.ps1`                                |
| Login to Shopify CLI                    | `npx shopify auth login`                                                                                 |
| Run runbook (Shopify + GitHub)          | `node scripts/shared/run-powershell.cjs scripts/run-runbook.ps1`                                         |

---

## Manual verification checklist (after setup)

Use this to confirm the system works end-to-end once you have Shopify CLI access:

1. **Auth + pull theme**  
   From repo root: `node scripts/shared/run-powershell.cjs scripts/shopify/theme-auth-then-pull.ps1`

- Browser opens for login; sign in with the account that has theme access to Shopify Admin.
- After auth, script pulls the live theme into `src/shopify/themes/aodrop-theme`.
- Success: folder contains `layout/theme.liquid`, `config/`, etc.

2. **Theme dev (live preview)**  
   From repo root: `node scripts/shared/run-powershell.cjs scripts/shopify/theme-dev.ps1`
   - Preview URL opens in browser.
   - Success: store preview loads; edits in Cursor refresh in browser.

3. **Confirm in Shopify Admin**
   - Open Shopify Admin → Online store → Themes.
   - Confirm the theme (or the one deployed from GitHub) shows as expected.
   - If using GitHub deploy: Settings → Apps and sales channels → GitHub — confirm repo and branch `shopify-theme`.

4. **Optional: apply brand and push via CLI**  
   From repo root: `node scripts/shared/run-powershell.cjs scripts/shopify/theme-update-store.ps1`
   - Merges AO brand CSS/snippet, copies brand images, then pushes. Use `-Live` only when you intend to update the live theme.

See also: [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](AGENT_WORKFLOW_CURSOR_SHOPIFY.md) (preview/approval flow), `OPERATOR_RUNBOOK.md`, `docs/SHOPIFY_SETUP.md`. Theme-branch sync: pushes to `main` that change `src/shopify/themes/aodrop-theme/` trigger `.github/workflows/sync-theme-branch.yml`, which updates the Shopify-connected `shopify-theme` branch.
