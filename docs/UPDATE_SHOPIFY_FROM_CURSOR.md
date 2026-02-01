# Update Your Shopify Store from Cursor

Edit your store in Cursor, push to GitHub, and have changes go live—the best way when Shopify is already connected to your GitHub account.

**Browser-first, no headless:** Use your open browser (Cursor browser MCP) when you want to watch the agent work in Shopify Admin; the agent stops before Save and asks for your approval. Unattended headless automation of Shopify Admin is not recommended per Shopify API terms. For theme and product sync, use the flows below (preview → approve in chat → apply).

---

## Recommended: Edit in Cursor → Push to GitHub → Store updates

**This is the intended workflow** when you've connected Shopify to GitHub (Shopify GitHub App): all changes go through the repository; Shopify deploys from the connected branch. No need to run `shopify theme push` from your machine for that branch.

### One-time setup (get theme into the repo)

If `src/shopify/themes/aodrop-theme` is empty or you haven't pulled your live theme yet:

1. **Store:** Create `.env.local` in repo root with `SHOPIFY_STORE_DOMAIN=aodrop.com` (optional but recommended; scripts load it automatically).
2. **Auth (choose one):**
   - **Device code:** Run `.\scripts\shopify\theme-auth-then-pull.ps1` (opens browser for login with store scoped to aodrop.com, then pulls). If you get **"not authorized"**: log into **https://aodrop.com/admin** at least once as owner or staff with theme access; or have the owner add you in **Settings → Users and permissions**; then run again.
   - **Token (browser):** Run `.\scripts\shopify\theme-auth-via-browser.ps1` — launches Chrome at Shopify Admin, you log in, script extracts token (Apps > Development) and saves `SHOPIFY_CLI_THEME_TOKEN` + `SHOPIFY_ACCESS_TOKEN`, then pulls. Use when device-code auth fails or you prefer token-based auth.
   - **Token (manual):** Add `SHOPIFY_CLI_THEME_TOKEN` (or `SHOPIFY_ACCESS_TOKEN`) to `.env.local` — theme pull/dev/push use it for non-interactive auth.
3. **Pull:** Run `.\scripts\shopify\theme-pull.ps1` from repo root (or use theme-auth-then-pull.ps1 for auth + pull in one go). The script **installs Shopify CLI automatically** if missing and reads the store from `.env.local`.
4. Commit and push so the theme lives on the branch Shopify is watching (usually `main`).

In **Shopify Admin**: Confirm the store is connected to this repo (Settings → Apps and sales channels → GitHub). Set the branch (e.g. `main`) and, if the app asks, the theme directory (e.g. `src/shopify/themes/aodrop-theme` or repo root—depends on how the Shopify GitHub integration is configured).

### Daily workflow

1. Edit theme files in Cursor (e.g. under `src/shopify/themes/aodrop-theme`)
2. **Preview before commit**: Run **Tasks → Shopify: Theme Dev** or press **Ctrl+Alt+T**. Scripts load `.env.local` and install Shopify CLI if needed; the preview URL opens in your browser (or click it in the terminal / **View → Simple Browser**). Edit and refresh; no commit needed to preview.
3. Commit and push to the connected branch (e.g. `main`)
4. Shopify deploys from that branch

### Store theme not updating?

If the live store (aodrop.com) doesn’t show your brand changes:

1. **One-time**: Pull the live theme: run `.\scripts\shopify\theme-auth-then-pull.ps1` (opens browser to log in, then pulls), or `.\scripts\shopify\theme-pull.ps1` — on "not authorized" the script opens login in your browser; sign in, then run theme-pull again.
2. **Apply and push**: Run `.\scripts\shopify\theme-update-store.ps1` — this merges AO brand CSS/snippet into the theme, copies PNGs from `assets/brand/` into the theme assets, and pushes the theme to Shopify. Use `-Live` only when you intend to update the **live** theme.
3. **Preview first**: Open `docs/guides/theme-preview-mock.html` in a browser for a static mock, or run `.\scripts\shopify\theme-dev.ps1` for a live preview before pushing. **Theme dev requires a full theme:** if you see "missing layout/theme.liquid" or "127.0.0.1 refused to connect", run `theme-pull.ps1` once so the folder has layout/config; the script uses `npx shopify theme dev` so the correct theme CLI runs.

