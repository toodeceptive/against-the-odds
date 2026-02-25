# Executive Decision: Work Principles (No Redundancy, Only Progress)

**Authority**: Guru expert executive decision based on repo-recorded history (CONSOLIDATION_LOG, HANDOFF, plan/handoff docs). This binds future work so it is **never redundant, pointless, repeated, or non-progressive** — only improve, enhance, fix, update, rework, or reconstruct.

## What “history” means here

We treat “Cursor history” as the repo’s recorded history:

- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`
- `docs/status/FULL_SYSTEM_AUDIT_20260201.md`
- `docs/status/PLAN_HANDOFF_FOR_NEXT_AGENT.md`

Cursor chat logs outside the repo are not considered authoritative inputs.

---

## 1) Baseline: already done (do not re-run)

Per `docs/status/CONSOLIDATION_LOG.md`, the following is complete:

- Phase 0 inventory
- Tracks A–G
- Synthesis
- Addendum
- Guru pass 2

**Rule**: If Phase 0 is signed off (see `docs/status/PHASE_0_FINALIZATION.md`), do **not** re-run Phase 0 or Tracks A–G. Only incremental work is allowed.

---

## 2) Binding operating decisions (do not contradict)

From handoff docs and CONSOLIDATION_LOG:

- **Shopify ToS-safe**: no unattended headless Shopify Admin automation.
- **Local-only secrets**: secrets live only in `.env.local` (gitignored).
- **Unified approval flow**: snapshot to `docs/status/pending-approval.md` → user approves in chat → apply → clear pending-approval.

---

## 3) Worktree/workspace rule

- **Primary worktree**: `C:\Users\LegiT\against-the-odds` (main).
- Additional worktrees may exist under `C:\Users\LegiT\.cursor\worktrees\against-the-odds\*`; see [WORKTREE_INVENTORY.md](WORKTREE_INVENTORY.md) for current list.

**Rule**: When in a worktree, read handoff/plan docs from the **primary worktree** per `docs/status/IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md`. Prefer running fixes from the primary worktree so inventories/logs stay consistent.

---

## 4) Single execution mode: incremental fix list only

The only valid “fix everything” mode (when Phase 0 is signed off):

1. Read `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`
2. Read `docs/status/CONSOLIDATION_LOG.md` and `docs/status/PHASE_0_FINALIZATION.md`
3. Apply only the incremental fix list below
4. Verify (lint/format/tests + verify-pipeline)
5. Append a dated entry to CONSOLIDATION_LOG

### Incremental fix list (must be concrete, small, outcome-based)

- Fix any **actionable docs** that point to missing plan files (e.g. `full_project_update_perfection_guru.plan.md`) or missing `.cursor/plans/README.md` (if removed).
- Keep a single plan source: `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` (+ optional `.cursor/plans/README.md` as an index only).
- Keep inventories consistent (BRANCH_INVENTORY vs WORKTREE_INVENTORY).
- Keep scripts/configs aligned (e.g. Shopify Admin API version consistency; ESLint 9 flat config usage).

**Success = outcomes**, not “we ran all tracks again.”

---

## 5) System reality check (biggest blocker)

Per `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`, the dominant “system broken” blocker is **Shopify theme pull failing due to SSL/TLS** in this environment.

**Rule**: Do not endlessly re-audit the repo as a substitute for solving the blocker. Either:

- fix the environment/network prerequisite, or
- switch to an operating model that does not require theme pull on this machine (local-only + browser path), while keeping the approval workflow.
