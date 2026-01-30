# Against The Odds — Security Checklist

## Secrets hygiene
- [ ] Confirm `.env.local` is gitignored and **never** committed (validate `.gitignore` includes it).
- [ ] Confirm `.env.example` and `.env.shopify.example` contain **placeholders only** (no real tokens/keys).
- [ ] Scan repo for common secret patterns and redact if found (then rotate upstream):
  - [ ] `SHOPIFY_ACCESS_TOKEN`, `SHOPIFY_API_SECRET`, `GITHUB_TOKEN`
  - [ ] “xox”, “ghp_”, “shpat_”, “sk_live_”, private keys (`BEGIN PRIVATE KEY`)
- [ ] Rotation procedure (documented, not the secret):
  - [ ] Rotate Shopify Admin API token (custom app) if exposure is suspected.
  - [ ] Rotate GitHub PAT if exposure is suspected.
  - [ ] Record **date/time**, what was rotated, and where the new secret was stored (never paste the secret).
- [ ] Ensure secrets are stored only in:
  - local dev: `.env.local` (developer machine)
  - CI: GitHub Actions secrets (repo/environment secrets)

## Access control (minimum)
- [ ] GitHub access:
  - [ ] Prefer GitHub Actions `GITHUB_TOKEN` for workflows when possible (least privilege by default).
  - [ ] If a PAT is required, ensure it uses **least-privilege scopes** and is owned by the right account.
  - [ ] Require 2FA on GitHub and protect `main` (PR required, status checks required).
- [ ] Shopify access:
  - [ ] Custom app scopes minimized to only what scripts use:
    - `scripts/shopify/test-connection.ps1` reads shop/products/themes
    - `scripts/shopify/sync-products.ps1` writes products
    - theme operations via Shopify CLI / `scripts/shopify/update-theme.ps1`
  - [ ] Staff accounts use 2FA; remove unused staff/app access.
- [ ] CI secrets governance:
  - [ ] Only store secrets required for automation (do not mirror local `.env.local` wholesale).
  - [ ] Restrict secret exposure to workflows/jobs that need them.
  - [ ] Review `.github/workflows/deploy.yml` and `.github/workflows/shopify-sync.yml` for where `SHOPIFY_*` secrets are referenced.

## Dependency risk
- [ ] `npm audit` reviewed:
  - [ ] Log findings (counts by severity) and decide: fix now vs defer with rationale.
  - [ ] Re-run after dependency updates.
- [ ] Lockfile strategy is explicit:
  - [ ] If using npm, commit `package-lock.json` and use `npm ci` in CI (current workflows use `npm ci`).
- [ ] Automated dependency updates are safe:
  - [ ] Confirm `maintenance.yml` PRs run CI/quality checks before merge.
  - [ ] Avoid auto-merging dependency PRs without review.

## Backups / recovery
- [ ] Theme backup strategy:
  - [ ] Before any LIVE theme publish: run `scripts/shopify/theme-pull.ps1` to capture the current live state.
  - [ ] Keep a “known-good” reference you can publish (Shopify keeps versions; repo snapshots help diffs).
- [ ] Product/config export cadence:
  - [ ] Weekly (or before major changes): run `scripts/shopify/fetch-store-data.ps1` (writes JSON into `data/shopify-backup/`).
  - [ ] Decide whether backups are committed to Git or stored elsewhere (do **not** commit anything that contains secrets).
- [ ] Rollback steps are documented and tested:
  - [ ] Code + release rollback: `docs/launch/02_release_and_environments.md`
  - [ ] Shopify rollback: `docs/launch/03_shopify_store_ops.md`
- [ ] Worktree/branch safety:
  - [ ] Detached HEAD recovery documented and used when needed (`docs/launch/02_release_and_environments.md`).

## Incident response (lightweight)
### Token leak playbook
- [ ] **Contain**: revoke/rotate the leaked token immediately (Shopify custom app token / GitHub PAT).
- [ ] **Eradicate**: remove the secret from git history and any docs (do not share it in issues/PRs).
- [ ] **Recover**: update GitHub Actions secrets and local `.env.local` as needed.
- [ ] **Verify**: run connectivity checks:
  - [ ] Shopify: `scripts/shopify/test-connection.ps1`
  - [ ] Monitoring: `scripts/monitoring/performance-check.ps1`
- [ ] **Record**: timestamp, scope, root cause, follow-ups.

### Account compromise playbook
- [ ] Force password reset + enable/confirm 2FA (GitHub/Shopify).
- [ ] Review access logs and installed apps/integrations; remove unknown access.
- [ ] Rotate all active tokens/keys (Shopify custom apps, GitHub PATs, CI secrets).
- [ ] Review recent theme/product changes; rollback if needed (see launch docs).

### Customer data exposure playbook
- [ ] Assume severity is high; stop the bleeding first (disable affected integrations, pause workflows).
- [ ] Identify what data was exposed and for how long.
- [ ] Preserve evidence (logs, timestamps, affected systems) without copying sensitive data into GitHub Issues.
- [ ] Notify stakeholders and follow legal requirements for your jurisdiction (document in your legal pack).

