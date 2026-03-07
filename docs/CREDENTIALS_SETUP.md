# Credentials Setup (Permanent)

Credentials are stored in **`.env.local`** in the repo root. This file is in `.gitignore` and is **never committed**. The agent may read/write `.env.local` only for setup; it must never commit it or log secrets (see `.cursor/rules/env-credentials.mdc`).

## What’s already done

- **`.env.local`** has been created from the template with placeholders.
- **Shopify store**: `SHOPIFY_STORE_DOMAIN=aodrop.com` and `SHOPIFY_STORE_URL=https://aodrop.com` are set; other Shopify values are placeholders.

## Credential methods (matrix)

| Credential                  | Primary method                                                                                                                                                                                                                            | Alternative                                                                                                                                                                                                                                                                              | Notes                                                                                                                   |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **SHOPIFY_ACCESS_TOKEN**    | **Client credentials**: If `SHOPIFY_API_KEY` and `SHOPIFY_API_SECRET` are in `.env.local`, run `node scripts/shared/run-powershell.cjs scripts/shopify/browser/get-token-client-credentials.ps1` to obtain and save the token.            | **Browser**: Run `node scripts/shared/run-powershell.cjs scripts/shopify/browser/get-access-token.ps1` (log in when asked) or copy token from Admin → Apps → Development → API credentials, then `node scripts/shared/run-powershell.cjs scripts/shopify/browser/save-token-to-env.ps1`. | See [BROWSER_CREDENTIAL_FLOW.md](BROWSER_CREDENTIAL_FLOW.md).                                                           |
| **SHOPIFY_THEME_ID**        | **Browser**: Launch Chrome with remote debugging (`scripts/shopify/browser/launch-chrome-for-agent.ps1`), then run `node scripts/shared/run-powershell.cjs scripts/shopify/browser/get-theme-id.ps1` while Shopify Admin is open.         | Manual: `npx shopify theme list` after `npx shopify auth login`, or copy from Theme library URL.                                                                                                                                                                                         | Optional for theme dev if using theme dev by name.                                                                      |
| **SHOPIFY_CLI_THEME_TOKEN** | **Theme access**: Run `npx shopify auth login`, then create a theme token in Shopify Admin → Apps → Develop apps → Create an app → Theme library → Create theme access token. Put the token in `.env.local` as `SHOPIFY_CLI_THEME_TOKEN`. | Same token can be set as `SHOPIFY_ACCESS_TOKEN`; theme-dev.ps1 uses either.                                                                                                                                                                                                              | **Required for seamless preview**: so `scripts/open-preview-popup.ps1` can start theme dev without prompting for login. |
| **GITHUB_TOKEN**            | Manual: [GitHub → Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens). Add to `.env.local`.                                                                                                       | —                                                                                                                                                                                                                                                                                        | Optional for local clone/push; needed for GitHub API checks and branch-protection script.                               |

**Full setup (single entry point):** Run `node scripts/shared/run-powershell.cjs scripts/setup/full-setup.ps1` (or `node scripts/shared/run-powershell.cjs scripts/setup/auto-configure-env.ps1`). This ensures `.env.local` exists, prefers client-credentials for Shopify token when API key/secret are set, guides browser or manual flow otherwise, and runs `verify-credentials.ps1`. Then run `node scripts/shared/run-powershell.cjs scripts/run-runbook.ps1` to verify.

**Future options (documented, not implemented):** For full automation, future options may include: Playwright e2e to navigate Admin and extract token; screen-reader–driven flows; PC control (e.g. robotjs/node-window-manager) for guided setup. Implement only if a concrete use case is chosen.

## What you need to do

1. Open **`.env.local`** in the repo root.
2. Replace placeholders with your real values as needed:
   - **GitHub**: `GITHUB_TOKEN` from [GitHub → Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens) (for API checks and automation).
   - **Shopify**: For **theme edits via GitHub** (edit in Cursor → push to GitHub → store updates), you only need Shopify CLI logged in (`npx shopify auth login`). No Admin API token in `.env.local` is required for that flow. For product sync, backups, or CLI theme push from scripts, set `SHOPIFY_STORE_DOMAIN` and `SHOPIFY_ACCESS_TOKEN` from Shopify Admin → Apps → Development → Your app → API credentials. For `SHOPIFY_THEME_ID`, run `npx shopify theme list` after `npx shopify auth login`.
3. Save the file. Scripts and the runbook load these when you run them from Cursor.

## Verifying

From Cursor’s terminal (repo root):

```sh
node scripts/shared/run-powershell.cjs scripts/run-runbook.ps1
```

This runs the Shopify connection test and GitHub auth check using `.env.local`. The default `npm run verify:pipeline` path now **skips the credential-gated runbook step** when `SHOPIFY_ACCESS_TOKEN` is absent. Use `npm run verify:pipeline:strict` or `node scripts/shared/run-powershell.cjs scripts/run-runbook.ps1` when you want the full credentialed path to execute and fail loudly until `SHOPIFY_ACCESS_TOKEN` is configured. GitHub repo access works without `GITHUB_TOKEN` for clone/push; `GITHUB_TOKEN` is optional locally but needed for GitHub API checks, branch-protection automation, and strict secrets verification.

See also: `docs/BROWSER_CREDENTIAL_FLOW.md` (permanent one-time setup; agent uses your browser to fetch credentials), `.cursor/rules/env-credentials.mdc` (no commit/log of secrets), `docs/UPDATE_SHOPIFY_FROM_CURSOR.md`, `OPERATOR_RUNBOOK.md`.
