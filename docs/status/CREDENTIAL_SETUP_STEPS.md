# Credential setup steps (runbook / verify-pipeline)

**Goal:** Runbook and verify-pipeline pass (Shopify 401 resolved, optional GITHUB_TOKEN for API checks).

**Fastest path (paste file):** Create `scripts/shopify/.token-paste.txt`, paste your token (`shpat_...`) or Client ID (32 hex) + Client secret (long hex) on lines 1–2, then run `.\scripts\shopify\browser\save-token-from-file.ps1`. Or copy token to clipboard and run `.\scripts\shopify\browser\save-token-to-env.ps1`. Then run `.\scripts\run-runbook.ps1` and `.\scripts\verify-pipeline.ps1` — both should pass.

## Shopify Admin API token

1. **Option A – Browser extraction (e2e)**
   - Run: `.\scripts\shopify\browser\launch-chrome-for-agent.ps1`
   - In the opened Chrome window, **log in to Shopify** (e.g. aodrop.com → Google OAuth).
   - Go to **Apps → Development → [your app] → API credentials** and click **Reveal** so the token is visible.
   - With that tab active, in repo root run: `.\scripts\shopify\browser\get-access-token.ps1`
   - The script connects to Chrome (CDP), reads the token from the page, and writes `SHOPIFY_ACCESS_TOKEN` to `.env.local`.
   - If the script does not find the token, use Option B (copy token, then `save-token-to-env.ps1`).

2. **Option B – Manual copy (one step after copy)**
   - In Shopify Admin go to **Apps → Development → [your app] → API credentials** (or **Reveal** the token if needed).
   - Copy the **Admin API access token** (starts with `shpat_`).
   - In repo root run: `.\scripts\shopify\browser\save-token-to-env.ps1` (reads from clipboard).
   - Or: `.\scripts\shopify\browser\save-token-to-env.ps1 -Token 'shpat_...'`

3. Ensure `.env.local` has:
   - `SHOPIFY_STORE_DOMAIN=aodrop.com`
   - `SHOPIFY_ACCESS_TOKEN=shpat_...`
   - (Optional) `SHOPIFY_STORE_ID=nbxwpf-z1` — used by e2e for direct URL to Apps > Development

## GitHub PAT (optional for runbook)

- Create a token at [GitHub → Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens).
- Add to `.env.local`: `GITHUB_TOKEN=ghp_...`
- Needed for GitHub API checks and CI; not required for local clone/push.

## GitHub Actions secrets (for CI workflows)

After `.env.local` is populated, push values to repo secrets so `shopify-sync` can run in CI:

```powershell
.\scripts\github\set-secrets-from-env.ps1 -DryRun   # Preview
.\scripts\github\set-secrets-from-env.ps1           # Apply (requires gh auth)
```

## Verify

```powershell
.\scripts\run-runbook.ps1
.\scripts\verify-pipeline.ps1
```

Both should pass once `SHOPIFY_ACCESS_TOKEN` (and store domain) are set.
