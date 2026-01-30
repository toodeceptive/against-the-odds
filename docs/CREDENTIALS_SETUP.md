# Credentials Setup (Permanent)

Credentials are stored in **`.env.local`** in the repo root. This file is in `.gitignore` and is **never committed**. The agent may read/write `.env.local` only for setup; it must never commit it or log secrets (see `.cursor/rules/env-credentials.mdc`).

## What’s already done

- **`.env.local`** has been created from the template with placeholders.
- **Shopify store**: `SHOPIFY_STORE_DOMAIN=aodrop.com` and `SHOPIFY_STORE_URL=https://aodrop.com` are set; other Shopify values are placeholders.

## What you need to do

1. Open **`.env.local`** in the repo root.
2. Replace placeholders with your real values as needed:
   - **GitHub**: `GITHUB_TOKEN` from [GitHub → Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens) (for API checks and automation).
   - **Shopify**: For **theme edits via GitHub** (edit in Cursor → push to GitHub → store updates), you only need Shopify CLI logged in (`shopify auth login`). No Admin API token in `.env.local` is required for that flow. For product sync, backups, or CLI theme push from scripts, set `SHOPIFY_STORE_DOMAIN` and `SHOPIFY_ACCESS_TOKEN` from [Shopify Admin → Apps → Development → Your app → API credentials](https://aodrop.com/admin/settings/apps/development). For `SHOPIFY_THEME_ID`, run `shopify theme list` after `shopify auth login`.
3. Save the file. Scripts and the runbook load these when you run them from Cursor.

## Verifying

From Cursor’s terminal (repo root):

```powershell
.\scripts\run-runbook.ps1
```

This runs the Shopify connection test and GitHub auth check using `.env.local`.

See also: `docs/BROWSER_CREDENTIAL_FLOW.md` (permanent one-time setup; agent uses your browser to fetch credentials), `.cursor/rules/env-credentials.mdc` (no commit/log of secrets), `docs/UPDATE_SHOPIFY_FROM_CURSOR.md`, `OPERATOR_RUNBOOK.md`.
