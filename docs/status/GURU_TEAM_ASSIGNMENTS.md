# Guru Team Assignments — One-Page Reference

**Purpose**: One-page reference for the massive guru expert team assigned to the Final Repo Organization and Audit plan. Full detail is in [.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md](../../.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md).

**Total**: 10 experts + 14 finalization leads + 4 orchestration/audit = **28 guru roles**.

---

## Assignment matrix (who owns what)

| Phase / Track                                        | Primary owner(s)                                   | Reviewers / contributors                                                                       |
| ---------------------------------------------------- | -------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| **Phase 0**                                          | Expert 3, Ultimate Audit, PERFECT_EXECUTION (gate) | Expert 1 (secrets/env), Expert 6 (branches/workflows refs), Release Branch Manager             |
| **Track A** (repo, branches, worktrees, LICENSE)     | Expert 6, Release Branch Manager                   | Head Guru, Legal/Risk (LICENSE), Chief of Staff                                                |
| **Track B** (workflows, deploy, sync)                | Expert 6, Workflow Pipeline                        | Tech Release Manager, Shopify Store Ops (sync), Security Compliance                            |
| **Track C** (agents, prompts, rules, plans, hooks)   | Expert 5, Head Guru                                | Chief of Staff, Expert 10 (tasks/settings)                                                     |
| **Track D** (docs, statuses, archives, READMEs)      | Expert 5                                           | Content/Creative (content), Business Plan Lead (strategy docs), Analytics (reports)            |
| **Track E** (scripts, configs, data)                 | Expert 10, Expert 6, Expert 9                      | Expert 1 (secrets in config), Ops Manufacturing (data/products), DevEx                         |
| **Track F** (assets, security, extensions)           | Expert 8, Expert 1                                 | Content/Creative (assets), Security Compliance, Ops Manufacturing (spec-pack)                  |
| **Track G** (codebase, lint, tests)                  | Expert 3, Expert 4, Expert 7, Ultimate Audit       | Expert 2 (performance pass optional), Expert 9 (data contracts)                                |
| **Synthesis**                                        | Expert 5, Head Guru                                | Chief of Staff, Release Branch Manager                                                         |
| **Addendum** (paths, index.html, HOOKS, tasks, etc.) | Expert 10, Expert 5                                | Expert 6 (CI/hooks), Head Guru                                                                 |
| **Guru pass 2** (unidentified/unexamined)            | Head Guru, Chief of Staff                          | All experts as needed (replacements.txt, pre-commit, archive, prompts refs, launch, spec-pack) |

---

## Cross-cutting perfection dimensions

| Dimension                       | Owner guru                    | What they validate                                                                                               |
| ------------------------------- | ----------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **Security & secrets**          | Expert 1, Security Compliance | No secrets in repo; .env.local gitignored; workflows use secrets correctly; security checklist and scans current |
| **Legal & risk**                | Legal/Risk Lead               | LICENSE or UNLICENSED documented; public docs and templates safe; risk notes where needed                        |
| **Performance**                 | Expert 2                      | Optional Track G+ pass; performance-report.json and performance audit doc                                        |
| **Code quality & architecture** | Expert 3, Ultimate Audit      | Lint clean; structure documented; CODEBASE_AUDIT produced                                                        |
| **Testing & QA**                | Expert 4                      | Test layout, coverage, CI alignment; TEST_COVERAGE or docs                                                       |
| **Documentation**               | Expert 5                      | INDEX_REPORTS, READMEs, handoff chain, version/update table                                                      |
| **CI/CD & pipeline**            | Expert 6, Workflow Pipeline   | Workflow README, triggers, placeholders, branch strategy                                                         |
| **Integrations & APIs**         | Expert 7                      | Shopify/GitHub/API usage, theme-pull-rest API version, integration docs                                          |
| **Frontend & UX**               | Expert 8                      | Root .png → assets; screenshots policy; accessibility where applicable                                           |
| **Data & schema**               | Expert 9                      | data/ structure, products/manufacturers/samples, schema docs                                                     |
| **Developer experience**        | Expert 10                     | Scripts README, config index, paths (PSScriptRoot), tasks.json, HOOKS                                            |
| **Store & theme ops**           | Shopify Store Ops             | shopify-sync, theme branches, store-related workflows and scripts                                                |
| **Manufacturing & assets**      | Ops Manufacturing Lead        | drop01, spec-pack, manufacturer data; asset locations                                                            |
| **Business & strategy**         | Business Plan Lead, GTM Lead  | Business-facing docs, launch docs, strategy alignment                                                            |
| **Orchestration & handoff**     | Head Guru, Chief of Staff     | CONSOLIDATION_LOG, handoff files, PLAN_AGENT_ENTRY, next-agent prompt                                            |

---

## Guru handoffs (summary)

- **Phase 0** is gated by prompts/PERFECT_EXECUTION_PROMPT.md; sign-off in PHASE_0_FINALIZATION.md before tracks.
- **Tracks A–G** run in parallel after Phase 0; primary owners execute; reviewers validate their dimension.
- **Deliverables touching security, legal, or store ops** must be reviewed by Expert 1 / Legal/Risk Lead / Shopify Store Ops before Synthesis.
- **Guru pass 2** is Head Guru + Chief of Staff; append "Guru pass 2" to CONSOLIDATION_LOG.

---

## Prompts (quick reference)

- **Domain experts**: prompts/expert-01-security-secrets.md … prompts/expert-10-developer-experience.md
- **Finalization leads**: prompts/finalization-chief-of-staff.md, finalization-workflow-pipeline.md, finalization-release-branch-manager.md, finalization-tech-release-manager.md, finalization-security-compliance.md, finalization-shopify-store-ops.md, finalization-ops-manufacturing-lead.md, finalization-legal-risk-lead.md, finalization-gtm-growth-lead.md, finalization-business-plan-lead.md, finalization-finance-modeler.md, finalization-content-creative.md, finalization-customer-support-community.md, finalization-analytics-instrumentation.md
- **Orchestration**: prompts/head-guru-orchestrator.md, prompts/PERFECT_EXECUTION_PROMPT.md, prompts/ULTIMATE_COMPREHENSIVE_AUDIT_PROMPT.md, prompts/MASTER_10_EXPERT_SYSTEM.md

See the plan file for full prompt paths and tables.
