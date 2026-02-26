# Proceed with Unfinished Works — Guru Expert Follow-Up Prompt

**Purpose**: Single authoritative prompt for running comprehensive audit-and-close cycles. Use after prior guru work; incorporates all progress, tasks, and results to date. Designed for follow-up runs with full user approval.

---

## Directive

Proceed with **all unfinished works** after in-depth, comprehensive research, review, analyses, and auditing. I approve **all actions** to proceed progressively: audit, check, run Codacy operations, optimize, perfect, and finalize/commit/push any and all works after thorough review and analysis, in-depth expert guru research, and auditing. I also approve running secrets functions (e.g. `set-secrets-from-env.ps1`) when needed.

---

## Execution Flow (PP-aligned)

1. **Research & audit**
   - Read `docs/status/WORK_QUEUE.md`, `docs/status/PP_AUDIT_MARKER.md`, `docs/status/CONSOLIDATION_LOG.md` (latest entries first).
   - Check `git status`, `git log --oneline -5`; identify uncommitted changes and remaining blockers.
   - Review Problems panel / linter output for all reported issues (ESLint, Codacy Lizard, markdownlint, etc.).

2. **Fix all problems**
   - Resolve every console/linter problem (e.g. MD031 blanks-around-fences, Lizard cyclomatic complexity, NLOC limits).
   - Run `npm run quality`, `.\scripts\verify-pipeline.ps1 -SkipRunbook`, and `.\scripts\run-runbook.ps1 -StrictSecrets` (when creds present).

3. **Codacy operations**
   - Run `codacy_cli_analyze` on each edited file per `.cursor/rules/codacy.mdc`.
   - After npm install or dependency changes, run Codacy with tool `trivy`.
   - Apply fixes for any issues found.

4. **Optimize & perfect**
   - Refactor for complexity (extract helpers, reduce cyclomatic complexity below Lizard threshold 8, NLOC below 50 per function where possible).
   - Align docs with actual state; update WORK_QUEUE, PP_AUDIT_MARKER, CONSOLIDATION_LOG as needed.

5. **Finalize**
   - Commit with clear messages; push to `main` when approved.
   - For store-affecting changes (theme push, product sync, secrets): follow preview-before-apply; write to `docs/status/deploy-log.md` after apply.

---

## Current Baseline (as of 2026-02-26)

- **Credentials**: Closed via `save-token-from-file.ps1`; `set-secrets-from-env.ps1` executed; SHOPIFY_STORE_DOMAIN and SHOPIFY_ACCESS_TOKEN in repo Secrets; shopify-sync enabled in CI.
- **Scripts**: `verify-secrets.ps1` uses `--repo` for `gh secret list`; GITHUB_TOKEN fallback from .env.local in set-secrets.
- **Code**: `shopify-admin.js` refactored for Lizard complexity; ESLint globals override for `src/browser-automation`.
- **Docs**: OPERATOR_RUNBOOK MD031 fixed; deploy-log, WORK_QUEUE, PP_AUDIT_MARKER updated.
- **WORK_QUEUE**: P0/P1 done; P2 "Clean residual stale references" only when touched by active work.

---

## Key Paths

| Resource           | Path                                               |
| ------------------ | -------------------------------------------------- |
| Work queue         | `docs/status/WORK_QUEUE.md`                        |
| Audit marker       | `docs/status/PP_AUDIT_MARKER.md`                   |
| Consolidation log  | `docs/status/CONSOLIDATION_LOG.md`                 |
| Runbook            | `OPERATOR_RUNBOOK.md`                              |
| Guru operator guide| `docs/GURU_PP_OPERATOR_GUIDE.md`                   |
| Set repo secrets   | `.\scripts\github\set-secrets-from-env.ps1`        |
| Verify secrets     | `.\scripts\github\verify-secrets.ps1`              |

---

## Rules (unchanged)

- **Preview before apply** for store-affecting changes; no secrets in commits.
- **Use user's browser** when credential or admin flows require it.
- **Codacy**: Run analyze on edited files; run Trivy after dependency changes.

---

_Save and re-use for follow-up guru runs. Update the "Current Baseline" section as work progresses._
