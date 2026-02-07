# 100-step multiphase PP cycles — deep research, fixes, optimizations, finalizations (2026-02-07)

**Purpose**: User-pre-approved massive full-scale multi-agent multi-cycle aligned comprehensive PP execution. Use for deep research, fixes, optimizations, reviewing, auditing, and finalizations across ALL trees, worktrees, branches, Git, GitHub, repos, and local files. If anything fails, fix it; if errors, fix them; if not set up, set up manually/autonomously using guru expert multi-agent analysis.

**Reference**: [GURU_PP_OPERATOR_GUIDE.md](../GURU_PP_OPERATOR_GUIDE.md), [OPERATOR_RUNBOOK.md](../../OPERATOR_RUNBOOK.md), [MASTER_GURU_E2E_PERFECTION_RUN.plan.md](../../.cursor/plans/MASTER_GURU_E2E_PERFECTION_RUN.plan.md), [EXECUTIVE_DECISION_WORK_PRINCIPLES.md](EXECUTIVE_DECISION_WORK_PRINCIPLES.md).

---

## How to use

- **Phases 1–10**: Execute in order; each step is a single verifiable action.
- **Verification**: After each step (or phase), run the listed verification; if it fails, **fix before proceeding**.
- **Guru review**: After each phase, apply multi-faceted guru expert team review; apply fixes/updates as needed.
- **Commits/pushes**: After in-depth review, apply changes, commits, pulls, pushes from **primary** repo only (see WORKTREE_INVENTORY).

---

## Phase 1 — Repo, Git, worktrees (Steps 1–10)

| Step | Action                                                  | Verification / Fix if fail                       |
| ---- | ------------------------------------------------------- | ------------------------------------------------ |
| 1    | Pull latest from origin/main from primary repo          | `git pull origin main` succeeds                  |
| 2    | Confirm branch is main on primary                       | `git branch --show-current` = main               |
| 3    | List all worktrees                                      | `git worktree list`; match WORKTREE_INVENTORY.md |
| 4    | Remove stale worktree refs from Cursor if hal/hvf shown | No "Failed to apply worktree" for hal/hvf        |
| 5    | Ensure no uncommitted secrets                           | No .env.local or secrets in git status           |
| 6    | Verify .gitignore includes .env.local, .env.\*          | `git check-ignore .env.local` succeeds           |
| 7    | Confirm remote origin URL                               | `git remote get-url origin` = repo URL           |
| 8    | Audit branch list vs BRANCH_INVENTORY                   | Local/remote branches documented                 |
| 9    | Ensure primary path is canonical for commits            | All commits from C:/Users/LegiT/against-the-odds |
| 10   | Phase 1 verification                                    | Steps 1–9 complete; no Git errors                |

---

## Phase 2 — Quality gates (Steps 11–20)

| Step | Action                                          | Verification / Fix if fail               |
| ---- | ----------------------------------------------- | ---------------------------------------- |
| 11   | Run Prettier format                             | `npm run format`; fix any changed files  |
| 12   | Run format check                                | `npm run format:check` passes            |
| 13   | Run ESLint                                      | `npm run lint`; fix all errors/warnings  |
| 14   | Run unit tests                                  | `npm run test:unit` passes               |
| 15   | Run full quality                                | `npm run quality` passes                 |
| 16   | Fix any Prettier/ESLint violations              | Re-run format + lint until clean         |
| 17   | Fix any failing unit tests                      | Fix tests or code until test:unit passes |
| 18   | Confirm eslint.config.mjs (flat config)         | ESLint 9 flat config in use              |
| 19   | Confirm .prettierrc.json and .markdownlint.json | Config files present and used            |
| 20   | Phase 2 verification                            | npm run quality passes                   |

---

## Phase 3 — Pipeline & CI (Steps 21–30)

| Step | Action                                      | Verification / Fix if fail                           |
| ---- | ------------------------------------------- | ---------------------------------------------------- |
| 21   | Parse all PowerShell scripts                | `.\scripts\verify-pipeline.ps1 -SkipRunbook` step 1  |
| 22   | Fix any script parse errors                 | All 74 scripts parse OK                              |
| 23   | Verify workflow files                       | Step 2: 6 workflows OK                               |
| 24   | Product sync dry-run (if creds)             | Step 3: skip or pass                                 |
| 25   | Lint in pipeline                            | Step 4: ESLint OK                                    |
| 26   | Runbook (optional, cred-gated)              | Step 5: skip or pass                                 |
| 27   | Confirm ci.yml runs on main                 | .github/workflows/ci.yml triggers on push/PR to main |
| 28   | Confirm format:check, lint, test:unit in CI | ci.yml job steps match                               |
| 29   | Document any credential-gated failures      | HANDOFF / CONSOLIDATION_LOG                          |
| 30   | Phase 3 verification                        | verify-pipeline passes (or runbook skip documented)  |

