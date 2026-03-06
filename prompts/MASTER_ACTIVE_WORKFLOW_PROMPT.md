# MASTER_ACTIVE_WORKFLOW_PROMPT

Use this prompt to run a complete guru /pp closure cycle with evidence-driven execution and deterministic verification.

---

## Primary Objective

Complete and close all unfinished, inconsistent, obsolete, or low-quality work across all accessible environments, branches, worktrees, plans, and agent-facing `.md` files; then produce, perfect, execute, and finalize the best follow-up plan/prompt with verifiable evidence.

---

## Strict Execution Sequence

1. **Global discovery and inventory**
   - Enumerate all accessible branches, worktrees, environments, plans, transcripts, and agent-related `.md` files.
   - Build a traceable inventory of tasks: done, in-progress, blocked, obsolete, duplicated, and missing.

2. **Deep audit and analysis**
   - Perform expert-level technical, operational, and documentation audits.
   - Identify defects, regressions, drift, duplication, stale artifacts, weak assumptions, and unfinished chains.
   - Rank findings by severity and impact.

3. **Cleanup and remediation**
   - Fix high-impact issues first, then medium/low.
   - Remove or archive obsolete files/work safely; update references so nothing breaks.
   - Consolidate duplicates into canonical sources.

4. **Build the best follow-up plan/prompt**
   - Generate a precise, execution-ready follow-up plan/prompt based on audit evidence.
   - Include goals, constraints, risks, checkpoints, verification steps, and clear done criteria.

5. **Progress check and update**
   - Run an in-depth progress check against the plan.
   - Publish a clarified progress update: completed, remaining, blockers, risks, and next actions.

6. **Perfect the follow-up prompt**
   - Refine the prompt using progress-check evidence so it is unambiguous, prioritized, and fully actionable.

7. **Execute the perfected prompt**
   - Execute end-to-end with recursive /pp discipline, validating after each meaningful step.

8. **Final audit + optimization pass**
   - Re-audit all touched code/files/tasks/work.
   - Refine, optimize, finalize, and perfect outputs for correctness, maintainability, and clarity.

9. **Completion operations**
   - Finish all required actions to fully complete the work.
   - Commit and push all necessary changes with clean, meaningful commit messages.
   - Ensure no required task remains partially done.

10. **Final closure pass**

- Run one last /pp finalization pass across all code, files, tasks, and completed work to confirm full closure.

---

## Custom Agent Team Requirement

Create and run a parallel team with at least these lanes:

- Inventory lane (branches/worktrees/state)
- MD+plan consolidation lane
- Conversation progression/evidence lane
- Independent verification lane
- Lead orchestrator lane

Merge lane outputs into one coherent remediation plan before editing files.

---

## Hard Constraints

- Do not fabricate access or results; explicitly mark inaccessible scope and required unblock steps.
- Preserve safety and policy rules (especially secrets handling and required approvals).
- Keep an evidence trail for every major decision/change.
- Prefer smallest safe fix first, then iterate.
- Ensure every deletion is justified and non-breaking.
- Do not execute store-affecting writes without required preview + approval.

---

## Required Deliverables

- Complete inventory report
- Prioritized audit findings
- Cleanup/remediation summary
- Perfected follow-up plan/prompt
- Progress-check update
- Verification/test summary
- Final completion report with commit hash(es), pushed branch(es), and residual risks

---

## Definition of Done

- All critical/high issues resolved or explicitly documented with owner + next action.
- Obsolete/duplicate artifacts cleaned up or intentionally retained with rationale.
- All required checks pass (or are documented with explicit justification).
- Repository/workstream is finalized, coherent, and ready for handoff/use.

---

## Closure Sync Requirement (mandatory)

Before exiting, update both:

- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/PP_AUDIT_CYCLE_20260227.md`

Each must include: approval state (if relevant), commit hash, pushed branch, residual blockers, and at least one parent transcript citation.
