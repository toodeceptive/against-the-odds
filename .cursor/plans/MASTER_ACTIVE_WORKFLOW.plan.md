---
name: Master Active Workflow
overview: Canonical plan for full guru /pp cycles that covers inventory, deep audit, remediation, consolidation, verification, and finalization with evidence-backed closure.
version: '1'
lastUpdated: '2026-03-05'
todos:
  - id: inventory
    content: Enumerate live branches, worktrees, plans, prompts, status docs, and transcripts
    status: completed
  - id: deep-audit
    content: Run multi-lane audit (inventory drift, md-plan consolidation, progression trace, verifier)
    status: completed
  - id: remediation
    content: Apply P0/P1 fixes for branch/worktree docs, marker drift, and closure evidence
    status: completed
  - id: consolidation
    content: Consolidate active guidance into a master plan and master prompt; remove safe obsolete artifacts
    status: completed
  - id: verify
    content: Execute deterministic quality and pipeline verification gates
    status: completed
  - id: finalize
    content: Commit and push branch updates with explicit residual blockers
    status: completed
isProject: false
---

# Master Active Workflow Plan (Cycle 17)

**Purpose**: Single authoritative execution plan for full-scope /pp cycles so future agents do not duplicate effort or miss closure evidence.

---

## Custom Agent Team (built for this process)

| Team lane          | Role                          | Tooling used                                   | Outcome                                             |
| ------------------ | ----------------------------- | ---------------------------------------------- | --------------------------------------------------- |
| Inventory lane     | Branch/worktree/state auditor | `Subagent` (`explore`) + git commands          | Live drift identified and prioritized               |
| Consolidation lane | MD/plan overlap auditor       | `Subagent` (`explore`) + repo search           | Canonical/historical/delete map produced            |
| Progression lane   | Conversation evidence auditor | `Subagent` (`explore`) + transcript review     | Timeline/citation and closure gap findings produced |
| Verification lane  | Independent QA verifier       | `Subagent` (`verifier`) + deterministic checks | Independent pass/fail matrix produced               |
| Lead lane          | PP orchestrator               | Direct tools + cycle docs                      | Remediation, consolidation, and finalization        |

---

## Strict Execution Architecture (maps 1:1 to requested sequence)

1. **Global discovery and inventory**
   - Capture `git rev-parse HEAD`, `git branch -a -vv`, `git worktree list --porcelain`.
   - Enumerate `.cursor/plans/*.md`, `prompts/*.md`, `docs/status/*.md`, and parent transcripts.
2. **Deep audit and analysis**
   - Run parallel audits for inventory drift, md/plan consolidation, progression evidence, and verification.
3. **Cleanup and remediation**
   - Fix P0/P1 first (inventory drift, marker drift, closure evidence gaps).
4. **Build best follow-up prompt**
   - Generate/update a canonical master prompt from audit outputs.
5. **Progress-check update**
   - Record completed/remaining/blockers in queue + cycle docs.
6. **Perfect prompt**
   - Refine prompt with explicit constraints, approvals, evidence, and done criteria.
7. **Execute perfected prompt**
   - Apply prompt steps and validate after each meaningful action.
8. **Final audit + optimization**
   - Re-check touched files for correctness, consistency, and stale references.
9. **Completion operations**
   - Commit + push to remote branch with traceable message.
10. **Final closure pass**

- Append `CONSOLIDATION_LOG` + `PP_AUDIT_CYCLE` with commit/push evidence and residual risks.

---

## Consolidation Policy (active)

- **Canonical active docs**: `WORK_QUEUE`, `PP_AUDIT_MARKER`, `CONSOLIDATION_LOG`, `PP_AUDIT_CYCLE`, inventories, this plan, and `MASTER_ACTIVE_WORKFLOW_PROMPT.md`.
- **Historical docs**: dated reports/prompts retained for traceability unless safe deletion is proven.
- **Safe deletion rule**: delete only when there are no required inbound references or when references are updated in the same change.

---

## This Cycle's Consolidation Actions

- Created this canonical plan: `.cursor/plans/MASTER_ACTIVE_WORKFLOW.plan.md`.
- Created canonical master prompt: `prompts/MASTER_ACTIVE_WORKFLOW_PROMPT.md`.
- Advanced extension plan closure (`verify-install` and `verify` completed with evidence note).
- Candidate safe deletion executed in this cycle:
  - `.cursor/plans/30_guru_pp_passes_cohort_4.plan.md` (superseded cohort artifact).

---

## Verification Gate Set

- `npm run format:check`
- `npm run lint`
- `npm run test:unit`
- `pwsh -NoProfile -ExecutionPolicy Bypass -File "scripts/verify-pipeline.ps1" -SkipRunbook`

Credential-gated/store-affecting flows remain outside this plan unless explicitly approved and available.

---

## Exit Criteria

- Critical/high findings resolved or owned with next action.
- Inventories and marker align to live git state.
- Master plan + master prompt exist and are indexed.
- Verification gates pass or are documented with explicit blocker evidence.
- Commit + push completed and logged in cycle artifacts.
