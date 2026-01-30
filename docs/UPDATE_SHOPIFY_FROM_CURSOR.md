# Update Your Shopify Store from Cursor

Edit your store in Cursor, push to GitHub, and have changes go live—the best way when Shopify is already connected to your GitHub account.

**Browser-first, no headless:** Use your open browser (Cursor browser MCP) when you want to watch the agent work in Shopify Admin; the agent stops before Save and asks for your approval. Unattended headless automation of Shopify Admin is not recommended per Shopify API terms. For theme and product sync, use the flows below (preview → approve in chat → apply).

---

## Recommended: Edit in Cursor → Push to GitHub → Store updates

**This is the intended workflow** when you've connected Shopify to GitHub (Shopify GitHub App): all changes go through the repository; Shopify deploys from the connected branch. No need to run `shopify theme push` from your machine for that branch.

### One-time setup (get theme into the repo)

If `src/shopify/themes/aodrop-theme` is empty or you haven't pulled your live theme yet:

1. Install Shopify CLI: `npm install -g @shopify/cli @shopify/theme`
2. Log in: `shopify auth login` (select your store, e.g. aodrop.com)
3. Pull the live theme into the repo: `.\scripts\shopify\theme-pull.ps1`
4. Commit and push so the theme lives on the branch Shopify is watching (usually `main`)

In **Shopify Admin**: Confirm the store is connected to this repo (Settings → Apps and sales channels → GitHub). Set the branch (e.g. `main`) and, if the app asks, the theme directory (e.g. `src/shopify/themes/aodrop-theme` or repo root—depends on how the Shopify GitHub integration is configured).

### Daily workflow

1. Edit theme files in Cursor (e.g. under `src/shopify/themes/aodrop-theme`)
2. **Preview before commit**: Run **Tasks → Run Task → Shopify: Theme Dev (preview before commit)**. When the preview URL appears in the terminal, click it or paste it into **View → Simple Browser** to see your changes live. Edit and refresh; no commit needed to preview.
3. Commit and push to the connected branch (e.g. `main`)
4. Shopify deploys from that branch

**Summary**: Edit in Cursor → push to GitHub → store updates. The Admin API token in `.env.local` is **not** required for this flow (only for product sync, backups, or CLI push).

---

## Option A: Theme updates via CLI (no GitHub deploy)

**When**: You want to push the theme directly from Cursor (e.g. before GitHub is connected, or to a dev theme).

- **Prerequisites**: `.env.local` with `SHOPIFY_STORE_DOMAIN`; Shopify CLI: `npm install -g @shopify/cli @shopify/theme` then `shopify auth login`
- **Push theme to store**: `.\scripts\shopify\update-theme.ps1` (or `shopify theme push` with the path to your theme)
- **Live preview**: `shopify theme dev --store=aodrop.com --theme=live`

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

See also: [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](AGENT_WORKFLOW_CURSOR_SHOPIFY.md) (preview/approval flow), `OPERATOR_RUNBOOK.md`, `docs/SHOPIFY_SETUP.md`. Theme-branch sync: pushes to `main` that change `src/shopify/themes/aodrop-theme/` trigger `.github/workflows/sync-theme-branch.yml`, which updates the `shopify-theme` branch for Shopify GitHub App connection.
