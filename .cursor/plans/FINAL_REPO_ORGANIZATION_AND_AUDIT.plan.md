---
name: Final repo organization and audit
overview: Single canonical plan to sort, label, organize, clean, and update the entire repository—branches, workflows, worktrees, agents, docs, scripts, configs, assets, code, and tooling—with Phase 0 inventory, seven expert tracks, synthesis, and all known gaps and resolutions baked in. No other plans remain; this is the only plan.
todos: []
isProject: false
---

# Final Repository Organization and Audit Plan

**Purpose**: One plan for full repo organization and audit. Execute Phase 0 first, then Tracks A–G, then Synthesis. All changes are progressive and enhancing only; nothing is overlooked or left unresolved.

**Gate**: Phase 0 must be signed off before tracks. Sign-off line: **"Phase 0 finalized; proceeding allowed."** (See [prompts/PERFECT_EXECUTION_PROMPT.md](prompts/PERFECT_EXECUTION_PROMPT.md) and [docs/status/PLAN_AGENT_ENTRY.md](docs/status/PLAN_AGENT_ENTRY.md).)

**Reference (already implemented)**: Pipeline and preview-before-apply: [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md). Security and platform: browser-first, no headless Shopify admin; [.cursor/rules/use-user-browser.mdc](.cursor/rules/use-user-browser.mdc), [.cursor/rules/shopify-preview-approval.mdc](.cursor/rules/shopify-preview-approval.mdc), [docs/security/00_security_checklist.md](docs/security/00_security_checklist.md).

---

## Scope

Organize and improve: **branches, workflows, worktrees, agents, consoles, environments, pipeline, scripts, plans, rules, hooks, issues, templates, archives, analyses, statuses, reports, MD files, assets, configs, monitoring, quality, data, knowledge bases, launch files, screenshots, security, licenses, parsers, libraries, lint, apps, extensions, schemas, actions, builds, syncs, utilities, settings, codebase**—in Cursor, GitHub, and locally. All changes logged with versions/update details; READMEs and indices consolidated.

---

## Current state and must-resolve (from audit)

These items **must** be addressed during execution; do not skip.

| #   | Issue                                                                                                                        | Where             | Resolution                                                                                                       |
| --- | ---------------------------------------------------------------------------------------------------------------------------- | ----------------- | ---------------------------------------------------------------------------------------------------------------- |
| 1   | **develop** branch does not exist but ci.yml, quality-check.yml, deploy.yml reference it                                     | Track A + B       | Create develop and document strategy, or remove develop from all workflow triggers and document main-only        |
| 2   | **worktrees.json** does not list ewa, mhx, snq or their paths (four worktrees exist: main repo + ewa, mhx, snq)              | Phase 0 + Track A | Document in BRANCH_INVENTORY or WORKTREE_INVENTORY.md; align worktrees.json or doc-only                          |
| 3   | **deploy.yml** is placeholder (echo only)                                                                                    | Track B           | Implement real deploy or remove; document in workflow README                                                     |
| 4   | **shopify-sync.yml** backup-store job is placeholder                                                                         | Track B           | Implement or remove; document                                                                                    |
| 5   | **No LICENSE file**; package.json has UNLICENSED                                                                             | Track A           | Add LICENSE file or document "UNLICENSED; no LICENSE file" in runbook                                            |
| 6   | **GitHub Environments** not used; deploy is branch-based                                                                     | Track B           | Document in workflow README: "No GitHub Environments; deploy is branch-based (develop=staging, main=production)" |
| 7   | **.github/settings.optimization.md** not in plan                                                                             | Track B or D      | Keep current (branch protection, topics, description)                                                            |
| 8   | **Root .png files** (7+ logo/design files) — move to assets or archive                                                       | Phase 0 + Track F | List in Phase 0; Track F move and log in ARCHIVE_LOG                                                             |
| 9   | **Remote URL** (toodeceptive/against-the-odds) — verify intentional                                                          | Phase 0 + Track A | Document in inventory; verify with user if needed                                                                |
| 10  | **Stale local branches** (ao-guru-exec, finalization/consolidate-20260129, wip/finalization-team-20260129) — merge or delete | Track A           | Include in branch strategy; decide and document                                                                  |

