# Project Audit Report — 2026-01-30

**Plan**: Full Project Update & Perfection (Phase A).  
**Summary**: A1–A6 audits completed; consolidated findings below.

---

## Aligned with new system

- **Cursor rules**: shopify-preview-approval.mdc (pending-approval, open-pending-approval.ps1, start-theme-preview.ps1); ao-guru → docs/status/, INDEX_REPORTS.
- **Workflow doc**: AGENT_WORKFLOW_CURSOR_SHOPIFY.md describes preview → pending-approval → open-pending-approval [+ start-theme-preview for theme] → approve → apply → deploy-log.
- **Tasks**: Open pending approval; Shopify: Theme Dev (preview before commit). Workflows README documents placeholders (deploy, shopify-sync backup-store).
- **Code**: ESLint pass; unit tests pass. Root: README, CHANGELOG, NEXT_STEPS, OPERATOR_RUNBOOK only for canonical; archive/2026-01-30 holds legacy reports.

---

## Obsolete, redundant, or placeholder

- **Prettier**: 4 files need format (plan, decision tree, INDEX_REPORTS, MULTI_AGENT_PERFECTION_RUN) — fix in Phase D.
- **Placeholder workflows**: deploy.yml (echo only); shopify-sync backup-store job. Document only; do not remove (B8).
- **KEYBINDING doc**: Referenced in OPERATOR_RUNBOOK but file missing — create in B6.
- **expert-analyses**: Two locations (root vs docs/expert-analyses). Document in INDEX_REPORTS: root = legacy; docs/ = current (C4).

---

## Must be updated (file paths)

| Item             | File(s)                                                                                                                                       | Action                                                                                                                                    |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Add task         | `.cursor/tasks.json`                                                                                                                          | Add "Start theme preview (new window)" → scripts/start-theme-preview.ps1 (B2).                                                            |
| Keybinding doc   | Create `.vscode/KEYBINDING_PENDING_APPROVAL.md` or `docs/KEYBINDING_PENDING_APPROVAL.md`                                                      | User keybinding instructions Ctrl+Alt+P, Ctrl+Alt+T (B6).                                                                                 |
| Context          | `.cursor/context/shopify.md`                                                                                                                  | Add line: preview-before-apply, open-pending-approval, start-theme-preview (B3).                                                          |
| Handoff          | `docs/HANDOFF_PROMPT_NEW_AGENT.md`, `docs/status/PLAN_HANDOFF_FOR_NEXT_AGENT.md`, `docs/status/IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md` | Point to AGENT_WORKFLOW_CURSOR_SHOPIFY, pending-approval, deploy-log, run from repo root (B4).                                            |
| Prompts          | `prompts/finalization-shopify-store-ops.md`, `prompts/head-guru-orchestrator.md`                                                              | Add one line: preview → pending-approval → open-pending-approval [and start-theme-preview for theme] → approve → apply → deploy-log (B7). |
| INDEX_REPORTS    | `docs/status/INDEX_REPORTS.md`                                                                                                                | Add Phase A audit files; expert-analyses note (B4, C4).                                                                                   |
| Workflows README | `.github/workflows/README.md`                                                                                                                 | Already documents placeholders; verify current (B8).                                                                                      |

---

## Archive / remove (Phase C)

- **Root scripts**: create-and-push.ps1, create-repo.ps1, sync-repository.ps1 — document as legacy in OPERATOR_RUNBOOK or move to scripts/archive/ (C2). Do not delete without confirmation.
- **replacements.txt** at root — assess; archive if obsolete (C1).
- **expert-analyses**: No deletion; document root = legacy, docs/ = current in INDEX_REPORTS (C4).
- **Prompts**: No deletion; decision tree already directs (C5).

---

## Per-phase audit files

- A1: `docs/status/AUDIT_CODE_CONFIG_20260130.md`
- A2: `docs/status/AUDIT_DOCS_ORGANIZATION_20260130.md`
- A3: `docs/status/AUDIT_CURSOR_WORKSPACE_20260130.md`
- A4: `docs/status/AUDIT_WORKFLOWS_20260130.md`
- A5: `docs/status/AUDIT_SCRIPTS_20260130.md`
- A6: `docs/status/AUDIT_PROMPTS_AGENTS_20260130.md`

---

**Phase A complete.** Proceed to Phase B (Update).