**Summary**: Edit in Cursor → push to GitHub → store updates. The Admin API token in `.env.local` is **not** required for this flow (only for product sync, backups, or CLI push).

---

## Option A: Theme updates via CLI (no GitHub deploy)

**When**: You want to push the theme directly from Cursor (e.g. before GitHub is connected, or to a dev theme).

- **Prerequisites**: `.env.local` with `SHOPIFY_STORE_DOMAIN` (optional; scripts load it). Run `shopify auth login` once. Shopify CLI is **installed automatically** by `theme-pull` / `theme-dev` / `update-theme` if missing.
- **Push theme to store**: `.\scripts\shopify\update-theme.ps1` from repo root
- **Live preview**: **Tasks → Shopify: Theme Dev** or `.\scripts\shopify\theme-dev.ps1`

---

## Option B: Test connection from Cursor

**When**: You want to confirm Cursor (and this repo) can talk to Shopify.

1. In Cursor, open Terminal and go to repo root
2. Load env and run: `.\scripts\run-runbook.ps1` (Shopify + GitHub checks), or only Shopify: `.\scripts\shopify\test-connection.ps1`
3. Ensure `.env.local` has `SHOPIFY_ACCESS_TOKEN` and `SHOPIFY_STORE_DOMAIN` if you use API-based scripts

---

## Option C: Products / data (API)

**When**: You want to sync products or pull store data from Cursor.

- **Test connection**: `.\scripts\shopify\test-connection.ps1`
- **Fetch store data** (products, collections, themes): `.\scripts\shopify\fetch-store-data.ps1`
- **Sync products** (from repo data to store): `.\scripts\shopify\sync-products.ps1`

Run from repo root; they use `.env.local` for credentials (Admin API token required).

---

## Quick reference (run in Cursor terminal from repo root)

| Goal                                    | Command                                             |
| --------------------------------------- | --------------------------------------------------- |
| **Push changes to store (GitHub flow)** | Commit and push to `main` (or connected branch)     |
| Pull live theme into repo               | `.\scripts\shopify\theme-pull.ps1`                  |
| Theme dev (live preview)                | `shopify theme dev --store=aodrop.com --theme=live` |
| Push theme via CLI                      | `.\scripts\shopify\update-theme.ps1`                |
| Login to Shopify CLI                    | `shopify auth login`                                |
| Run runbook (Shopify + GitHub)          | `.\scripts\run-runbook.ps1`                         |

---

## Manual verification checklist (after setup)

Use this to confirm the system works end-to-end once you have Shopify CLI access:

1. **Auth + pull theme**  
   From repo root: `.\scripts\shopify\theme-auth-then-pull.ps1`
   - Browser opens for login; sign in with the account that has theme access to aodrop.com.
   - After auth, script pulls the live theme into `src/shopify/themes/aodrop-theme`.
   - Success: folder contains `layout/theme.liquid`, `config/`, etc.

2. **Theme dev (live preview)**  
   From repo root: `.\scripts\shopify\theme-dev.ps1`
   - Preview URL opens in browser.
   - Success: store preview loads; edits in Cursor refresh in browser.

3. **Confirm in Shopify Admin**
   - Open https://aodrop.com/admin → Online store → Themes.
   - Confirm the theme (or the one deployed from GitHub) shows as expected.
   - If using GitHub deploy: Settings → Apps and sales channels → GitHub — confirm repo and branch.

4. **Optional: apply brand and push via CLI**  
   From repo root: `.\scripts\shopify\theme-update-store.ps1`
   - Merges AO brand CSS/snippet, copies brand images, then pushes. Use `-Live` only when you intend to update the live theme.

See also: [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](AGENT_WORKFLOW_CURSOR_SHOPIFY.md) (preview/approval flow), `OPERATOR_RUNBOOK.md`, `docs/SHOPIFY_SETUP.md`. Theme-branch sync: pushes to `main` that change `src/shopify/themes/aodrop-theme/` trigger `.github/workflows/sync-theme-branch.yml`, which updates the `shopify-theme` branch for Shopify GitHub App connection.
