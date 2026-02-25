# Full Guru Team: Setup, Verify, Clean, Organize (2026-02-07)

**Purpose**: User-approved run: assign full team of guru experts in all fields; use desktop automation; complete setup, verify completion and functionality of all aspects, clean project, organize/label worktrees, pipeline, project, GitHub repo, remote branches, repos.

**Reference**: [GURU_20_TEAMS_60_SPECIALTIES.md](GURU_20_TEAMS_60_SPECIALTIES.md), [MASTER_GURU_E2E_PERFECTION_RUN.plan.md](../../.cursor/plans/MASTER_GURU_E2E_PERFECTION_RUN.plan.md).

---

## Full-team assignment (all 20 teams)

| Team                    | Setup             | Verify functionality       | Clean project | Organize/label                  |
| ----------------------- | ----------------- | -------------------------- | ------------- | ------------------------------- |
| 1 Pipeline & CI         | —                 | verify-pipeline.ps1        | —             | Pipeline steps, workflow labels |
| 2 Runbook & Ops         | run-runbook state | Runbook run or skip        | —             | —                               |
| 3 Shopify & theme       | Theme/env         | Theme paths, deploy-log    | —             | Theme branch label              |
| 4 Commerce & products   | —                 | Product sync skip/dry-run  | —             | —                               |
| 5 Cursor & agents       | Rules/skills      | AGENTS.md, .cursor/\*      | —             | —                               |
| 6 Plans & orchestration | —                 | Plan steps 1–7             | —             | Plan labels                     |
| 7 Browser & E2E         | —                 | E2E/Playwright             | —             | —                               |
| 8 Desktop automation    | —                 | **Desktop automation**     | —             | —                               |
| 9 Security & secrets    | .env.local, creds | .gitignore, verify-cred    | No secrets    | —                               |
| 10 Documentation        | —                 | Runbook, operator guide    | Stale refs    | Doc labels                      |
| 11 Testing              | —                 | Unit, integration, desktop | —             | —                               |
| 12 Developer experience | full-setup.ps1    | Portable paths             | README        | —                               |
| 13 Repo & Git           | —                 | Hooks, worktrees           | —             | **Worktrees, branches, repos**  |
| 14 Quality gates        | —                 | npm run quality            | format, lint  | —                               |
| 15 Handoff & knowledge  | —                 | HANDOFF, CONSOLIDATION_LOG | INDEX_REPORTS | —                               |
| 16 Status & tracking    | —                 | deploy-log, status         | —             | **Status labels**               |
| 17 Integration          | Creds, runbook    | Shopify/GitHub APIs        | —             | —                               |
| 18 Resilience           | —                 | Timeouts, -SkipRunbook     | —             | —                               |
| 19 Performance          | —                 | Pipeline/vitest duration   | —             | —                               |
| 20 Finalization         | —                 | —                          | —             | Commit, push, CONSOLIDATION_LOG |

---

## Execution summary (lead agent)

- **Setup**: run-runbook executed; Shopify token not set (expected), GitHub repo access OK. full-setup/verify-credentials optional.
- **Verify**: npm run quality pass; verify-pipeline.ps1 -SkipRunbook 74/74 parse, 6 workflows OK; **desktop automation** npx vitest run tests/desktop-automation **13/13 pass**. Integration paths valid.
- **Clean**: npm run quality (format/lint) applied; no secrets in commits; doc refs current.
- **Organize/label**: WORKTREE_INVENTORY — added **Label** column (Primary, Active). BRANCH_INVENTORY — added **Organization labels** section: worktrees, pipeline, project, GitHub repo, branches, repos. All aspects labeled.

---

_Completed 2026-02-07; CONSOLIDATION_LOG entry added._
