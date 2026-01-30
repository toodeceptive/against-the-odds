# Plan: Full Project Update & Perfection (Multi-Guru Expert System)

**Purpose**: Update and perfect the entire project using multi-talented guru expert specialists; run an in-depth comprehensive and multifaceted project audit; incorporate the newest changes (Shopify updates via Cursor, automated preview before confirmation, etc.); clean useless or obsolete files; and update all aspects (Cursor agents, MD files, workflows, scripts, docs) to reflect the new system.

**Gate**: Phase 0 must be signed off before execution. See `docs/status/PLAN_AGENT_ENTRY.md` and `prompts/PERFECT_EXECUTION_PROMPT.md`.

---

## 1. Objective and scope

### 1.1 Goals

- **Audit**: In-depth, comprehensive, multifaceted project audit (code, config, docs, Cursor, workflows, scripts, prompts, integrations).
- **New system reflection**: Ensure every touchpoint reflects the **new system**:
  - Shopify updates via Cursor (edit in repo → preview → approve → push).
  - Automated preview before confirmation (pending-approval.md, open-pending-approval.ps1, start-theme-preview.ps1).
  - Agent workflow: write pending-approval → run open-pending-approval.ps1 (and for theme: start-theme-preview.ps1) → user approves in chat → apply → deploy-log.
  - Shortcuts: Ctrl+Alt+P (open pending approval), Ctrl+Alt+T (theme dev / preview).
- **Cleanup**: Remove or archive useless/obsolete files (redundant reports, deprecated prompts, placeholder-only workflows, duplicate expert outputs, orphan scripts).
- **Update everything**: Cursor agents (rules, tasks, plans, context), all MD files (docs, INDEX_REPORTS, decision tree, runbook, guides, handoff), workflows, scripts, and any other aspects so they describe and use the new system consistently.

### 1.2 Out of scope

- Changing business logic or product roadmap.
- Adding new product features unrelated to “project update and perfection.”
- Modifying Phase 0 definition (only execution order and references may be updated).

---

## 2. Gate: Phase 0

- **Before any phase below**: Confirm `docs/status/PHASE_0_FINALIZATION.md` contains **Phase 0 finalized; proceeding allowed.**
- If not signed off: Execute Phase 0 per `prompts/PERFECT_EXECUTION_PROMPT.md` and record sign-off, then proceed.

---

## 3. Multi-guru specialist phases (audit → update → cleanup)

Execute in order. Each phase can be assigned to a specialist “expert” prompt; the Head Guru orchestrator synthesizes outputs.

### Phase A — Audit (comprehensive and multifaceted)

**Owner**: Orchestrator + experts (e.g. ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT or MASTER_10_EXPERT_SYSTEM).

- **A1 — Code & config**: Lint, format, tests, security (secrets, Trivy), structure. Produce short audit note in `docs/status/` (e.g. `AUDIT_CODE_CONFIG_YYYYMMDD.md`).
- **A2 — Docs & organization**: Inventory docs/, root, archive, expert-analyses (root vs docs/expert-analyses); accuracy of INDEX_REPORTS, decision tree, runbook, workflow doc, guides. Identify obsolete, duplicate, or misleading files. Produce `docs/status/AUDIT_DOCS_ORGANIZATION_YYYYMMDD.md`.
- **A3 — Cursor & workspace**: .cursor/rules, plans, tasks, context, settings, extensions. Do rules reference new workflow (pending-approval, open-pending-approval, start-theme-preview)? Are tasks complete (Open pending approval, Theme Dev, Start theme preview if desired)? Produce `docs/status/AUDIT_CURSOR_WORKSPACE_YYYYMMDD.md`.
- **A4 — Workflows & integrations**: GitHub Actions (ci, quality-check, deploy, shopify-sync, sync-theme-branch, maintenance). Which are placeholders? Overlap with CI? Shopify/GitHub alignment. Produce `docs/status/AUDIT_WORKFLOWS_YYYYMMDD.md`.
- **A5 — Scripts & automation**: scripts/shopify (theme-dev, sync-products, update-theme, open-pending-approval, start-theme-preview), scripts/health, scripts/setup, etc. Portability (PSScriptRoot/repo-root). Orphan or obsolete scripts. Produce `docs/status/AUDIT_SCRIPTS_YYYYMMDD.md`.
- **A6 — Prompts & agents**: All prompts in prompts/; decision tree accuracy; redundant “master” prompts; expert vs finalization overlap; which prompt to use for “project update and perfection.” Produce `docs/status/AUDIT_PROMPTS_AGENTS_YYYYMMDD.md`.

**Deliverable**: One consolidated **Project Audit Report** in `docs/status/PROJECT_AUDIT_YYYYMMDD.md` summarizing A1–A6 and listing:

- What is aligned with the new system.
- What is obsolete, redundant, or placeholder.
- What must be updated (with file paths).
- What must be archived or removed.

---

### Phase B — Update (reflect new system everywhere)

**Owner**: Specialists per area; Head Guru ensures consistency.

