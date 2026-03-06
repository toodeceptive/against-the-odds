# Agent automation readiness — no-issues checklist

**Purpose:** Ensure the agent can automate all project work/tasks/processes without terminal or pipeline issues. Single reference for verification and fixes. Last updated: 2026-02-07.

---

## 1. Terminal verification (all must pass)

| Check              | Command                     | Expected                                                                                                                                       |
| ------------------ | --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Format             | `npm run format:check`      | All files use Prettier code style                                                                                                              |
| Lint               | `npm run lint`              | 0 errors, 0 warnings (ESLint)                                                                                                                  |
| Unit tests         | `npm run test:unit`         | All tests pass                                                                                                                                 |
| Integration tests  | `npm run test:integration`  | Pass or skip (credential-gated)                                                                                                                |
| Pipeline           | `npm run verify:pipeline`   | Verification passed (all tracked PowerShell scripts parse, workflows OK, dry-run OK, lint OK; runbook auto-skips when Shopify token is absent) |
| Runbook (optional) | `.\scripts\run-runbook.ps1` | Pass when `.env.local` has Shopify + optional GitHub tokens                                                                                    |

**If any fail:** Fix the reported issue (e.g. script parse error, ESLint warning), then re-run. See OPERATOR_RUNBOOK.md and .github/workflows/README.md for CI parity.

---

## 2. Agent full access and permissions

- **AGENTS.md:** Full permission to run scripts, edit files, commit, push; safety rules (preview-before-apply for store, no secrets in commits) apply.
- **Credentials:** `.env.local` only; agent may read/write for setup; never commit. See `.cursor/rules/env-credentials.mdc`.
- **Runbook:** `.\scripts\run-runbook.ps1` — daily checks, Shopify/GitHub verification (credential-gated).
- **Cursor tasks:** All project tasks in `.cursor/tasks.json` (Theme Dev, legacy direct theme update helper, Setup app access, Verify Pipeline, Run Runbook, Preview/Apply Product Sync, Quality Gate, Health Check, etc.). Run from repo root.

No additional permissions needed for full Cursor agent functionality; existing setup grants full access within safety rules.

---

## 3. Automations wired and available

| Automation                    | Script / task                                                                      | Notes                                                                                           |
| ----------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Daily quality                 | `npm run quality`                                                                  | format:check + lint + test:unit                                                                 |
| Auto-fix quality              | `npm run quality:fix`                                                              | format + lint:fix + quality                                                                     |
| Pipeline verify               | `npm run verify:pipeline`                                                          | Script parse, workflows, product dry-run, lint; auto-skips runbook when Shopify token is absent |
| Pipeline verify (strict)      | `npm run verify:pipeline:strict`                                                   | Full local integration gate when Shopify credentials are expected                               |
| Theme update → preview → save | `.\scripts\shopify\theme-update-preview-save.ps1`                                  | Legacy direct-push helper; use preview/approval flow before any direct apply                    |
| Theme dev                     | `.\scripts\shopify\theme-dev.ps1`                                                  | Cursor task: "Shopify: Theme Dev (preview before commit)"                                       |
| App access setup              | `.\scripts\shopify\setup-app-access.ps1`                                           | E2E + runbook or launch Chrome first                                                            |
| Image optimize                | `.\scripts\shopify\optimize-images.ps1`                                            | Web or `-Preset embroidery`                                                                     |
| Product sync                  | `node scripts/shared/run-powershell.cjs scripts/shopify/sync-products.ps1 -DryRun` | Preview first; apply only after approval using the non-`-DryRun` command                        |
| Store connection              | `node scripts/shared/run-powershell.cjs scripts/shopify/test-connection.ps1`       | Requires SHOPIFY\_\* in .env.local                                                              |
| GitHub auth                   | `node scripts/shared/run-powershell.cjs scripts/github/verify-auth.ps1`            | Requires GITHUB_TOKEN in .env.local (optional)                                                  |

All necessary automations for project work are in place and callable by the agent via npm scripts or PowerShell from repo root.

---

## 4. Known non-blockers (by design)

- **Strict runbook gate:** `npm run verify:pipeline:strict` or `node scripts/shared/run-powershell.cjs scripts/run-runbook.ps1` will fail until `SHOPIFY_ACCESS_TOKEN` is set in `.env.local`. Use docs/status/CREDENTIAL_SETUP_STEPS.md or scripts/shopify/browser/save-token-to-env.ps1.
- **Integration tests:** Skip when credentials not set; not a pipeline failure.
- **CodeQL / Trivy / Lighthouse:** CI jobs may have `continue-on-error: true`; do not block merge.
- **E2E (Playwright):** Require env/network; run manually or in CI when configured.

---

## 5. Fix applied this session (2026-02-07)

- **get-access-token.ps1:** Removed corrupted tail (stray "WrRemove-Itemi…", "e-Ho}", "st \"\""). File now ends with `} finally { … }` and `Write-Host ""`. All tracked PowerShell scripts parse; verify-pipeline passes.

---

## 6. Completion status

- **Terminal:** All checks pass (format:check, lint, test:unit, `npm run verify:pipeline`). Integration tests skip without credentials (by design).
- **Agent access:** Full; automations and tasks available; safety rules documented.
- **Next step (optional):** Merge `chore/script-paths-utilities-gitignore` to main and push to persist all conversation work (automation docs, scripts, audit, fixes). Then run `.\scripts\verify-pipeline.ps1` with or without runbook as needed.
