# Fix-and-Perfect Plan (2026-02-07)

**Context**: Guru full-system setup and automation plan — Phase 3 audit. Automated checks (parse-all-ps1, lint, test:unit) pass. This document records findings and prioritized fixes (P0/P1/P2).

---

## Findings

| Area                       | Status | Notes                                                                                                                                                                                 |
| -------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Parse**                  | OK     | 73/73 PowerShell scripts parse (parse-all-ps1.ps1).                                                                                                                                   |
| **Lint**                   | OK     | ESLint 0 errors.                                                                                                                                                                      |
| **Unit tests**             | OK     | Vitest pass.                                                                                                                                                                          |
| **Workflows**              | OK     | ci.yml, codeql.yml, shopify-sync, sync-theme-branch, sync, maintenance; required secrets documented in .github/workflows/README.md.                                                   |
| **Hardcoded repo paths**   | P0     | Multiple scripts set `$repoPath = "C:\Users\LegiT\against-the-odds"`; should use repo-root resolution from `$PSScriptRoot` (see verify-pipeline.ps1 or scripts/shared/utilities.ps1). |
| **Runbook / pipeline doc** | P1     | Done in Phase 1: OPERATOR_RUNBOOK "Before push" verify-pipeline; workflows README "full verify-pipeline local-only"; branch-protection script documented.                             |
| **Scripts index**          | P2     | scripts/README.md should list full-setup.ps1; otherwise current.                                                                                                                      |
| **Inventories**            | P2     | BRANCH_INVENTORY, ENVIRONMENTS_AND_SECRETS_INVENTORY, INDEX_REPORTS confirmed/refreshed as needed.                                                                                    |

---

## Prioritized list

### P0 (blocking: portable paths, parse, lint, tests, secrets doc)

1. **Hardcoded repo paths** — Owner: scripts. Replace `$repoPath = "C:\Users\LegiT\against-the-odds"` with repo-root resolution in all affected scripts. Pattern: `$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "<relative>")).Path } else { (Get-Location).Path }` where `<relative>` is `".."` for scripts in `scripts/`, `"..\.."` for `scripts/*/`, `"..\..\.."` for `scripts/shopify/browser/` or `scripts/archive/root-scripts-legacy/`.
2. Parse/lint/tests — Already pass; no change.
3. Secrets doc — Already in .github/workflows/README.md; no change.

### P1 (runbook, pipeline alignment)

1. Runbook clarity and pipeline doc — Done in Phase 1 (OPERATOR_RUNBOOK, workflows README, visual guide).
2. OPERATOR_RUNBOOK alignment with verify-pipeline — Done (before-push step).

### P2 (inventories, optional)

1. scripts/README.md — Add full-setup.ps1 to Setup or a "Full setup" row.
2. Inventories — Confirm BRANCH_INVENTORY, ENVIRONMENTS_AND_SECRETS_INVENTORY, INDEX_REPORTS; add FIX_AND_PERFECT_PLAN_20260207 to INDEX_REPORTS.

---

## Phase 3b execution

- **P0**: Apply hardcoded-path fixes to all listed scripts; re-run parse-all-ps1 to confirm.
- **P1**: No further work (completed in Phase 1).
- **P2**: Update scripts/README.md; add this plan to INDEX_REPORTS.