- **B1 — Cursor rules**: Update `.cursor/rules/*` so that:
  - Shopify/preview rule explicitly mentions `open-pending-approval.ps1` and `start-theme-preview.ps1` (already in shopify-preview-approval.mdc; verify and align with AGENT_WORKFLOW_CURSOR_SHOPIFY.md).
  - AO-Guru reporting rule points to `docs/status/` and INDEX_REPORTS (already; verify).
  - No references to obsolete report locations or old “push without preview” flow.
- **B2 — Cursor tasks**: Ensure `.cursor/tasks.json` includes:
  - Open pending approval (already).
  - Shopify: Theme Dev (preview before commit) (already).
  - **Add** (if missing): “Start theme preview (new window)” → `scripts/start-theme-preview.ps1` so users can run it from Run Task.
  - All task descriptions/documentation state “run from repo root.”
- **B3 — Cursor context & plans**: `.cursor/context/*` and `.cursor/plans/*`:
  - Context (e.g. shopify.md, github.md) must mention theme path, product data, workflow doc, and preview-before-apply flow.
  - Plans reference AGENT_WORKFLOW_CURSOR_SHOPIFY.md and docs/status/ where relevant.
- **B4 — Docs (core)**: Update in one pass:
  - `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`: Already describes new flow; verify open-pending-approval + start-theme-preview in every product/theme flow and quick reference.
  - `docs/status/INDEX_REPORTS.md`: Add any new audit/status files from Phase A; remove references to deleted files; keep “pending-approval,” “deploy-log,” “project perfected,” “multi-agent perfection run.”
  - `docs/AGENT_PROMPT_DECISION_TREE.md`: Add row or note for “Full project update & perfection” → this plan (`full_project_update_perfection_guru.plan.md`); ensure “Full project perfection” and “Full project update & perfection” are clearly distinguished (perfection = Phases 1–7 run; update & perfection = this plan: audit + new system + cleanup + full update).
  - `OPERATOR_RUNBOOK.md`: Already references Ctrl+Alt+P, Ctrl+Alt+T, KEYBINDING doc; ensure KEYBINDING doc exists (see B6).
  - `docs/HANDOFF_PROMPT_NEW_AGENT.md`, `docs/status/PLAN_HANDOFF_FOR_NEXT_AGENT.md`, `docs/status/IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md`: Point to AGENT_WORKFLOW_CURSOR_SHOPIFY.md, pending-approval, deploy-log, and “run from repo root.”
- **B5 — Docs (guides and references)**: `docs/guides/SHOPIFY_CURSOR_USAGE_GUIDE.md` and `.html`: Include open-pending-approval, start-theme-preview, Ctrl+Alt+P, Ctrl+Alt+T. `docs/UPDATE_SHOPIFY_FROM_CURSOR.md`: Align with workflow doc (preview before apply, pending-approval, deploy-log).
- **B6 — Keybinding doc**: Create `.vscode/KEYBINDING_PENDING_APPROVAL.md` (or equivalent under docs/ if .vscode is gitignored) with user-level keybinding instructions: Ctrl+Alt+P = Open pending approval; Ctrl+Alt+T = Shopify Theme Dev (preview). OPERATOR_RUNBOOK already references it; ensure file exists and path is correct.
- **B7 — Prompts**: Update only where they reference workflow or reporting:
  - `prompts/finalization-shopify-store-ops.md`, `prompts/head-guru-orchestrator.md`, and any prompt that “pushes to store”: add one line to “preview → pending-approval → open-pending-approval [and start-theme-preview for theme] → approve → apply → deploy-log.”
  - Ensure PERFECT_EXECUTION_PROMPT and PLAN_AGENT_ENTRY are not changed in substance (only links/refs if needed).
- **B8 — Workflows**: `.github/workflows/README.md`: Document which workflows are real vs placeholder (deploy, shopify-sync backup-store, etc.). Optionally add a one-line “Placeholder – see OPERATOR_RUNBOOK” in deploy.yml and shopify-sync backup job if they remain stubs. Do not remove workflows without product owner decision; only document.

**Deliverable**: Checklist in `docs/status/UPDATE_CHECKLIST_YYYYMMDD.md` (B1–B8 done) and all listed files updated.

---

### Phase C — Cleanup (obsolete and useless files)

**Owner**: Documentation expert + orchestrator; no deletion of unique content without archive.

