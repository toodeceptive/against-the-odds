# If handoff / plan files are missing in this worktree

**When this applies:** You are in a worktree (e.g. uqy, snq, mhx) and were asked to read one or more of:

- `docs/status/PLAN_HANDOFF_FOR_NEXT_AGENT.md`
- `.cursor/plans/README.md` or `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md`
- `docs/status/CONVERSATION_AUDIT.md`

but they are **not present** in this worktree.

**What to do:** Read those files from the **primary worktree**:

- **Path:** `C:\Users\LegiT\against-the-odds` (main branch)
- **Files:**
  - `docs/status/PLAN_HANDOFF_FOR_NEXT_AGENT.md`
  - `.cursor/plans/README.md` (canonical plan index; FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md is the single plan)
  - `docs/status/CONVERSATION_AUDIT.md`

**Then:** Fold any extra requirements from those documents into your plan. In particular:

- **Expert Team decisions (do not redo):** Shopify ToS (no headless admin automation; theme via GitHub, products via API with approval or user's browser); local-only = `.env.local` at repo root; Cursor data boundary (secrets only in `.env.local`); unified approval flow (`docs/status/pending-approval.md` → approve in chat → apply and clear).
- **Single source for “what to do next”:** This plan plus the system report and handoff prompt; avoid duplicate trackers.

If you cannot read from the primary path (e.g. different machine), treat the “What is already done” and “What remains” from the plan you _did_ receive (e.g. from HANDOFF_PROMPT_NEW_AGENT.md and system_finalization_report) as the baseline, and add the Expert Team rules above from this note so Security & Platform Plan work stays consistent.
