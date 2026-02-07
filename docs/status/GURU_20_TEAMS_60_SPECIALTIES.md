# Guru 20 Teams × 60 Specialties — Multi-Perspective Perfection Loop

**Purpose**: Fresh perspectives for the Master Guru E2E perfection loop. When continuing the loop, lead agent can assign or simulate review from these 20 expert teams across 60 specialties to ensure broad coverage and avoid blind spots.

**Reference**: [MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT.md](../../prompts/MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT.md), [MASTER_GURU_E2E_PERFECTION_RUN.plan.md](../../.cursor/plans/MASTER_GURU_E2E_PERFECTION_RUN.plan.md).

---

## 20 guru expert teams and 60 specialties

| #   | Team                      | Specialty 1                    | Specialty 2                     | Specialty 3              |
| --- | ------------------------- | ------------------------------ | ------------------------------- | ------------------------ |
| 1   | **Pipeline & CI**         | PowerShell parse & syntax      | GitHub Actions workflows        | verify-pipeline.ps1      |
| 2   | **Runbook & Ops**         | run-runbook.ps1                | Credential-gating               | Operator procedures      |
| 3   | **Shopify & theme**       | Theme dev & pull               | Store ops & deploy              | Preview-before-apply     |
| 4   | **Commerce & products**   | Product sync & Admin API       | data/products JSON              | sync-products.ps1        |
| 5   | **Cursor & agents**       | .cursor/rules                  | .cursor/skills                  | AGENTS.md & permissions  |
| 6   | **Plans & orchestration** | .cursor/plans                  | Perfection loop execution       | Lead agent coordination  |
| 7   | **Browser & E2E**         | Playwright config & specs      | Browser MCP usage               | E2E credential flows     |
| 8   | **Desktop automation**    | Mouse/keyboard control         | Screen capture & OCR            | Issue detection          |
| 9   | **Security & secrets**    | .env.local & .gitignore        | No secrets in commits           | verify-credentials       |
| 10  | **Documentation**         | OPERATOR_RUNBOOK               | GURU_PP_OPERATOR_GUIDE          | docs/ structure          |
| 11  | **Testing**               | Unit tests (vitest)            | Integration tests               | Desktop automation tests |
| 12  | **Developer experience**  | full-setup.ps1                 | Scripts portability & repo-root | DX clarity               |
| 13  | **Repo & Git**            | Worktrees & WORKTREE_INVENTORY | Branch strategy & main          | Pre-commit hooks         |
| 14  | **Quality gates**         | Prettier format                | ESLint                          | test:unit in quality     |
| 15  | **Handoff & knowledge**   | HANDOFF_FOR_NEW_AGENT          | CONSOLIDATION_LOG               | INDEX_REPORTS            |
| 16  | **Status & tracking**     | docs/status/                   | deploy-log.md                   | pending-approval.md      |
| 17  | **Integration**           | Shopify API integration        | GitHub API integration          | Env consistency          |
| 18  | **Resilience**            | Test timeouts & flakiness      | Credential-gated fallbacks      | Error handling           |
| 19  | **Performance**           | Script parse performance       | Test suite duration             | Pipeline speed           |
| 20  | **Finalization**          | Commit message & scope         | Push & branch sync              | deploy-log & completion  |

---

## Multi-perspective audit checklist (per team)

Use this when running the loop “from 20 perspectives.” Each team’s lens maps to plan steps and artifacts.

