# Plan Agent Entry — Read This First

**Purpose**: When a new agent (or new session) takes over this repo, read this file first, then execute the plan below.

---

## 1. Read This First

You are entering the **Against The Odds (AO)** project. Before doing any other work:

1. **Read this file** (`docs/status/PLAN_AGENT_ENTRY.md`).
2. **If Phase 0 is already signed off** (see [docs/status/PHASE_0_FINALIZATION.md](PHASE_0_FINALIZATION.md) and [docs/status/CONSOLIDATION_LOG.md](CONSOLIDATION_LOG.md)), skip re-execution and go to [docs/status/NEXT_BEST_STEPS_20260131.md](NEXT_BEST_STEPS_20260131.md) and [docs/AGENT_PROMPT_DECISION_TREE.md](../AGENT_PROMPT_DECISION_TREE.md) for ongoing work.
3. **Otherwise**, execute the plan described in the next section.

---

## 2. The Plan You Must Execute

The project mandates **Phase 0** (full cleanup and finalization) before any other execution phase. The authoritative source for this is:

| Document                                                      | Role                                                                                   |
| ------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **`prompts/PERFECT_EXECUTION_PROMPT.md`**                     | Defines Phase 0 scope, checklist, gate, and sign-off. **Read it and follow it.**       |
| **`.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md`** | Single canonical plan (Phase 0 + Tracks A–G + Synthesis); see .cursor/plans/README.md. |

### Execution steps (in order)

1. **Read** `prompts/PERFECT_EXECUTION_PROMPT.md` in full.
2. **Satisfy Phase 0**  
   Work through the Phase 0 completion checklist in that prompt. Scope includes:
   - All branches (local + remote); merge state and cleanup.
   - All local directories and files; structure, naming, consolidation.
   - All Cursor/IDE problems (e.g. 620+): each resolved or deferred with reason; zero unresolved at sign-off unless documented.
   - All WIP and unfinished work completed, removed, or documented and tracked.
   - All tasks/processes/issues reviewed and optimized.
   - Website/server data and Shopify/Cloudflare profile/info reviewed and documented (or deferred with reason + next steps if access is blocked).
3. **Record sign-off**  
   Only after the checklist is fully satisfied:
   - Update `docs/status/PHASE_0_FINALIZATION.md`.
   - Add the **exact** line: **Phase 0 finalized; proceeding allowed.**
   - Include timestamp and a brief summary of what was finalized.
4. **Gate**  
   Do **not** proceed to planning execution, expert cycles, feature work, or other phases until Phase 0 sign-off is recorded.

---

## 3. Related Context (Optional but Recommended)

- **Agent permission and when agents use your browser**: [AGENTS.md](../../AGENTS.md) (repo root) — full permission; safety rules; when to use Cursor browser MCP.
- **Handoff for new agent** (context, permissions, exact prompt): `docs/HANDOFF_PROMPT_NEW_AGENT.md`
- **System finalization report** (inventory, blockers): `docs/status/system_finalization_report_20260129.md`
- **Operator runbook** (daily checks, Shopify, credentials): `OPERATOR_RUNBOOK.md`
- **Consolidation log** (Phase 0 + all tracks, resolved issues): `docs/status/CONSOLIDATION_LOG.md`
- **Index of reports and status files**: `docs/status/INDEX_REPORTS.md`

---

## 4. Quick Reference

| Need                               | Where                                                     |
| ---------------------------------- | --------------------------------------------------------- |
| Agent permission and browser use   | [AGENTS.md](../../AGENTS.md) (repo root)                  |
| Phase 0 definition and checklist   | `prompts/PERFECT_EXECUTION_PROMPT.md`                     |
| Phase 0 tracker and sign-off file  | `docs/status/PHASE_0_FINALIZATION.md`                     |
| Canonical plan (Phase 0 + tracks)  | `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` |
| Consolidation log (all tracks)     | `docs/status/CONSOLIDATION_LOG.md`                        |
| Index of reports                   | `docs/status/INDEX_REPORTS.md`                            |
| New-agent handoff and prompt       | `docs/HANDOFF_PROMPT_NEW_AGENT.md`                        |
| After Phase 0: which prompt to run | `docs/AGENT_PROMPT_DECISION_TREE.md`                      |

---

## 5. After Phase 0: Which Prompt to Run

Once Phase 0 is signed off, use **`docs/AGENT_PROMPT_DECISION_TREE.md`** to choose the right prompt for audits, orchestration, or specialist work (e.g. full audit → ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT; 10-expert run → MASTER_10_EXPERT_SYSTEM; finalization → head-guru-orchestrator).

---

**Summary**: Read `prompts/PERFECT_EXECUTION_PROMPT.md`, complete Phase 0, record sign-off in `docs/status/PHASE_0_FINALIZATION.md`, then and only then proceed. After that, use `docs/AGENT_PROMPT_DECISION_TREE.md` to pick the next prompt.
