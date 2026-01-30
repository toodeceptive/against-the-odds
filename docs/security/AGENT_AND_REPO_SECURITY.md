# Agent and repository security

Summary for Cursor agents and operators: where secrets live, preview-before-apply, branch protection, deploy log, and credential rotation. See also [00_security_checklist.md](00_security_checklist.md) and [CURSOR_DATA_BOUNDARY.md](CURSOR_DATA_BOUNDARY.md) (what stays local vs what Cursor may use for AI).

---

## Where secrets live

- **Local**: `.env.local` in repo root only. Gitignored; never committed. Agent may read/write for setup only; never commit or log. See [.cursor/rules/env-credentials.mdc](../../.cursor/rules/env-credentials.mdc).
- **CI**: GitHub Actions **Secrets** (Settings → Secrets and variables → Actions). Use `SHOPIFY_STORE_DOMAIN`, `SHOPIFY_ACCESS_TOKEN` (and optionally `SHOPIFY_THEME_ID`). Pass as **environment variables** in workflows, not on the command line.
- **Pre-commit / CI**: Optional secret scan (blocklist for `shpat_`, `ghp_`, `shpss_`) to prevent accidental commit. Document in this folder if enabled.

---

## Preview before apply

- **Store-affecting changes**: Theme push, product sync, or any script that writes to the live Shopify store require:
  1. **Preview**: Dry-run output (e.g. `sync-products.ps1 -DryRun`) or theme dev URL or PR diff.
  2. **Explicit user approval** before apply.
- **Cursor rule**: [.cursor/rules/shopify-preview-approval.mdc](../../.cursor/rules/shopify-preview-approval.mdc). No permanent store or branch updates without preview and approval.

---

## Branch protection

- **main** (and optionally `shopify-theme`): Require a pull request before merging; at least one approval (or owner merge). Optional: require status checks (CI, lint).
- **Document** in repo so agents open PRs for store-affecting changes when that gate is desired.

---

## Deploy log

- **Location**: [docs/status/deploy-log.md](../status/deploy-log.md). Committed; append-only.
- **After every deploy or product sync**: Agent (or script) appends an entry: timestamp, action, branch/commit, summary, rollback steps. **No secrets** in the log.
- **Rollback**: Theme → Shopify Admin → theme card → Actions → Reset to last commit; or revert branch and push. Products → revert JSON and re-run sync, or fix in Admin.

---

## Credential rotation

- **Shopify**: If token/secret is exposed, regenerate in Shopify Admin (Apps → Development → your app → API credentials). Update `.env.local` (local) and GitHub Actions secrets (CI). Record date and what was rotated; never paste the new secret in docs.
- **GitHub**: If PAT or token is exposed, revoke and create new; update `.env.local` and/or GitHub Secrets. Record rotation; never paste the new value in docs.

---

## Repository visibility

- **Private**: Maximum privacy; set in GitHub Settings → General → Danger zone → Change visibility.
- **Public**: Safe only if no secrets are ever committed; all credentials in `.env.local` and GitHub Secrets. Assume code and docs are visible.
