# Plan: Expired / Legacy Content Cleanup

**Purpose**: Remove or consolidate expired plans, legacy guides, duplicate expert-analyses, and obsolete files so only current, single-source content remains. No unique content is deleted without being archived first.

**Approval**: Work in all environments; push as needed.

---

## 1. Problem

- **Root expert-analyses/**: Legacy numbered runs (01–10) duplicate the “expert” concept; current Phase 4/5 outputs live in docs/expert-analyses/. Two locations cause confusion; root is legacy and should not remain as a parallel tree.
- **Root scripts**: create-and-push.ps1, create-repo.ps1, sync-repository.ps1 are one-off/legacy; documented as “optional” but still at root. They should be moved to scripts/archive/ so root stays minimal.
- **Plans**: .cursor/plans/ has 4 files; expert-10 audit said “redundant or superseded plans can be pruned or documented.” No single index states which plans are current vs reference.
- **Guides**: quick-start and SHOPIFY_CURSOR_USAGE_GUIDE — ensure they are current (keybinding path already fixed). Add “Last updated” or remove expired steps if any.
- **replacements.txt**: At root; purpose (git-filter-repo regex for secret replacement) not documented in OPERATOR_RUNBOOK or CREDENTIALS_SETUP.
- **docs/status**: Many dated reports; some are superseded by PROJECT_PERFECTED / PROJECT_UPDATE_PERFECTION. Conservative consolidation: move only clearly superseded historical files to archive and update INDEX_REPORTS.

---

## 2. Actions (execute in order)

### 2.1 Consolidate expert-analyses (delete duplicate location)

- **Move** entire `expert-analyses/` (root) → `archive/2026-01-30/expert-analyses-legacy/` (all 11 files: 01–10 + README).
- **Delete** root `expert-analyses/` after move.
- **Update** INDEX_REPORTS: “Legacy expert runs (01–10) moved to archive/2026-01-30/expert-analyses-legacy/. Current expert outputs only in docs/expert-analyses/.”
- **Update** any doc that linked to root expert-analyses (e.g. expert-analyses/05\_...) to point to archive or docs/expert-analyses as appropriate.

### 2.2 Move root scripts to archive

- **Create** `scripts/archive/root-scripts-legacy/` if it does not exist.
- **Move** create-and-push.ps1, create-repo.ps1, sync-repository.ps1 from repo root to `scripts/archive/root-scripts-legacy/`.
- **Update** OPERATOR_RUNBOOK: “Legacy/optional scripts moved to scripts/archive/root-scripts-legacy/ (create-and-push, create-repo, sync-repository). Use scripts/shopify/, scripts/git/, etc. for current flows.”

### 2.3 Plans index and replacements.txt

- **Add** `.cursor/plans/README.md` (or `docs/status/PLANS_INDEX.md`): list each plan file with one line “Current” vs “Reference (implemented)” so agents know which to use. No plan files deleted.
- **Document** replacements.txt: add one line to OPERATOR_RUNBOOK or docs/CREDENTIALS_SETUP: “replacements.txt at repo root: regex for git-filter-repo (Shopify secret replacement); do not remove if you use history sanitization.” Optionally move to config/replacements-git-filter-repo.txt and update any script that references it (if any).

### 2.4 Guides

- **Verify** docs/guides/quick-start.md and SHOPIFY_CURSOR_USAGE_GUIDE (.md and .html) have no expired steps; keybinding path is already docs/KEYBINDING_PENDING_APPROVAL.md. Add “Last updated: 2026-01-30” at bottom of each if missing.

### 2.5 docs/status consolidation (conservative)

- **Move** to archive/2026-01-30/status-legacy/ only files that are clearly superseded and not referenced by HANDOFF or PLAN_HANDOFF: ao_guru_audit_findings_20260129.md, ao_guru_baseline_20260129.md, ao_guru_research_synthesis_20260129.md, verification_20260129.md, verification_proofs_20260129.md, IMPLEMENTATION_COMPLETE_20260129.md, proceed_20260130.md, proceed_p1_20260130.md. (Handoff still references system_finalization_report, blocker_resolution_commands, PLAN_HANDOFF, etc. — do not move those.)
- **Update** INDEX_REPORTS and ARCHIVE_NOTE to list the new archive locations.

### 2.6 Update INDEX_REPORTS and ARCHIVE_NOTE

- **INDEX_REPORTS**: Remove or redirect entries for moved files; add “archive/2026-01-30/expert-analyses-legacy/”, “archive/2026-01-30/status-legacy/”, “scripts/archive/root-scripts-legacy/”.
- **archive/2026-01-30/ARCHIVE_NOTE.md**: Add expert-analyses-legacy and status-legacy; note root scripts moved to scripts/archive/root-scripts-legacy/.

---

## 3. Out of scope (do not delete)

- Prompts: Do not delete; decision tree already directs. At most add “Deprecated: use X” where applicable.
- Workflows: Do not remove; document placeholders only.
- docs/status files still referenced by HANDOFF, PLAN_AGENT_ENTRY, or PLAN_HANDOFF (system_finalization_report, blocker_resolution_commands, IF_HANDOFF_FILES_MISSING, CONVERSATION_AUDIT, etc.).

---

## 4. Acceptance criteria

- Root has no expert-analyses/ folder; legacy runs in archive/2026-01-30/expert-analyses-legacy/.
- Root has no create-and-push.ps1, create-repo.ps1, sync-repository.ps1; they are in scripts/archive/root-scripts-legacy/.
- .cursor/plans has a README or docs/status has PLANS_INDEX stating current vs reference.
- replacements.txt documented in OPERATOR_RUNBOOK or CREDENTIALS_SETUP.
- INDEX_REPORTS and ARCHIVE_NOTE updated; no broken links in HANDOFF or PLAN_AGENT_ENTRY.
- Lint, format, unit tests pass; push to origin main.

---

**Plan file**: docs/status/PLAN_EXPIRED_LEGACY_CLEANUP_20260130.md
