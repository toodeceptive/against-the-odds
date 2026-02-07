# Full-scale PP audit — 2026-02-07

**Purpose:** Guru-expert, multi-faceted PP-cycle audit of the Against the Odds repo: extensions, codebase, repo/remotes, E2E, pipeline, security, automations, scripts, and PC control. Includes decisions on GitHub necessity, repo visibility, and local vs remote usage. User approved all guru-backed setups and automations.

---

## 1. Executive summary

| Area                           | Status        | Actions taken                                                                                                        |
| ------------------------------ | ------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Extensions & Cursor config** | ✅ Optimal    | extensions.json, settings.json, rules, skills aligned; no changes needed.                                            |
| **Codebase quality**           | ✅ Fixed      | Prettier (2 docs), ESLint (9 warnings → 0), unit tests pass.                                                         |
| **Scripts / pipeline**         | ✅ Fixed      | Duplicate block removed from `get-access-token.ps1`; verify-pipeline passes (73/73 parse, lint, workflows, dry-run). |
| **Repo & remotes**             | ✅ Documented | origin = GitHub toodeceptive/against-the-odds; package.json `"private": true`.                                       |
| **E2E & CI**                   | ✅ In place   | ci.yml, codeql.yml, storefront.spec.js, shopify-admin e2e; quality gates enforced.                                   |
| **Security & secrets**         | ✅ Aligned    | .env.local only; CI secret-scan; Trivy/CodeQL; docs/security.                                                        |
| **GitHub necessity & local**   | ✅ Decided    | See §5: GitHub recommended for theme deploy + CI; can run fully local with optional push for updates.                |
| **Automations & tasks**        | ✅ Updated    | Theme update→preview→save task added; automation guide and store ops doc referenced.                                 |

**Verification:** `npm run quality` (format, lint, test:unit) and `.\scripts\verify-pipeline.ps1 -SkipRunbook` both pass.

---

## 2. Areas audited

### 2.1 Extensions and Cursor config

- **.cursor/extensions.json:** EditorConfig, PowerShell, Prettier, ESLint, Playwright, Vitest, GitLens, GitHub PR, dotenv, markdownlint, YAML, TypeScript, Tailwind, path-intellisense, Shopify theme-check, Codacy, Python. No unwanted recommendations.
- **.cursor/settings.json:** formatOnSave, ESLint fix on save, worktree settings, PowerShell/YAML/liquid associations, autoSave, trim trailing whitespace, final newline. Aligned with CURSOR_AND_AGENT_OPTIMIZATION.md.
- **Rules:** env-credentials, shopify-preview-approval, use-user-browser, pp-basis (always-on); ao-guru (globs). No conflicts.
- **Skills:** prodigy-protocol, prodigy-phantasm, universal-godmode, agentic-performance. AGENTS.md includes guru/PP approved methodology.

**Finding:** Setup is optimal for Cursor on local PC and agent operations. No changes required.

### 2.2 Codebase: lint, tests, structure

- **Prettier:** Two files had style issues → fixed: `docs/AUTOMATION_IMPLEMENTATION_GUIDE.md`, `docs/STORE_OPERATIONS_AUTOMATION.md`.
- **ESLint:** 9 warnings in `optimize-images.mjs` (no-console, unused `e`) and `capture-preview-screenshot.mjs` (no-console). Fixed: `/* eslint-disable no-console */` for CLI scripts; `catch (_e)` for unused var. **0 errors, 0 warnings** (guru quality gate).
- **Unit tests:** `npm run test:unit` — 2 tests pass (example.test.js).
- **Structure:** Repo layout per FINAL_REPO_ORGANIZATION_AND_AUDIT plan; scripts under `scripts/`, docs under `docs/`, status in `docs/status/`.

### 2.3 Repo, remotes, branches

