# Plans index (repo)

**Canonical plan**: `FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` (open in Cursor and use Build). Phase 0 and Tracks A–G are completed; run **incremental fix list** only per plan.

**Run as needed (user-approved)**:

- **Perfection loop / E2E**: `MASTER_GURU_E2E_PERFECTION_RUN.plan.md` — 7-step execution; loop until complete; run with `prompts/MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT.md`.
- **Guru full-system (Phases 0–4 completed)**: `guru_full-system_setup_and_automation.plan.md` — reference for pipeline, credentials, audit, operator guide; re-run specific phases only if scope agreed.
- **Repo organization**: `FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` — incremental fixes only; no re-run of Phase 0 or tracks.

## Notes on prior plan references

Older audits and status docs may reference plan files that **no longer exist** (they were consolidated and removed), such as:

- `cursor-github-shopify-pipeline.plan.md`
- `expert_team_security_and_platform_plan_*.plan.md`
- `full_project_update_perfection_guru.plan.md`

If you see those references, treat them as **implemented or consolidated**. The current authoritative plan content is in `FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md`, and the current operational workflows are documented in:

- `docs/status/PLAN_AGENT_ENTRY.md`
- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/INDEX_REPORTS.md`
- `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`
