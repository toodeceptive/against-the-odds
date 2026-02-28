# PP Execute — Full Project Cycle

**Purpose**: Reusable task for `/pp` or `-pp`. Run a full Prodigy Protocol cycle on the project without redundancy.

**Invoke**: `/pp` then paste this prompt, or reference it: "Execute PP_EXECUTE_PROJECT_PROMPT."

---

## Task

Run a full PP cycle on the project:

1. **Delta audit** — Scan for new or missed issues only. Skip what prior runs fixed. Check: inventories (BRANCH, WORKTREE) vs `git branch -a` and `git worktree list`; stale refs to removed prompts/plans; incremental fix list items.

2. **Apply fixes** — Fix only non-redundant items. Do not re-edit files already corrected in prior cycles.

3. **Identify incomplete work** — List remaining todos (extensions plan, shopify-cli TODO, stale branches). Do not re-run completed plans.

4. **Verify** — Run `npm run quality`. Confirm inventories aligned.

5. **Log** — Append dated entry to CONSOLIDATION_LOG; update PP_AUDIT_CYCLE_20260227.md if run is a new cycle.

6. **Report** — Summary: what changed, what was skipped (and why), how to verify.

---

## Constraints

- No redundancy with prior PP runs (read CONSOLIDATION_LOG and PP_AUDIT_CYCLE first).
- No store-affecting changes without preview and approval.
- No secrets in commits or logs.