- **Remote:** `origin` = `https://github.com/toodeceptive/against-the-odds.git` (fetch/push).
- **package.json:** `"private": true` (npm private; does not set GitHub visibility).
- **Branches:** main (default); chore/script-paths-utilities-gitignore (current work); feature/ao-brand-shopify-automation, cursor/main-project-setup-2bd1, handoff-doc-permissions-20260129, mlf-main; shopify-theme (workflow-created). See BRANCH_INVENTORY.md.
- **Worktrees:** Primary at repo path; mhx at handoff-doc-permissions. See WORKTREE_INVENTORY.md.

**GitHub visibility:** Set on GitHub (Settings → General → Danger zone → Change visibility). Package.json `private: true` is for npm only; repo visibility is independent. If you want the repo private: GitHub → Settings → General → Danger zone → Change repository visibility → Private.

### 2.4 E2E, pipeline, automations

- **Workflows:** ci.yml (format, lint, test:unit, Trivy, secret-scan, Lighthouse continue-on-error), codeql.yml (JavaScript, continue-on-error), shopify-sync.yml, sync-theme-branch.yml, sync.yml, maintenance.yml. All present; verify-pipeline checks them.
- **E2E:** tests/e2e/example.spec.js (site); storefront.spec.js (store homepage + product demo screenshot); shopify-admin (Playwright Shopify config). Run: `npm run test:e2e`, `npm run test:shopify`.
- **Automations:** theme-update-preview-save.ps1, optimize-images.ps1 (-Preset embroidery), setup-app-access.ps1, run-runbook.ps1, verify-pipeline.ps1. OPERATOR_RUNBOOK.md and docs/AUTOMATION_IMPLEMENTATION_GUIDE.md document flows.
- **Cursor tasks:** Theme update→preview→save task added to .cursor/tasks.json. Other tasks: Theme Dev, Setup app access, Optimize images, Verify Pipeline, Run Runbook, etc.

### 2.5 Security, secrets, bots, checks

- **Secrets:** .env.local only (gitignored); never commit. env-credentials.mdc always-on. CI uses GitHub Actions secrets (SHOPIFY\_\*, etc.).
- **CI checks:** secret-scan (blocklist shpat*, ghp*, shpss\_); Trivy (SARIF upload); CodeQL (continue-on-error); npm audit (continue-on-error). No secrets in tracked files.
- **Bots:** Dependabot (npm, weekly Sunday; open PR limit 5). No other bots configured in repo.
- **Profile/repo settings:** Not readable by agent (no API call). To review: GitHub → Settings → Security (2FA, etc.); Repository → Settings → General (visibility, branch protection); Settings → Secrets and variables → Actions; Settings → Code security and analysis (Dependabot, code scanning).

**Recommendation:** Ensure branch protection on `main` (require PR or status checks) if you want to enforce review before merge. Document in docs/security.

### 2.6 PC control / desktop automation

- **Location:** src/desktop-automation/ (screen-capture, keyboard-control, mouse-control, window-manager, ocr-reader, orchestrator, workflow-manager). Optional deps: robotjs, node-window-manager.
- **Usage:** Theme preview capture, product demo fallback, “see my screen” flows. See docs/AUTOMATION_IMPLEMENTATION_GUIDE.md.
- **Tests:** tests/desktop-automation/\*.test.js; npm run test:desktop (optional; may require native build on Windows).

---

## 3. Fixes applied (this session)

1. **Prettier:** `docs/AUTOMATION_IMPLEMENTATION_GUIDE.md`, `docs/STORE_OPERATIONS_AUTOMATION.md` — formatted.
2. **ESLint:** `scripts/shopify/optimize-images.mjs` — `catch (_e)`, `/* eslint-disable no-console */`. `scripts/shopify/capture-preview-screenshot.mjs` — `/* eslint-disable no-console */`.
3. **PowerShell parse:** `scripts/shopify/browser/get-access-token.ps1` — removed duplicate catch/finally block (lines 146–161).
4. **Cursor task:** Added “Shopify: Theme update → preview → save” to .cursor/tasks.json.

---

## 4. Do we need a GitHub repo? Is it private? Local vs remote

### 4.1 Do we need a GitHub repo?

**Guru decision: recommended but not strictly required.**

