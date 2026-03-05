# Perfect Follow-up Plan Prompt - 2026-03-05

**Source**: `docs/status/GURU_EXPERT_REVIEW_AUDIT_ANALYSIS_20260305.md`

**Invoke**: `/pp execute PERFECT_FOLLOWUP_PLAN_PROMPT_20260305.md`

---

## Objective

Execute a delta-only closure pass that resolves high-impact documentation and workflow drift, validates the result, and finalizes via commit/push without touching store-affecting operations.

---

## Execution Sequence

1. **Load baseline**
   - Read `docs/status/PP_AUDIT_MARKER.md`, `docs/status/CONSOLIDATION_LOG.md`, and latest audit report.
   - Capture current `git rev-parse HEAD`, `git branch -a -vv`, and `git worktree list --porcelain`.

2. **Resolve P0 findings first**
   - Align `docs/status/BRANCH_INVENTORY.md` and `docs/status/WORKTREE_INVENTORY.md` with live git state.
   - Ensure active worktree and baseline commit are represented correctly.

3. **Refresh PP control docs**
   - Update `docs/status/PP_AUDIT_MARKER.md` with current delta-audit timestamp and baseline.
   - Append a new cycle entry in `docs/status/PP_AUDIT_CYCLE_20260227.md`.
   - Append a dated entry in `docs/status/CONSOLIDATION_LOG.md`.

4. **Update prompt/report indexing**
   - Add the new dated audit and prompt references to `docs/status/INDEX_REPORTS.md`.
   - Add the new prompt to `prompts/README.md`.

5. **Progress-check and blocker classification**
   - Re-check plan tasks in `.cursor/plans/`.
   - Mark unresolved items with explicit owner and next action (no silent deferrals).

6. **Verification gates**
   - Run `npm run format:check`
   - Run `npm run lint`
   - Run `npm run test:unit`
   - Run `pwsh -NoProfile -ExecutionPolicy Bypass -File "scripts/verify-pipeline.ps1" -SkipRunbook`

7. **Finalize**
   - Stage only files changed by this cycle.
   - Commit with a message that reflects audit + remediation + indexing.
   - Push to a remote branch (do not force push; do not push to main without explicit approval).

---

## Hard Constraints

- No fabricated access, results, or verification.
- No secrets in logs, prompts, docs, or commits.
- No Shopify/theme/product apply operations without preview and approval workflow.
- Prefer smallest safe edits; avoid broad non-delta rewrites.

---

## Required Deliverables

- Updated inventory and marker docs
- Prioritized finding closure notes
- Progress-check delta update
- Verification results with pass/fail evidence
- Commit hash + pushed branch + residual blockers

---

## Definition of Done

- P0 inventory/marker drift resolved
- New audit + follow-up prompt indexed and traceable
- Verification gates pass (or blocker explicitly documented)
- Commit and push completed with no unresolved critical items