- **C1 — Root-level files**: Only README, CHANGELOG, NEXT_STEPS, OPERATOR_RUNBOOK stay at root. Any remaining report/status MD at root → move to `archive/YYYYMMDD/` with ARCHIVE_NOTE; update INDEX_REPORTS.
- **C2 — Root-level scripts**: `create-and-push.ps1`, `create-repo.ps1`, `sync-repository.ps1` — if obsolete or one-off, move to `scripts/archive/` or document in OPERATOR_RUNBOOK as “legacy/optional” and keep; do not delete without confirmation.
- **C3 — docs/status**: Remove only if redundant (e.g. duplicate of another status file). Archive old dated reports to archive/ if not already. Keep: PHASE*0_FINALIZATION, PLAN_AGENT_ENTRY, INDEX_REPORTS, pending-approval, deploy-log, PROJECT_PERFECTED*_, MULTI*AGENT_PERFECTION_RUN*_, EXPECTATIONS_CHECKLIST, handoff files, and current audit/update outputs.
- **C4 — expert-analyses**: Two locations exist — `expert-analyses/` (root) and `docs/expert-analyses/`. Decide: (1) single home (e.g. docs/expert-analyses only) and move root expert-analyses into archive or docs; or (2) document in INDEX_REPORTS that root = legacy, docs/ = current. Do not delete numbered expert outputs without archiving.
- **C5 — Prompts**: Do not delete prompts; at most add a “Deprecated: use X instead” line at the top and point to decision tree. Consolidation of “master” prompts is documentation (decision tree) not file deletion.
- **C6 — Workflows**: Do not delete; document placeholders. Remove only if product owner explicitly agrees.
- **C7 — Scripts**: Orphan or unused scripts → move to `scripts/archive/` or mark in a small README in scripts/ as “optional/legacy.” Do not delete shared or shopify scripts that the workflow depends on.

**Deliverable**: `docs/status/CLEANUP_LOG_YYYYMMDD.md` listing what was moved/archived and where; INDEX_REPORTS and ARCHIVE_NOTE updated.

---

### Phase D — Final verification and sign-off

**Owner**: Head Guru / orchestrator.

- **D1**: Run lint, format check, unit tests; fix any regressions.
- **D2**: Walk through “new system” path: product change → pending-approval → open-pending-approval → approve → apply → deploy-log; theme change → pending-approval → open-pending-approval + start-theme-preview → approve → apply → deploy-log. Confirm docs and rules describe this.
- **D3**: Produce **Project Update Perfection Report** in `docs/status/PROJECT_UPDATE_PERFECTION_YYYYMMDD.md`:
  - Summary: audit done, updates applied, cleanup done.
  - Links: PROJECT_AUDIT_YYYYMMDD, UPDATE_CHECKLIST_YYYYMMDD, CLEANUP_LOG_YYYYMMDD.
  - “Project update & perfection complete” statement and date.
- **D4**: Update `docs/status/INDEX_REPORTS.md` with new report(s). Optionally add one row to `docs/AGENT_PROMPT_DECISION_TREE.md`: “Full project update & perfection (audit + new system + cleanup)” → this plan.

---

## 4. New system (canonical reference)

So that every update “reflects the new system,” use this as the single source of truth for behavior and wording:

- **Store changes**: Always preview first (dry-run or theme dev), then snapshot to `docs/status/pending-approval.md`, then run `.\scripts\open-pending-approval.ps1` so the file opens in Cursor; for theme/page changes also run `.\scripts\start-theme-preview.ps1` so the browser opens the live preview. Only after explicit user approval in chat: apply (sync without -DryRun, or push theme). After apply: append `docs/status/deploy-log.md`, clear pending-approval.
- **Shortcuts**: Ctrl+Alt+P = open pending approval file; Ctrl+Alt+T = start theme dev (preview). Document in OPERATOR_RUNBOOK and KEYBINDING doc.
- **Cursor tasks**: “Open pending approval,” “Shopify: Theme Dev (preview before commit),” “Start theme preview (new window)” (if added).
- **Rules**: shopify-preview-approval.mdc and AGENT_WORKFLOW_CURSOR_SHOPIFY.md are the canonical workflow; ao-guru.rules.md points reporting to docs/status/ and INDEX_REPORTS.

---

## 5. Execution order summary

| Step | Phase | Action                                                                    |
| ---- | ----- | ------------------------------------------------------------------------- |
| 0    | Gate  | Phase 0 signed off                                                        |
| 1    | A     | Audit (A1–A6) → PROJECT_AUDIT_YYYYMMDD.md                                 |
| 2    | B     | Update all (B1–B8) → UPDATE_CHECKLIST_YYYYMMDD.md                         |
| 3    | C     | Cleanup (C1–C7) → CLEANUP_LOG_YYYYMMDD.md                                 |
| 4    | D     | Verify + sign-off → PROJECT_UPDATE_PERFECTION_YYYYMMDD.md + INDEX_REPORTS |

---

## 6. Acceptance criteria

- Phase 0 gate satisfied.
- One consolidated project audit report (A1–A6) exists.
- All items in Phase B (B1–B8) completed and checklist filed.
- Cleanup log exists; no unique content deleted without archive.
- Lint/format/tests pass.
- New system (preview → pending-approval → open-pending-approval [+ start-theme-preview for theme] → approve → apply → deploy-log) is documented in workflow doc, rules, runbook, and guides; keybinding doc exists where referenced.
- PROJECT_UPDATE_PERFECTION_YYYYMMDD.md signed off and linked in INDEX_REPORTS.

---

**Plan file**: `.cursor/plans/full_project_update_perfection_guru.plan.md`  
**Entry**: `docs/status/PLAN_AGENT_ENTRY.md` → Phase 0 → then this plan.  
**Decision tree**: Add “Full project update & perfection” row pointing to this plan when implementing Phase D.