---

## Phase 4 — Cursor, extensions, settings (Steps 31–40)

| Step | Action                                                    | Verification / Fix if fail                                  |
| ---- | --------------------------------------------------------- | ----------------------------------------------------------- |
| 31   | Audit .cursor/extensions.json                             | 18 recommendations; no duplicates                           |
| 32   | Audit .vscode/extensions.json                             | Matches .cursor/extensions.json                             |
| 33   | Audit .cursor/settings.json                               | formatOnSave, defaultFormatter, codeActionsOnSave, worktree |
| 34   | Audit .vscode/settings.json                               | Mirrors editor/git/files (no cursor.\*)                     |
| 35   | Apply CURSOR_UI_OPTIMIZATION_CHECKLIST                    | User enables Iterate on Lints, Auto-apply, etc. in UI       |
| 36   | Confirm CURSOR_AND_AGENT_OPTIMIZATION §6                  | Checklist and personal settings doc current                 |
| 37   | Verify rules: pp-basis, env, shopify, browser, ao-guru    | .cursor/rules present and coherent                          |
| 38   | Verify skills: pp, phantasm, godmode, agentic-performance | .cursor/skills present                                      |
| 39   | Verify Verifier agent and /review, /pr commands           | .cursor/agents, .cursor/commands                            |
| 40   | Phase 4 verification                                      | Extensions/settings aligned; no config errors               |

---

## Phase 5 — GitHub, auth, secrets (Steps 41–50)

| Step | Action                                  | Verification / Fix if fail                                   |
| ---- | --------------------------------------- | ------------------------------------------------------------ |
| 41   | Run verify-auth.ps1                     | Repo access OK or fix auth                                   |
| 42   | Fix CLI errors in verify-auth if any    | Script runs without errors                                   |
| 43   | Run verify-secrets.ps1                  | List required/optional secrets or install gh                 |
| 44   | Document GITHUB_TOKEN usage             | Optional for API; push/pull may use SSH/HTTPS                |
| 45   | Document required Actions secrets       | SHOPIFY_STORE_DOMAIN, SHOPIFY_ACCESS_TOKEN, SHOPIFY_THEME_ID |
| 46   | Link to repo secrets URL in docs        | GitHub Settings → Secrets and variables → Actions            |
| 47   | If gh CLI installed: verify secret list | gh secret list (when authenticated)                          |
| 48   | Confirm no secrets in repo              | No .env or tokens committed                                  |
| 49   | Audit GitHub workflow permissions       | Workflows use least privilege                                |
| 50   | Phase 5 verification                    | Auth/secrets documented; no leaks                            |

---

## Phase 6 — Shopify, theme, store (Steps 51–60)

| Step | Action                                        | Verification / Fix if fail                               |
| ---- | --------------------------------------------- | -------------------------------------------------------- |
| 51   | Confirm theme path in scripts                 | src/shopify/themes/aodrop-theme (or doc)                 |
| 52   | Confirm .env.local for Shopify creds          | SHOPIFY_STORE_DOMAIN, SHOPIFY_ACCESS_TOKEN / THEME_TOKEN |
| 53   | Document theme pull TLS/SSL if failing        | HANDOFF deferred; no change unless env fixed             |
| 54   | Verify theme-dev.ps1, theme-pull.ps1 exist    | Scripts present and parse OK                             |
| 55   | Verify finish-setup.ps1 and SETUP_STATUS      | Setup doc updated when run                               |
| 56   | Confirm OPERATOR_RUNBOOK theme steps          | Daily checks and theme flow documented                   |
| 57   | Audit shopify-sync.yml, sync-theme-branch.yml | Workflows valid and main-triggered                       |
| 58   | Document application_url / config TODO if any | Intentional deferral in config                           |
| 59   | No store-affecting changes without deploy-log | deploy-log.md if store updated                           |
| 60   | Phase 6 verification                          | Theme/store docs and scripts consistent                  |

---

## Phase 7 — Tests: unit, integration, desktop, E2E (Steps 61–70)

| Step | Action                                          | Verification / Fix if fail                                |
| ---- | ----------------------------------------------- | --------------------------------------------------------- |
| 61   | Run unit tests                                  | `npm run test:unit` passes; fix failures                  |
| 62   | Run integration tests                           | Skip OK when creds missing; fix if run and fail           |
| 63   | Run desktop automation tests                    | `npx vitest run tests/desktop-automation` 13/13 pass      |
| 64   | Fix any desktop test failure                    | Fix code or test until 13/13 pass                         |
| 65   | Run E2E (Playwright) if env allows              | test:e2e or skip; document if env-dependent               |
| 66   | Fix any E2E failure if run                      | Fix spec or env                                           |
| 67   | Confirm vitest.config.js and playwright configs | Configs present and valid                                 |
| 68   | Confirm test scripts in package.json            | test, test:unit, test:integration, test:e2e, test:desktop |
| 69   | Document credential-gated skip for integration  | HANDOFF / test file comments                              |
| 70   | Phase 7 verification                            | All runnable tests pass or skip documented                |

