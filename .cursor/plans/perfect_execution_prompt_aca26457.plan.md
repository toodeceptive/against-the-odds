# Plan: PERFECT_EXECUTION_PROMPT (aca26457)

## Goal

Create/maintain `prompts/PERFECT_EXECUTION_PROMPT.md` so it **mandates Phase 0** (full cleanup + finalization) across **all files and sources** before any other execution phase is allowed to proceed.

## Non-negotiable requirements

The resulting `prompts/PERFECT_EXECUTION_PROMPT.md` MUST explicitly include:

- **Phase 0 (mandatory first)**: full cleanup/finalization of WIP, unfinished work, mixed/loose files, Cursor/IDE problems (e.g. 620+), all branches, all local directories, website/server data, Shopify/Cloudflare profile/info, and all other relevant sources.
- **All files and sources** in scope (not limited to currently open files):
  - All branches (local + remote): strategy, merge state, cleanup
  - All local directories/files: structure, naming, consolidation, cleanup
  - Website/server data relevant to the project
  - Shopify/Cloudflare profile/info (store/API/theme; zone/DNS/SSL) as documented or accessible
  - WIP/unfinished work/loose ends: TODOs/FIXMEs/half-done items completed/removed or documented+tracked
  - Cursor/IDE problems: each resolved OR deferred with documented reason; **zero unresolved at sign‑off unless documented**
  - Tasks/processes/issues: reviewed and optimized; workflow comprehensive, clean, functional, readable, clearly defined
- **Phase 0 completion checklist** (as a checklist) and a hard gate:
  - "Proceeding" is prohibited until Phase 0 checklist is satisfied and sign-off is recorded.
  - The sign-off line must be recorded exactly as: **"Phase 0 finalized; proceeding allowed."**
- **Main completion checklist** that includes Phase 0 completion/sign‑off as the first item (remaining items unchanged from the broader program: lint/format/tests/runbook/finalization).

## Acceptance criteria

- `prompts/PERFECT_EXECUTION_PROMPT.md` contains a clear Phase 0 section that is unmissable and unambiguous.
- Phase 0 scope includes **Cursor problems (e.g. 620+)**, all branches, all local dirs, website/server data, Shopify/Cloudflare profile/info, WIP/loose ends, tasks/processes/issues.
- Phase 0 gate is explicit: no "planning execution / expert cycles / new feature work" until Phase 0 sign-off.
- The prompt instructs where/how to record the sign‑off (file path + required statement).

## Phase 0 completion checklist (must appear in the prompt)

- [ ] All branches reviewed; merge state and cleanup done.
- [ ] All local directories and files reviewed; mixed/loose files consolidated or cleaned; structure and naming clear.
- [ ] All Cursor/IDE problems categorized; each resolved or deferred with reason; zero unresolved at sign‑off unless documented.
- [ ] All WIP and unfinished work completed, removed, or documented and tracked.
- [ ] All tasks/processes/issues reviewed and optimized; workflow comprehensive, clean, functional, readable; data/information and organization defined.
- [ ] Website/server data and Shopify/Cloudflare profile/info reviewed and documented where relevant (or deferred with reason + next steps if access is blocked).
- [ ] Phase 0 sign‑off recorded: “Phase 0 finalized; proceeding allowed.”

## Implementation notes

- Prefer plain Markdown headings and checklists.
- Use bold emphasis for the gating rule and the required sign‑off statement.
- If external sources are credential-gated (Shopify/Cloudflare/server), require documentation of:
  - what was checked
  - what could not be accessed
  - why (missing creds / access limitation)
  - exact next steps to complete when access is available
