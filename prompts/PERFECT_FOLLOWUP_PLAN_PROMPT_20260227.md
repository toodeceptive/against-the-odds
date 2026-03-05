# Perfect Followup Plan — Guru Expert Execution (2026-02-27)

**Source**: GURU_EXPERT_REVIEW_AUDIT_ANALYSIS_20260227.md

**Invoke**: `/pp` then "Execute PERFECT_FOLLOWUP_PLAN_PROMPT_20260227."

---

## Intent

Execute a delta-only, non-redundant cleanup and closure pass based on the guru expert audit. Fix only what is actionable now; skip credential-gated and deferred items.

---

## Task sequence

### Step 1: Resolve fix-handoff-line.mjs

- **Context**: File was deleted in Cycle 10 (temp script). Recreated in prior session for lint fix. Now untracked.
- **Action**: Delete `scripts/debug/fix-handoff-line.mjs` (per CONSOLIDATION_LOG: one-off temp; no longer needed). Fix lint if any other file references it (none expected).

### Step 2: Align inventories

- **BRANCH_INVENTORY**: Primary commit b164c45 → aa210e4; add `cursor/cloud-ecosystem-perfection-0913` to optional branches.
- **WORKTREE_INVENTORY**: Primary commit b164c45 → aa210e4.

### Step 3: Fix fix-handoff-line eslint-env deprecation (if kept)

- **If Step 1 keeps file**: Replace `/* eslint-env node */` with `/* global console */` or remove if redundant; silence ESLint deprecation warning.
- **If Step 1 deletes**: Skip.

### Step 4: Commit (push requires approval)

- Stage all audit-derived and OpenClaw-cleanup files (CHANGELOG, HOOKS, PRODIGYCLAW_TEARDOWN, apply-session-start-hook, GURU_EXPERT_REVIEW, PERFECT_FOLLOWUP_PLAN, inventories, CONSOLIDATION_LOG, PP_AUDIT_CYCLE, INDEX_REPORTS, prompts/README). If Cycle 14 already staged these, verify with `git status`.
- Commit: `chore(pp): guru expert audit, followup plan, OpenClaw final cleanup, inventory alignment`
- **Push**: Requires explicit user approval. After commit, ask: "Approve push to main? Say 'approve' to push."

### Step 5: Update CONSOLIDATION_LOG and PP_AUDIT_CYCLE

- Append CONSOLIDATION_LOG: guru expert review, audit, analysis; perfect followup plan creation and execution; inventory alignment; fix-handoff-line resolution.
- Add Cycle 14 to PP_AUDIT_CYCLE_20260227.md.

### Step 6: Update INDEX_REPORTS and prompts/README

- Add GURU_EXPERT_REVIEW_AUDIT_ANALYSIS_20260227 and PERFECT_FOLLOWUP_PLAN_PROMPT_20260227 to INDEX_REPORTS current canonical table.
- Add PERFECT_FOLLOWUP_PLAN_PROMPT_20260227 to prompts/README canonical section.

### Step 7: Verify

- `npm run quality` — must pass.
- Inventories match `git branch -a` and `git worktree list` for Primary commit and branch list.

---

## Constraints

- No store-affecting changes.
- No secrets in commits.
- Skip: theme pull, runbook credential steps, extensions plan full run (deferred).
- Do not re-edit files already correct in prior cycles.

---

## Success criteria

- [ ] fix-handoff-line.mjs resolved (deleted or lint-clean)
- [ ] BRANCH_INVENTORY and WORKTREE_INVENTORY aligned with live git state
- [ ] All audit-derived changes committed (after approval)
- [ ] CONSOLIDATION_LOG and PP_AUDIT_CYCLE updated
- [ ] INDEX_REPORTS and prompts/README updated
- [ ] npm run quality passes
