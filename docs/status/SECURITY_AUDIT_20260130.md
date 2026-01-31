# Security Audit — 2026-01-30 (Phase 1.1)

**Expert**: Security & Secrets (expert-01). **Scope**: Secrets, .env.local, gitignore, GitHub/Shopify ToS, npm audit.

---

## Checklist (completed)

- **.env.local**: Confirmed in [.gitignore](.gitignore) (lines 26–28: .env, .env.local, .env.\*.local). Never commit.
- **.env.example / .env.shopify.example**: Placeholders only; no real tokens in repo.
- **Rules**: [.cursor/rules/env-credentials.mdc](.cursor/rules/env-credentials.mdc), [shopify-preview-approval.mdc](.cursor/rules/shopify-preview-approval.mdc), [use-user-browser.mdc](.cursor/rules/use-user-browser.mdc) enforce credentials in .env.local only; preview before apply; no headless Shopify Admin (ToS).
- **CI secret-scan**: [.github/workflows/ci.yml](.github/workflows/ci.yml) runs secret-scan (shpat*, ghp*, shpss\_) on tracked files; .env.example and .env.shopify.example excluded.
- **Secrets in repo**: Grep for token/secret/api_key patterns found only doc and config references (env var names, setup instructions); no hardcoded credentials in tracked code.
- **GitHub Actions**: Workflows use `contents: read` or least privilege; Shopify secrets only in shopify-sync and deploy (env vars, not CLI args).
- **Shopify ToS**: No headless admin automation; API + user's browser only (see [.cursor/plans/expert_team_security_and_platform_plan_fbf7f611.plan.md](.cursor/plans/expert_team_security_and_platform_plan_fbf7f611.plan.md)).

---

## npm audit (2026-01-30)

- **Result**: 6 moderate severity vulnerabilities.
- **Findings**: (1) esbuild (via vite/vitest) — dev server request issue [GHSA-67mh-4wv8-2f99]; (2) eslint — circular reference serialization [GHSA-p5wg-g6qr-c7cg].
- **Fix**: `npm audit fix --force` would apply breaking upgrades (vitest 4.x, eslint 9.x). **Recommendation**: Defer to planned dependency upgrade; document in [docs/security/00_security_checklist.md](docs/security/00_security_checklist.md). For local dev, avoid exposing dev server to untrusted origins.
- **Re-run**: After dependency updates; maintenance.yml creates dependency PRs.

---

## Security verification (2026-01-31)

- Token echo in `scripts/shopify/browser/get-access-token.ps1` removed; script no longer outputs full token to console.
- CI secret-scan exclusions updated to include `.env.shopify.example`.
- **npm audit snapshot (2026-01-31)**: 6 moderate, 0 high, 0 critical. Same as 2026-01-30 (esbuild/vitest, eslint). CI uses `--audit-level=high` so moderate findings do not fail PRs.

---

## Deliverable

- Security baseline confirmed: .env.local gitignored; rules and CI aligned; no secrets in tracked files; npm audit documented with deferral rationale.
- **Secrets inventory**: Local dev → `.env.local`; CI → GitHub Actions secrets (SHOPIFY\_\*, GITHUB_TOKEN). See [docs/CREDENTIALS_SETUP.md](docs/CREDENTIALS_SETUP.md) and [docs/security/00_security_checklist.md](docs/security/00_security_checklist.md).
