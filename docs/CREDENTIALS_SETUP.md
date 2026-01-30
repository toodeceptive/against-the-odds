# Credentials Setup (Permanent)

Credentials are stored in **`.env.local`** in the repo root. This file is in `.gitignore` and is never committed.

## What’s already done

- **`.env.local`** has been created from the template with placeholders.
- **Shopify store**: `SHOPIFY_STORE_DOMAIN=aodrop.com` and `SHOPIFY_STORE_URL=https://aodrop.com` are set; other Shopify values are placeholders.

## What you need to do

1. Open **`.env.local`** in the repo root (`C:\Users\LegiT\against-the-odds\.env.local`).
2. Replace placeholders with your real values:
   - **GitHub**: `GITHUB_TOKEN` from [GitHub → Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens).
   - **Shopify**: From [Shopify Admin → Apps → Development → Your app → API credentials](https://aodrop.com/admin/settings/apps/development): `SHOPIFY_API_KEY`, `SHOPIFY_API_SECRET`, `SHOPIFY_ACCESS_TOKEN`. For `SHOPIFY_THEME_ID`, run `shopify theme list` after `shopify auth login`.
3. Save the file. Scripts and the runbook will load these when you run them from Cursor.

## Verifying

From Cursor’s terminal (repo root):

```powershell
.\scripts\run-runbook.ps1
```

This runs the Shopify connection test and GitHub auth check using `.env.local`.

See also: `docs/SHOPIFY_SETUP.md`, `docs/UPDATE_SHOPIFY_FROM_CURSOR.md`, `OPERATOR_RUNBOOK.md`.