---

## Phase 8 — Docs, status, consolidation (Steps 71–80)

| Step | Action                                              | Verification / Fix if fail                 |
| ---- | --------------------------------------------------- | ------------------------------------------ |
| 71   | Update CONSOLIDATION_LOG with run summary           | Append-only; dated entry                   |
| 72   | Update INDEX_REPORTS if new report added            | New doc in table                           |
| 73   | Align WORKTREE_INVENTORY with git worktree list     | Single source of truth                     |
| 74   | Align BRANCH_INVENTORY with branches                | Local/remote accurate                      |
| 75   | Confirm HANDOFF_FOR_NEW_AGENT_202602 current        | Deferred items and state accurate          |
| 76   | Confirm OPERATOR_RUNBOOK and GURU_PP_OPERATOR_GUIDE | Daily gates and plans linked               |
| 77   | Confirm AGENTS.md and safety rules                  | Permissions and workflow pointers          |
| 78   | Fix any broken cross-references in status docs      | Links resolve                              |
| 79   | Run Prettier on docs/status if needed               | format:check passes                        |
| 80   | Phase 8 verification                                | Docs consistent; CONSOLIDATION_LOG updated |

---

## Phase 9 — Cleanup, optimize, fix (Steps 81–90)

| Step | Action                                        | Verification / Fix if fail                       |
| ---- | --------------------------------------------- | ------------------------------------------------ |
| 81   | Remove dead code or obsolete refs if any      | No broken imports or links                       |
| 82   | Optimize scripts: portability, error handling | Scripts parse; try/catch where needed            |
| 83   | Ensure no hardcoded absolute paths in scripts | Use PSScriptRoot / repo root resolution          |
| 84   | Confirm .cursorignore or template             | CURSORIGNORE_TEMPLATE.txt; user copies if needed |
| 85   | Audit package.json scripts                    | All scripts runnable and documented              |
| 86   | npm audit (optional)                          | 0 critical/high or document accepted risk        |
| 87   | Clean unused dependencies if any              | package.json and lock file consistent            |
| 88   | Apply EXECUTIVE_DECISION_WORK_PRINCIPLES      | No redundant re-audits; incremental work         |
| 89   | Re-run quality after cleanup                  | npm run quality passes                           |
| 90   | Phase 9 verification                          | Cleanup applied; quality passes                  |

---

## Phase 10 — Finalize, commit, push (Steps 91–100)

| Step | Action                                    | Verification / Fix if fail                     |
| ---- | ----------------------------------------- | ---------------------------------------------- |
| 91   | Guru expert team review of all changes    | Multi-faceted review complete                  |
| 92   | Apply any final fixes from review         | Fixes applied; re-verify quality               |
| 93   | Stage all intended changes                | git add (only intended files)                  |
| 94   | Commit with clear message                 | git commit -m "scope: description"             |
| 95   | Pull before push (if team)                | git pull origin main; resolve conflicts        |
| 96   | Push to origin main                       | git push origin main                           |
| 97   | Confirm push succeeded                    | origin/main updated                            |
| 98   | Update CONSOLIDATION_LOG with final entry | Entry includes commit hash and summary         |
| 99   | Update INDEX_REPORTS if new report        | This doc or others added                       |
| 100  | Phase 10 verification                     | All changes committed and pushed; docs updated |

---

## Verification summary (full system)

After running all 100 steps (or a subset with fixes):

- **Quality**: `npm run quality` — pass
- **Pipeline**: `.\scripts\verify-pipeline.ps1 -SkipRunbook` — pass
- **Desktop automation**: `npx vitest run tests/desktop-automation` — 13/13 pass
- **Integration**: Skip when creds missing (by design); pass when creds set
- **Git**: Clean state; commits from primary only; CONSOLIDATION_LOG and INDEX_REPORTS updated

---

## Failure handling (user-pre-approved)

- **If any step fails**: Fix the cause (CLI errors, settings, APIs, connections, extensions); re-run verification; then proceed.
- **If tests fail**: Fix tests or code until they pass; document only if credential-gated or env-dependent.
- **If GitHub/settings issues**: Fix via browser or gh CLI; document in status docs.
- **If setups incomplete**: Set up manually or autonomously using guru expert multi-agent analysis and deep research.

---

_Linked from CONSOLIDATION_LOG and INDEX_REPORTS. Execute from primary repo; coordinate worktrees per WORKTREE_INVENTORY._
