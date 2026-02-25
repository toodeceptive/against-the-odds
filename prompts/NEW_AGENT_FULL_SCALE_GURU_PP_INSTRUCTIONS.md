# Instructions for new agent: full-scale guru PP execution

**Purpose**: Run this in a **new agent instance** to create the guru team and execute all tasks under the master full-scale PP approval. Copy the block below into a new chat.

---

## Step 1 — Open the repo and pull

1. Open the **primary** repo: `C:\Users\LegiT\against-the-odds` (not a workspace root named hal/hvf). This ensures diffs show repo-relative paths; see [docs/TROUBLESHOOTING.md](../docs/TROUBLESHOOTING.md) (do not commit when diff shows hal).
2. Run: `git pull origin main`.

---

## Step 2 — Paste this prompt into a new agent chat

Copy everything between the **START** and **END** lines below into a new Cursor agent conversation, then send.

```
START

You are the lead agent for a full-scale guru PP run. Do the following in order.

1) **Read and adopt the master approval**
   - Read `prompts/MASTER_FULL_SCALE_GURU_PP_PROMPT.md` (approval scope, methods, fix-if-fail rules, 100-step plan, commit policy).
   - Read `docs/status/GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md` (100 steps in 10 phases).

2) **Create the guru expert team**
   - Use `docs/status/GURU_20_TEAMS_60_SPECIALTIES.md` to assign the 20 teams to phases/steps (e.g. Phase 1 = Repo/Git team, Phase 2 = Quality team, etc.).
   - Optionally create a short execution roster (which team owns which phase) and save to `docs/status/` or reference in CONSOLIDATION_LOG.

3) **Execute all tasks**
   - Run the 100-step multiphase PP cycles from the plan: Phase 1 (Repo, Git, worktrees) through Phase 10 (Finalize, commit, push).
   - For each step: perform the action, run the verification; if it fails, fix it then re-verify before proceeding.
   - Use desktop automation, quality gates, verify-pipeline, and full system testing as specified; fix any failures.
   - After each phase: apply multi-faceted guru expert team review; apply fixes/updates as needed.

4) **Apply changes and finalize**
   - All commits and pushes from the **primary** repo path only (`C:/Users/LegiT/against-the-odds`). **Before committing**: If the diff or Source Control shows any path containing `hal` or `hvf`, you are in the wrong workspace and committing would violate the policy—do not commit; open primary as the only workspace root first (see `docs/TROUBLESHOOTING.md`). See `docs/status/WORKTREE_INVENTORY.md` and the "Path and commits" note in `docs/status/CONSOLIDATION_LOG.md`.
   - Update CONSOLIDATION_LOG with a summary entry and update INDEX_REPORTS if you add new reports.
   - Continue until all 100 steps are complete or all remaining work is documented and committed.

5) **If anything fails or is not set up**
   - Fix failures (tests, CLI, settings, GitHub, APIs, connections, extensions).
   - Set up missing pieces manually or autonomously using guru expert multi-agent analysis, review, auditing, and deep research.
   - Document credential-gated or deferred items in HANDOFF or CONSOLIDATION_LOG.

Reply with: "Guru team created. Executing 100-step PP cycles from primary repo." Then start with Phase 1, Step 1.

END
```

---

## Step 3 — What the new agent will do

- **Create** the guru team assignment (20 teams × phases/steps).
- **Execute** Phases 1–10 in order (Repo/Git → Quality → Pipeline → Cursor → GitHub → Shopify → Tests → Docs → Cleanup → Finalize).
- **Fix** any failing test, CLI error, settings issue, or missing setup.
- **Commit and push** from primary only after guru review; update CONSOLIDATION_LOG and INDEX_REPORTS.

---

## Quick reference (for the new agent)

| Document                                                     | Use                                                  |
| ------------------------------------------------------------ | ---------------------------------------------------- |
| `prompts/MASTER_FULL_SCALE_GURU_PP_PROMPT.md`                | Master approval and scope                            |
| `docs/status/GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md` | 100 steps, 10 phases                                 |
| `docs/status/GURU_20_TEAMS_60_SPECIALTIES.md`                | Team roster for assignment                           |
| `OPERATOR_RUNBOOK.md`                                        | Daily gates, repo root, verify-pipeline              |
| `docs/status/WORKTREE_INVENTORY.md`                          | Primary path; no hal/hvf commits                     |
| `docs/status/CONSOLIDATION_LOG.md`                           | Append summary when done                             |
| `docs/TROUBLESHOOTING.md`                                    | hal/hvf workspace; do not commit when diff shows hal |
