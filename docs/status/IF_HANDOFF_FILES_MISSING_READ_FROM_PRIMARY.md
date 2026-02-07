# If handoff files are missing (read from primary)

**Purpose**: When working in a **worktree** (ewa, mhx, snq, uub, opo, qqa) where handoff/plan docs are missing or stale, read them from the **primary repo** so you have the single source of truth.

---

## Primary repo path

- **Path**: `C:\Users\LegiT\against-the-odds`
- **Branch**: `main`
- **Use for**: CONSOLIDATION_LOG, BRANCH_INVENTORY, WORKTREE_INVENTORY, HANDOFF_FOR_NEW_AGENT_202602.md, PLAN_AGENT_ENTRY.md, and the canonical plan (`.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md`).

---

## Rule

When in a worktree, read handoff and plan docs from the primary path above. Prefer running fixes and commits from the primary worktree so inventories and CONSOLIDATION_LOG stay consistent. See **EXECUTIVE_DECISION_WORK_PRINCIPLES.md** (worktree rule).

---

## References

- BRANCH_INVENTORY.md — branch and worktree table (primary = first row).
- WORKTREE_INVENTORY.md — actual worktrees from `git worktree list`.
- .cursor/worktrees.json — `inventoryDoc` → this folder; setup-worktree commands.
