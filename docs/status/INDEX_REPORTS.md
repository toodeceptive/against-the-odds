# Reports and Status Files — Index

**Purpose**: Single index of report- and status-style markdown files so agents and humans know what is current vs legacy and where to look.

---

## Keep at repo root (canonical)

| File                  | Purpose                                             |
| --------------------- | --------------------------------------------------- |
| `README.md`           | Project overview and entry point                    |
| `CHANGELOG.md`        | Version history                                     |
| `NEXT_STEPS.md`       | Immediate next steps and first tasks                |
| `OPERATOR_RUNBOOK.md` | Daily checks, Shopify, credentials, troubleshooting |

---

## Root-level report/status files (legacy or one-off)

These live at repo root or were moved to `archive/2026-01-30/` (see below). For current status use `docs/status/`.

### Moved to archive/2026-01-30

**P1 batch**: COMPLETION\*REPORT, FIXES*COMPLETE, FIXED_STATUS, IMPLEMENTATION\**, PHASE\*1\*\_, FINAL_VERIFICATION, PROJECT_STATUS\*, REPOSITORY_STATUS, REVIEW_SUMMARY, SUB_ISSUES.

**Phase 4 batch (2026-01-30)**: AUDIT\*REPORT, BUG_FIXES, CODE_REVIEW_SYNC, DESKTOP_AUTOMATION_IMPLEMENTATION, FINAL_IMPLEMENTATION\*\*, INSTALL_INSTRUCTIONS, MASTER_EXECUTION_REPORT, QUICK_START, SETUP_INSTRUCTIONS, SETUP_VERIFICATION, SYSTEM_READY, ULTIMATE_MASTER_AGENT_EXECUTION_REPORT.

See `archive/2026-01-30/ARCHIVE_NOTE.md`.

**Convention**: Only README, CHANGELOG, NEXT_STEPS, OPERATOR_RUNBOOK stay at root; all other legacy reports in `archive/` or `docs/status/`.

---

## docs/status/ (current and recent)

Use these for current phase, finalization, audits, and handoff.

| File                                                                   | Purpose                                                                                               |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `PHASE_0_FINALIZATION.md`                                              | Phase 0 checklist and sign-off ("Phase 0 finalized; proceeding allowed.")                             |
| `PLAN_AGENT_ENTRY.md`                                                  | Agent entry plan — read first, then execute Phase 0                                                   |
| `GURU_MULTI_AGENT_AUDIT_REPORT_20260130.md`                            | Multi-agent guru audit (workflows, prompts, redundancies, P1/P2)                                      |
| `PIPELINE_FINALIZED.md`                                                | Pipeline finalized sign-off (seven-expert sequence; entry for future agents)                          |
| `system_finalization_report_20260129.md`                               | System finalization inventory and blockers                                                            |
| `deploy-log.md`                                                        | Deploy and rollback log (append-only)                                                                 |
| `pending-approval.md`                                                  | Pending Shopify/store changes (preview before apply)                                                  |
| `proceed_20260130.md`                                                  | Proceed execution summary and next step (Shopify creds)                                               |
| `blocker_resolution_commands_20260129.md`                              | Blocker resolution commands                                                                           |
| `verification_20260129.md`, `verification_proofs_20260129.md`          | Verification evidence                                                                                 |
| `IMPLEMENTATION_COMPLETE_20260129.md`                                  | Implementation complete marker                                                                        |
| `WORKFLOW_OPS_AUDIT_REPORT.md`                                         | Workflow ops audit                                                                                    |
| `ao_guru_*_20260129.md`                                                | AO guru baseline/audit/synthesis                                                                      |
| `expert_05_documentation_audit_20260130.md` (in docs/expert-analyses/) | Phase 4 documentation audit (expert-05)                                                               |
| `CURSOR_WORKSPACE_AUDIT_20260130.md`                                   | Phase 5 Cursor and workspace audit (.cursor/\*, tasks, plans, scope)                                  |
| `EXPECTATIONS_CHECKLIST.md`                                            | Phase 6 needs/expectations and workflow/runbook/handoff verification                                  |
| `MASTER_SYNTHESIS_REPORT_20260130.md`                                  | Phase 7 Head Guru synthesis (Phases 1–6)                                                              |
| `PROJECT_PERFECTED_20260130.md`                                        | Project perfected sign-off (Full Project Guru Perfection Plan)                                        |
| **Plan: Full project update & perfection**                             | `.cursor/plans/full_project_update_perfection_guru.plan.md` — audit, new system, cleanup, update all. |
| `PROJECT_AUDIT_20260130.md`, `AUDIT_*_20260130.md` (A1–A6)             | Phase A audit (code, docs, Cursor, workflows, scripts, prompts)                                       |
| `UPDATE_CHECKLIST_20260130.md`, `CLEANUP_LOG_20260130.md`               | Phase B update checklist; Phase C cleanup log                                                         |
| `PROJECT_UPDATE_PERFECTION_20260130.md`                                | Project update & perfection sign-off (Full plan executed)                                             |
| `docs/KEYBINDING_PENDING_APPROVAL.md`                                  | User keybinding instructions (Ctrl+Alt+P, Ctrl+Alt+T)                                                 |
| Other dated/theme reports                                              | Audits, coverage, security, optimization, etc.                                                        |

---

## expert-analyses/ (past expert runs)

- **Root** `expert-analyses/`: Legacy numbered runs (01–10) + README; keep for reference.
- **docs/expert-analyses/**: Current Phase 4/5 outputs — `expert_05_documentation_audit_20260130.md`, `expert_10_dev_experience_audit_20260130.md`. Example outputs of expert prompts; not duplicated here.

---

## Quick reference

| Need                       | Where                                                   |
| -------------------------- | ------------------------------------------------------- |
| Current phase and sign-off | `docs/status/PHASE_0_FINALIZATION.md`                   |
| Agent entry and plan       | `docs/status/PLAN_AGENT_ENTRY.md`                       |
| Latest guru audit          | `docs/status/GURU_MULTI_AGENT_AUDIT_REPORT_20260130.md` |
| Project perfected sign-off | `docs/status/PROJECT_PERFECTED_20260130.md`             |
| Project update & perfection sign-off | `docs/status/PROJECT_UPDATE_PERFECTION_20260130.md` |
| Deploy/rollback log        | `docs/status/deploy-log.md`                             |
| Next steps                 | `NEXT_STEPS.md`, `OPERATOR_RUNBOOK.md`                  |
| This index                 | `docs/status/INDEX_REPORTS.md`                          |