**Branch snapshot (audit)**: main (local + origin); develop (absent); ao-guru-exec, cursor/main-project-setup-2bd1, finalization/consolidate-20260129, handoff-doc-permissions-20260129, wip/finalization-team-20260129 (local); shopify-theme (workflow-created by sync-theme-branch.yml). **Worktree snapshot**: Primary `C:\Users\LegiT\against-the-odds` (main); ewa, mhx, snq under `.cursor/worktrees/against-the-odds/` (see IF_HANDOFF primary path).

---

## Architecture

```mermaid
flowchart LR
  subgraph gate [Gate]
    P0[Phase 0 Inventory]
  end
  subgraph tracks [Tracks]
    T1[Track A Repo and branches]
    T2[Track B Workflows]
    T3[Track C Agents and rules]
    T4[Track D Docs and archives]
    T5[Track E Scripts and config]
    T6[Track F Assets and security]
    T7[Track G Code and codebase]
  end
  subgraph synth [Synthesis]
    S1[Indices and logs]
    S2[README and handoff]
  end
  P0 --> T1
  P0 --> T2
  P0 --> T3
  P0 --> T4
  P0 --> T5
  P0 --> T6
  P0 --> T7
  T1 --> S1
  T2 --> S1
  T3 --> S1
  T4 --> S1
  T5 --> S1
  T6 --> S1
  T7 --> S1
  S1 --> S2
```

---

## Phase 0: Audit and inventory (Code / auditing gurus)

**Owner**: Code and codebase analysis and auditing team ([prompts/expert-03-code-quality.md](prompts/expert-03-code-quality.md), [prompts/ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md](prompts/ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md)).

**Goal**: Single source of truth for what exists before reorganization. No structural moves yet.

- **Branches**: List local and remote; merge state, default, protected. Document in **docs/status/BRANCH_INVENTORY.md** (or appendix). **Include develop absence and trigger mismatch.**
- **Worktrees**: Document [.cursor/worktrees.json](.cursor/worktrees.json) and actual worktree list (paths, branch/HEAD, purpose). **Note worktrees.json does not list ewa/mhx/snq.**
- **Files and folders**: Full inventory of root, scripts, docs, .github, .cursor, config, data, assets, src, tests (use [docs/status/INDEX_REPORTS.md](docs/status/INDEX_REPORTS.md), [docs/status/FULL_SYSTEM_FILE_AUDIT_20260130.md](docs/status/FULL_SYSTEM_FILE_AUDIT_20260130.md)). **Root: explicit list including replacements.txt, each .png; flag .png for Track F.**
- **.tmp / temp**: List all .tmp, temp, cache paths and intended cleanup/retention.
- **node_modules, builds, bins**: Confirm .gitignore; list any bins or symlinks.
- **Environments and secrets**: List .env.example, .env.shopify.example, .env.local; confirm .env.local gitignored; note GitHub Actions secrets; **no GitHub Environments in use.**
- **Handoff chain**: Confirm presence of PLAN_HANDOFF_FOR_NEXT_AGENT.md, CONVERSATION_AUDIT.md, IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md; primary path `C:\Users\LegiT\against-the-odds`.
- **LICENSE**: State "No LICENSE file; package.json UNLICENSED" and add to Track A resolution.
- **Remote**: Record origin URL and default branch; note "verify repo/org name (toodeceptive/against-the-odds)."

**Deliverable**: Phase 0 inventory doc with branches, worktrees, folder inventory, .tmp/build/bin, env/secrets, handoff locations, root files (.png, replacements.txt), LICENSE state. Sign-off: **"Phase 0 inventory complete; tracks may proceed."**

---

## Track A: Repo structure, branches, worktrees, refs

**Owner**: Expert 6 + release lead ([prompts/expert-06-cicd-devops.md](prompts/expert-06-cicd-devops.md), [prompts/finalization-release-branch-manager.md](prompts/finalization-release-branch-manager.md)).