| Team                    | Primary check                                      | Artifacts / commands                         |
| ----------------------- | -------------------------------------------------- | -------------------------------------------- |
| 1 Pipeline & CI         | All 74 scripts parse; 6 workflows valid            | `.\scripts\verify-pipeline.ps1 -SkipRunbook` |
| 2 Runbook & Ops         | Runbook runs or reports cred state                 | `.\scripts\run-runbook.ps1`                  |
| 3 Shopify & theme       | Theme paths, preview flow, no blind push           | OPERATOR_RUNBOOK, theme-dev, deploy-log      |
| 4 Commerce & products   | Product sync dry-run or skip when no creds         | verify-pipeline step 3, sync-products.ps1    |
| 5 Cursor & agents       | Rules/skills/AGENTS.md present and referenced      | .cursor/rules, .cursor/skills, AGENTS.md     |
| 6 Plans & orchestration | Plan steps 1–7 and completion criteria             | MASTER_GURU_E2E_PERFECTION_RUN.plan.md       |
| 7 Browser & E2E         | Playwright and E2E specs run or env-documented     | npm run test:e2e, HANDOFF E2E note           |
| 8 Desktop automation    | 13/13 desktop tests pass                           | npx vitest run tests/desktop-automation      |
| 9 Security & secrets    | .env.local gitignored; no secrets in commits       | .gitignore, verify-credentials               |
| 10 Documentation        | Runbook and operator guide current                 | OPERATOR_RUNBOOK, GURU_PP_OPERATOR_GUIDE     |
| 11 Testing              | Unit + integration + desktop paths valid           | npm run quality, test:integration, desktop   |
| 12 Developer experience | full-setup, portable paths, README clear           | full-setup.ps1, scripts repo-root            |
| 13 Repo & Git           | Worktree doc, main strategy, hooks                 | WORKTREE_INVENTORY, pre-commit               |
| 14 Quality gates        | format, format:check, lint, test:unit              | npm run quality                              |
| 15 Handoff & knowledge  | HANDOFF, CONSOLIDATION_LOG, INDEX_REPORTS          | docs/status/\*                               |
| 16 Status & tracking    | Status docs updated; deploy-log when store changes | CONSOLIDATION_LOG, deploy-log                |
| 17 Integration          | Shopify/GitHub APIs and env documented             | run-runbook, test-connection, verify-auth    |
| 18 Resilience           | Timeouts and cred fallbacks documented             | issue-detection timeout, -SkipRunbook        |
| 19 Performance          | Pipeline and test times acceptable                 | verify-pipeline output, vitest duration      |
| 20 Finalization         | Commit, push, deploy-log if store-affecting        | Step 7, CONSOLIDATION_LOG entry              |

---

## How to use in the loop

- **Single lead run**: Execute [MASTER_GURU_E2E_PERFECTION_RUN.plan.md](../../.cursor/plans/MASTER_GURU_E2E_PERFECTION_RUN.plan.md) steps 2–5; mentally or explicitly tick the checklist above so all 20 perspectives are satisfied.
- **Multi-agent simulation**: When assigning work, assign by team (e.g. “Team 9: Security audit,” “Team 14: Quality gates”); merge findings and re-run from step 2.
- **Freshness**: Re-read this roster when starting a new loop iteration to avoid repeating the same perspective and to surface gaps (e.g. Team 16 status/tracking, Team 18 resilience).

---

## Assignment (2026-02-07 — rerun from step 2)

User approved: assign teams, then re-run from step 2. Lead agent assigns primary check to each team; findings merged; re-run step 2 onward.

| Team                    | Assignment (primary check)                               |
| ----------------------- | -------------------------------------------------------- |
| 1 Pipeline & CI         | verify-pipeline.ps1 -SkipRunbook                         |
| 2 Runbook & Ops         | run-runbook.ps1 (cred-gated; report state)               |
| 3 Shopify & theme       | OPERATOR_RUNBOOK, theme-dev, deploy-log                  |
| 4 Commerce & products   | verify-pipeline step 3 (product sync skip when no creds) |
| 5 Cursor & agents       | .cursor/rules, .cursor/skills, AGENTS.md                 |
| 6 Plans & orchestration | MASTER_GURU_E2E_PERFECTION_RUN.plan.md steps 1–7         |
| 7 Browser & E2E         | Playwright/E2E specs; HANDOFF E2E note                   |
| 8 Desktop automation    | npx vitest run tests/desktop-automation                  |
| 9 Security & secrets    | .gitignore .env.local; verify-credentials                |
| 10 Documentation        | OPERATOR_RUNBOOK, GURU_PP_OPERATOR_GUIDE                 |
| 11 Testing              | npm run quality; test:integration; desktop               |
| 12 Developer experience | full-setup.ps1; scripts repo-root                        |
| 13 Repo & Git           | WORKTREE_INVENTORY; pre-commit                           |
| 14 Quality gates        | npm run quality                                          |
| 15 Handoff & knowledge  | HANDOFF, CONSOLIDATION_LOG, INDEX_REPORTS                |
| 16 Status & tracking    | CONSOLIDATION_LOG, deploy-log                            |
| 17 Integration          | run-runbook, test-connection, verify-auth                |
| 18 Resilience           | issue-detection timeout; -SkipRunbook                    |
| 19 Performance          | verify-pipeline; vitest duration                         |
| 20 Finalization         | Commit, push, CONSOLIDATION_LOG entry                    |

---

_Added 2026-02-07 for “continue the loop from 20 guru expert teams / 60 specialties” execution._