- **With GitHub:** Theme deployment via Shopify GitHub App (push to main → theme sync); CI (format, lint, tests, security scans) on push/PR; backup and history; Dependabot; optional collaboration.
- **Without GitHub (local only):** You can run all quality checks locally (`npm run quality`, `.\scripts\verify-pipeline.ps1`), edit theme and products, run theme dev, and push theme/products via Shopify CLI or Admin API from your PC. You lose: automated CI on push, Shopify “Connect from GitHub” theme auto-deploy, and cloud backup. So you _can_ run fully locally and use web/online only for Shopify Admin, theme pull, or manual uploads.

**Conclusion:** For “best possible setup” and pipeline automations (CI, theme branch sync, product sync workflow), **keeping the GitHub repo is ideal**. For a purely local setup with no CI and manual theme deploy, you can work without GitHub.

### 4.2 Is the repo private?

- **package.json** has `"private": true` (npm: no accidental publish).
- **Actual visibility** is set on GitHub: Settings → General → Danger zone → Change repository visibility. If you want maximum privacy, set the repo to **Private** there. The agent cannot read GitHub profile/repo settings; verify in the GitHub UI.

### 4.3 What settings does my profile/repo have (security, bots, checks)?

- **Not readable by agent.** Check in GitHub:
  - **Profile:** Settings → Password and authentication (2FA); Developer settings → Personal access tokens.
  - **Repo:** Settings → General (visibility, default branch); Security → Code security and analysis (Dependabot, code scanning); Branches → Branch protection (main); Secrets and variables → Actions.
- **Documented in repo:** CI runs format check, lint, unit tests, secret-scan, Trivy, CodeQL (continue-on-error), optional Lighthouse. Dependabot: npm, weekly. See .github/workflows/README.md and docs/security/AGENT_AND_REPO_SECURITY.md.

### 4.4 Can this system be used locally instead, or privately, with web/online for updates?

**Yes.**

- **Fully local:** Work in Cursor on your PC; run `npm run quality`, `.\scripts\verify-pipeline.ps1`, theme dev, product sync (with .env.local). No push to GitHub required. Use Shopify Admin in browser for one-off changes; use scripts for theme/product updates from local.
- **Private repo:** Set GitHub repo to Private; only you (and collaborators you add) can see it. CI and Actions still run; use GitHub only for backup and CI, not for public visibility.
- **Web/online for updates:** Pull from GitHub when you want to get updates (e.g. after editing on another machine or after CI). Push when you want to trigger theme deploy or run CI. You can also use “web/online” only for Shopify (Admin, theme app) and keep code entirely local.

**Conclusion:** The system supports (1) local-only use, (2) private GitHub repo with web/online for updates and CI, and (3) public repo if you choose. Best practice for your described use: **private GitHub repo + local Cursor + runbook/verify-pipeline locally and on push.**

---

## 5. Recommendations and finalization

1. **Merge current branch:** Merge `chore/script-paths-utilities-gitignore` (and any other pending work) to main; push. Ensures CI runs on the latest code and uncommitted automation docs/scripts are in the repo.
2. **GitHub visibility:** If you have not already, set repo to **Private** in GitHub Settings → General → Danger zone if you want maximum privacy.
3. **Branch protection:** Optionally require a pull request and/or status checks for `main` (GitHub → Settings → Branches → Add rule).
4. **Daily use:** Run `npm run quality` or `.\scripts\verify-pipeline.ps1` before push; use Cursor tasks for Theme update→preview→save, Theme Dev, Setup app access, Optimize images.
5. **Cleanup:** No further code cleanup required from this audit. Optional: archive or delete stale branches (see BRANCH_INVENTORY.md) when no longer needed.
6. **Docs:** This audit is recorded in docs/status/; INDEX_REPORTS.md can reference FULL_SCALE_PP_AUDIT_20260207.md for future agents.

---

## 6. Sign-off

Full-scale PP audit completed. Quality gates pass; script parse fixed; Prettier/ESLint clean; pipeline verification passes. GitHub necessity and local/private usage decided and documented. User-approved guru methodology and automations are in place; repo is ready for seamless, optimal agent and operator use on Cursor on local PC.