- **develop**: Resolve issue #1 — create develop and document, or remove from all workflow triggers and document main-only.
- **Worktrees**: Document ewa, mhx, snq (path, branch, purpose); align worktrees.json or **docs/status/WORKTREE_INVENTORY.md**; link from [docs/ENVIRONMENT_SETUP.md](docs/ENVIRONMENT_SETUP.md) or OPERATOR_RUNBOOK.
- **Stale branches**: List ao-guru-exec, finalization/consolidate-20260129, wip/finalization-team-20260129; decide merge/delete; document.
- **Refs / tags**: List tags and refs; decide retention and naming; document.
- **Root clutter**: No stray scripts (legacy in [scripts/archive/root-scripts-legacy/](scripts/archive/root-scripts-legacy/)). **replacements.txt**: Verify documented in [OPERATOR_RUNBOOK.md](OPERATOR_RUNBOOK.md) and/or [docs/CREDENTIALS_SETUP.md](docs/CREDENTIALS_SETUP.md); optionally relocate to config/replacements-git-filter-repo.txt.
- **LICENSE**: Add LICENSE file or document UNLICENSED in runbook (issue #5).
- **Branch strategy**: Document main vs develop (or main-only), long-lived (e.g. shopify-theme), GitHub branch protection, default branch.

**Log**: Track A section in **docs/status/CONSOLIDATION_LOG.md** with date and summary.

---

## Track B: Workflows, actions, builds, syncs, pipeline

**Owner**: Expert 6 ([prompts/expert-06-cicd-devops.md](prompts/expert-06-cicd-devops.md)).

- **develop in triggers**: After Track A decision, update ci.yml, quality-check.yml, deploy.yml (and sync.yml if removing develop).
- **deploy.yml** (issue #3): Implement or remove; document in [.github/workflows/README.md](.github/workflows/README.md).
- **shopify-sync backup-store** (issue #4): Implement or remove; document in README.
- **Environments** (issue #6): Add to README: "No GitHub Actions Environments in use; deploy is branch-based (develop → staging, main → production)."
- **.github/settings.optimization.md** (issue #7): Keep current (branch protection, topics, repo description); review in Track B or D.
- **Workflows**: Review ci, deploy, maintenance, quality-check, shopify-sync, sync-theme-branch, sync — purpose, trigger, active vs placeholder; document in README.
- **Syncs**: Document shopify-sync, sync-theme-branch, sync and relationship to [scripts/shopify/](scripts/shopify), [scripts/sync/](scripts/sync).

**Deliverable**: Updated [.github/workflows/README.md](.github/workflows/README.md) with workflow list, triggers, secrets, placeholders (and implement/remove decision), environments. Log in CONSOLIDATION_LOG.

---

## Track C: Agents, prompts, rules, plans, hooks, filters

**Owner**: Expert 5 + head guru ([prompts/expert-05-documentation.md](prompts/expert-05-documentation.md), [prompts/head-guru-orchestrator.md](prompts/head-guru-orchestrator.md)).

- **Prompts**: Index all [prompts/](prompts) (experts 01–10, finalization-_, head-guru, MASTER*10_EXPERT_SYSTEM, AO_GURU, PERFECT_EXECUTION, master/ULTIMATE*_, setup, testing, debugging, optimization, agent-capabilities, agent-context). Label current vs reference/deprecated; [docs/AGENT_PROMPT_DECISION_TREE.md](docs/AGENT_PROMPT_DECISION_TREE.md) and [docs/status/PLAN_AGENT_ENTRY.md](docs/status/PLAN_AGENT_ENTRY.md) point to correct prompts.
- **Cursor rules**: List [.cursor/rules/](.cursor/rules) (agent-permissions.mdc, ao-guru.rules.md, env-credentials.mdc, shopify-preview-approval.mdc, use-user-browser.mdc); verify no conflict with [AGENTS.md](AGENTS.md).
- **Cursor context and workspace**: .cursor/context (github.md, shopify.md), tasks.json, settings.json, extensions.json — keep current and documented.
- **Plans**: [.cursor/plans/README.md](.cursor/plans/README.md) is the single index; this plan is the only plan. Add last-updated and version note. Plan execution outputs go to docs/status with date (e.g. CODEBASE_AUDIT_YYYYMMDD.md).
- **Hooks**: [config/git-hooks/pre-commit](config/git-hooks/pre-commit) and [scripts/git/pre-commit.ps1](scripts/git/pre-commit.ps1) — document what runs where; single source of truth.
- **Filters**: Document .cursor or repo-level ignore patterns in OPERATOR_RUNBOOK or docs.

**Deliverable**: Updated agent/plan index, rules list, Cursor context/workspace doc, hooks doc. Log in CONSOLIDATION_LOG.

---

## Track D: Docs, statuses, reports, archives, READMEs, knowledge base, launch, templates

**Owner**: Expert 5 ([prompts/expert-05-documentation.md](prompts/expert-05-documentation.md)).

- **Archives**: Complete [docs/status/PLAN_EXPIRED_LEGACY_CLEANUP_20260130.md](docs/status/PLAN_EXPIRED_LEGACY_CLEANUP_20260130.md). Legacy under [archive/2026-01-30/](archive/2026-01-30/). **archive/ARCHIVE_LOG.md** (parent level) with version/date per batch; keep archive/2026-01-30/ARCHIVE_NOTE.md as needed.
- **Status and reports**: [docs/status/](docs/status) — [docs/status/INDEX_REPORTS.md](docs/status/INDEX_REPORTS.md) as master index; **version/update table** (File | Last updated | Summary); move superseded to archive and log in ARCHIVE_LOG.
- **Analyses**: docs/expert-analyses vs archive/2026-01-30/expert-analyses-legacy — single index in INDEX_REPORTS.
- **Knowledge base**: [docs/knowledge-base/](docs/knowledge-base) — tidy, cross-link, [docs/knowledge-base/README.md](docs/knowledge-base/README.md) as entry.
- **Launch**: [docs/launch/](docs/launch) — README and numbering clear; link from docs/README.
- **Templates**: [.github/ISSUE_TEMPLATE/](.github/ISSUE_TEMPLATE/) (bug, feature, task), [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md) — current and documented. **settings.optimization.md** — keep current when branch/repo settings change.
- **README consolidation**: Root [README.md](README.md), [docs/README.md](docs/README.md), [OPERATOR_RUNBOOK.md](OPERATOR_RUNBOOK.md), [CHANGELOG.md](CHANGELOG.md), section READMEs — current info, links, "last updated"; one place for "where to find what" (INDEX_REPORTS + docs/README).

**Deliverable**: archive/ARCHIVE_LOG.md, updated INDEX_REPORTS with version/update table, consolidated READMEs. Log in CONSOLIDATION_LOG.

---

## Track E: Scripts, configs, monitoring, quality, utilities, data

**Owner**: Expert 10 + Expert 6 + Expert 9 ([prompts/expert-10-developer-experience.md](prompts/expert-10-developer-experience.md), [prompts/expert-06-cicd-devops.md](prompts/expert-06-cicd-devops.md), [prompts/expert-09-database-data.md](prompts/expert-09-database-data.md)).

- **Scripts**: [scripts/](scripts) — group by domain; **scripts/README.md** with list, purpose, when to run (link from OPERATOR_RUNBOOK).
- **package.json scripts**: Document in scripts/README; align with scripts/ and CI.
- **Config files**: config/, .editorconfig, eslint.config.mjs (ESLint 9 flat), .prettierrc.json, vitest.config.js, playwright.config.js, playwright.shopify.config.js, config/shopify/.shopify-cli.yml — list and label; config index (e.g. config/README.md or docs).
- **Environments**: .env.example, .env.shopify.example placeholders; document in [docs/CREDENTIALS_SETUP.md](docs/CREDENTIALS_SETUP.md); .env.local single local secret store, never committed.
- **Monitoring and quality**: scripts/health, scripts/monitoring, scripts/quality — document when (local vs CI); align with workflows.
- **.tmp and temp**: Remove or relocate per Phase 0 list; document in runbook or scripts README.
- **Data**: [data/](data) — structure, data/README or docs; Expert 9 owns data schema (products, manufacturers, samples).
- **Lint**: Centralize lint config and scripts; document in README or CODE_REVIEW_PROCESS.
- **Dependency audit**: npm audit, lockfile, optional Dependabot; document policy; Expert 1 input for vulns.

**Deliverable**: scripts/README.md (incl. npm script map), config index, monitoring/quality alignment. Log in CONSOLIDATION_LOG.

---

## Track F: Assets, artwork, exports, mockups, specs, security, extensions

**Owner**: Expert 8 + Expert 1 ([prompts/expert-08-frontend-ux.md](prompts/expert-08-frontend-ux.md), [prompts/expert-01-security-secrets.md](prompts/expert-01-security-secrets.md)).

- **Root .png files** (issue #8): List in Phase 0; move each to [assets/](assets) (e.g. assets/brand/) or archive with ARCHIVE_LOG entry; remove from root.
- **Screenshots**: Define location (e.g. docs/screenshots) and naming; .gitignore has docs/screenshots/\*.png|jpg; ensure docs/screenshots exists and is documented.
- **Assets**: [assets/drop01/](assets/drop01) (artwork, exports, mockups, spec-pack) — label, READMEs current; asset index if needed.
- **Security**: [docs/security/](docs/security), [scripts/maintenance/security-scan.ps1](scripts/maintenance/security-scan.ps1) — checklist and scans current; verify no secrets in repo, .env.local gitignored, credentials doc current.
- **Extensions**: .cursor/extensions.json, .cursor/settings.json — list recommended extensions and purpose; document in docs or .cursor README.

**Deliverable**: Asset index or updated asset READMEs, screenshots policy, security checklist updated, extensions documented. Log in CONSOLIDATION_LOG.

---

## Track G: Code, codebase, language, and full audit (Code / auditing gurus)

**Owner**: Code and codebase analysis and auditing team ([prompts/expert-03-code-quality.md](prompts/expert-03-code-quality.md), [prompts/expert-04-testing-qa.md](prompts/expert-04-testing-qa.md), [prompts/ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md](prompts/ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md), [prompts/expert-07-integrations-api.md](prompts/expert-07-integrations-api.md)).

- **Codebase layout**: [src/](src) — modules (shopify, browser-automation, desktop-automation); entry points and dependencies; language mix (JS).
- **Libraries and parsers**: package.json, parsers, bins; document; versions and licenses consistent.
- **Strings and i18n**: Hardcoded strings, env var naming (e.g. SHOPIFY\_\*); document in codebase audit.
- **Lint and format**: Run lint/format; fix or document exceptions; single-source configs.
- **Tests**: [tests/](tests) — structure (e2e, integration, unit, shopify-admin, desktop-automation); align with coverage and CI; document in TEST_COVERAGE or docs.
- **Schemas and data contracts**: List and document.
- **Apps and extensions**: Any app/extension code in repo — label and document.

**Deliverable**: **docs/status/CODEBASE_AUDIT_YYYYMMDD.md** with structure, dependencies, lint/test status, strings/env approach, recommendations; main README or docs "Code layout" section. Log in CONSOLIDATION_LOG.

**Track G+ (optional)**: Expert 2 performance pass after Track G — use docs/status/performance-report.json if present; produce docs/status/PERFORMANCE_AUDIT_YYYYMMDD.md.

---

## Synthesis: Indices, logs, README, handoff

**Owner**: Expert 5 + head guru ([prompts/expert-05-documentation.md](prompts/expert-05-documentation.md), [prompts/head-guru-orchestrator.md](prompts/head-guru-orchestrator.md)).

- **Consolidation log**: **docs/status/CONSOLIDATION_LOG.md** — first entry "Phase 0 inventory completed" with date and pointer to BRANCH_INVENTORY / WORKTREE_INVENTORY; then dated entry per track with summary and pointers.
- **Version/update**: archive/ARCHIVE_LOG.md (parent); INDEX_REPORTS version/update table (File | Last updated | Summary); plan outputs in docs/status with date.
- **Log locations**: deploy-log.md, pending-approval.md, CONSOLIDATION_LOG, ARCHIVE_LOG — document retention and naming (append-only; clear pending-approval after apply).
- **Resolved issues**: In CONSOLIDATION_LOG or short "RESOLVED_ISSUES" section, record resolution of each of the 10 issues (e.g. "develop: removed from triggers; main-only documented").
- **Master README**: Root README.md — overview, links to OPERATOR_RUNBOOK, docs/README, INDEX_REPORTS, PLAN_AGENT_ENTRY, key scripts, "where to find what."
- **Handoff chain**: Update [docs/status/PLAN_AGENT_ENTRY.md](docs/status/PLAN_AGENT_ENTRY.md), [docs/HANDOFF_PROMPT_NEW_AGENT.md](docs/HANDOFF_PROMPT_NEW_AGENT.md), [docs/status/PLAN_HANDOFF_FOR_NEXT_AGENT.md](docs/status/PLAN_HANDOFF_FOR_NEXT_AGENT.md), [docs/status/IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md](docs/status/IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md) so next agent sees Phase 0, track deliverables, CONSOLIDATION_LOG location, primary path; CONVERSATION_AUDIT and PLAN_HANDOFF referenced and present.

---

## Execution order

1. **Phase 0** — run first; sign-off before tracks.
2. **Tracks A–G** — can run in parallel after Phase 0; each produces deliverable and consolidation-log entry.
3. **Synthesis** — after all tracks: CONSOLIDATION_LOG, ARCHIVE_LOG, INDEX_REPORTS and README updates, handoff update, resolved-issues summary.

---

## Key files to create or update

| Item                                                                 | Action                                                                                              |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Phase 0 inventory                                                    | docs/status (branches, worktrees, folders, .tmp/build/bin, env, handoff, root files, LICENSE state) |
| docs/status/BRANCH_INVENTORY.md (or WORKTREE_INVENTORY.md)           | List branches and worktrees; develop/worktrees resolution                                           |
| docs/status/CONSOLIDATION_LOG.md                                     | Create; dated entries Phase 0 + each track + resolved issues                                        |
| archive/ARCHIVE_LOG.md (parent)                                      | Version/date per archive batch; keep archive/2026-01-30/ARCHIVE_NOTE.md                             |
| docs/status/INDEX_REPORTS.md                                         | Version/update table and current vs legacy                                                          |
| .cursor/plans/README.md                                              | Single plan index; this plan only; last-updated                                                     |
| .github/workflows/README.md                                          | Workflow list, triggers, placeholders, environments, settings.optimization                          |
| scripts/README.md                                                    | Scripts by domain and when to run; npm script map                                                   |
| config index                                                         | config/README.md or docs                                                                            |
| docs/status/CODEBASE*AUDIT*\*.md                                     | From Track G                                                                                        |
| README.md, docs/README.md, OPERATOR_RUNBOOK.md                       | Consolidate and update                                                                              |
| PLAN_AGENT_ENTRY, HANDOFF_PROMPT_NEW_AGENT, PLAN_HANDOFF, IF_HANDOFF | Update with indices and log locations; primary path                                                 |

---

## Expert roster (reference)

- **Expert 1** (Security): Track F (security), Track E (dependency/vuln).
- **Expert 2** (Performance): Track G+ (optional performance audit after Track G).
- **Expert 3** (Code quality): Phase 0, Track G.
- **Expert 4** (Testing): Track G (tests, coverage).
- **Expert 5** (Documentation): Track C, Track D, Synthesis.
- **Expert 6** (CI/CD): Track A, Track B, Track E.
- **Expert 7** (Integrations): Track G, Track B.
- **Expert 8** (Frontend/UX): Track F.
- **Expert 9** (Database/Data): Track E (data schema).
- **Expert 10** (DevEx): Track E.
- **Code/audit gurus**: Phase 0 + Track G.
- **Head guru / finalization leads**: Synthesis, handoff, cross-track decisions.

---

## Consoles and log standardization

- **Consoles**: Terminal/CLI (run from repo root, PowerShell vs bash in CI) in OPERATOR_RUNBOOK and scripts/README; Cursor console — no separate doc; GitHub Actions logs — in workflow README and Synthesis retention note.
- **Log naming**: Date suffix YYYYMMDD for audit/status reports (e.g. CODEBASE_AUDIT_YYYYMMDD.md); document in INDEX_REPORTS.

---

## Common pitfalls and checks

- **Do not** move or delete files still referenced by HANDOFF, PLAN_AGENT_ENTRY, or PLAN_HANDOFF (e.g. system_finalization_report, blocker_resolution_commands, IF_HANDOFF_FILES_MISSING, CONVERSATION_AUDIT). See [docs/status/PLAN_EXPIRED_LEGACY_CLEANUP_20260130.md](docs/status/PLAN_EXPIRED_LEGACY_CLEANUP_20260130.md) "Out of scope."
- **AGENTS.md vs .cursor/rules**: Verify no conflicting permission or safety wording.
- **replacements.txt**: Already in OPERATOR_RUNBOOK; plan only verifies and optionally relocates.

---

## Success criteria

- Phase 0: BRANCH_INVENTORY (and WORKTREE_INVENTORY if separate) exists; lists every branch and worktree; notes develop absence, worktrees.json gap, remote URL, root files (.png, replacements.txt), LICENSE state.
- Track A: develop resolved; worktrees documented; stale branches decided and executed; LICENSE or UNLICENSED documented; replacements.txt verified.
- Track B: deploy.yml and shopify-sync backup-store decided and implemented or removed; README states no GitHub Environments, branch-based deploy; settings.optimization.md current.
- Track D: INDEX_REPORTS has version/update table; templates and settings.optimization.md reviewed.
- Track F: Root .png moved and ARCHIVE_LOG updated; screenshots location documented.
- Synthesis: CONSOLIDATION_LOG has Phase 0 + all tracks + resolved-issues summary; handoff files updated and point to logs/indices.

No branch, worktree, workflow, environment, directory, or critical file left undocumented or unresolved; every one of the 10 issues has a documented resolution.
