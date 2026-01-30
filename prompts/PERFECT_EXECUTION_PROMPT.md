# PERFECT_EXECUTION_PROMPT — Phase 0 Mandatory (Full Cleanup + Finalization)

**Target repo**: `C:\Users\LegiT\against-the-odds`  
**Operating environment**: Windows + PowerShell primary (Cursor IDE)  
**Rule**: **No work beyond Phase 0 is allowed until Phase 0 is finalized and sign‑off is recorded.**

---

## Phase 0 (MANDATORY FIRST): Full cleanup and finalization before proceeding

### Goal

Perform a complete, end-to-end cleanup and finalization of **all WIP**, **unfinished work**, **mixed/loose files**, **Cursor/IDE problems (e.g. 620+)**, **all branches**, **all local directories**, and all other relevant sources so the workflow is **comprehensive, clean, functional, flawless, readable, clear, and defined**.

### Scope: all files and sources (everything relevant is in-scope)

This is not limited to currently open files. It includes:

- **All branches (local + remote)**: every Git branch; strategy; merge state; cleanup; stale branch handling
- **Local directories/files**: every project directory; structure, naming, consolidation, cleanup; remove/merge duplicates; relabel where needed
- **Website/server data**: any hosted site or server data relevant to the project (content/config/state)
- **Shopify profile/info**: store/API/theme/app configuration as documented or accessible
- **Cloudflare profile/info**: zone/DNS/SSL/security settings as documented or accessible
- **WIP, unfinished work, loose ends**: half-done work, TODO/FIXME markers, dangling scripts, unreferenced assets, incomplete docs
- **Cursor/IDE problems (e.g. 620+)**: all IDE problems categorized; each resolved or deferred with reason; no unresolved at sign-off unless explicitly documented
- **Tasks, processes, issues**: progress tracking, optimization, triage; workflow cleaned and defined; processes readable and unambiguous

### Required actions (Phase 0)

Do all of the following before any other phase:

- **Branches**: review all local and remote branches; identify merge state; consolidate; delete/quarantine stale branches per strategy; document branch decisions.
- **Local structure**: review the entire repository tree; consolidate mixed/loose files; normalize structure and naming; ensure docs/prompts/scripts live where expected; remove redundancy (or archive with rationale).
- **WIP closure**: locate and resolve/finish/remove all WIP and unfinished items; if something must remain open, it must be explicitly documented and tracked (with owner, next step, and reason).
- **Cursor/IDE problems**: triage all problems (e.g. 620+):
  - categorize (lint, type, config, tooling, missing deps, test failures, broken scripts, etc.)
  - resolve each problem OR explicitly defer with a reason and a concrete plan
  - reach **zero unresolved** problems at sign-off unless documented as deferred with reason
- **Tasks/processes/issues**: review and optimize the task system and operating workflow; consolidate duplicated guidance; ensure the “how we work” is clear, comprehensive, and readable.
- **Website/server + Shopify + Cloudflare**: review what is accessible; document current state and any required updates; if credential-gated or inaccessible, document the limitation and exact next steps to complete review when access is available.

### Phase 0 completion checklist (must be satisfied before proceeding)

- [ ] **All branches reviewed**; merge state and cleanup done
- [ ] **All local directories and files reviewed**; mixed/loose files consolidated or cleaned; structure and naming clear
- [ ] **All Cursor/IDE problems categorized**; each resolved or deferred with reason; **zero unresolved at sign-off unless documented**
- [ ] **All WIP and unfinished work completed, removed, or documented and tracked**
- [ ] **All tasks/processes/issues reviewed and optimized**; workflow comprehensive, clean, functional, readable; data/information and organization defined
- [ ] **Website/server data and Shopify/Cloudflare profile/info reviewed and documented** where relevant (or deferred with reason + next steps if access is blocked)
- [ ] **Phase 0 sign-off recorded** with the exact statement below

### Phase 0 sign‑off gate (hard stop)

Proceeding to any other phase (planning execution, expert cycles, feature work, refactors, optimizations beyond cleanup) is **not allowed** until:

1. The Phase 0 completion checklist above is fully satisfied, and
2. A sign-off file is written/updated at: `docs/status/PHASE_0_FINALIZATION.md`
3. That file contains this exact line (verbatim):

**Phase 0 finalized; proceeding allowed.**

Include a timestamp and a brief summary of what was cleaned/finalized alongside the required line.

---

## Main completion checklist (overall program)

- [ ] **Phase 0 completed and sign‑off recorded** (“Phase 0 finalized; proceeding allowed.”)
- [ ] Remaining items unchanged (plan todos, deliverables, lint, format, tests, runbook, finalization)
