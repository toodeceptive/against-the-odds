# Cursor Plans — Index

**Purpose**: Which plan is current vs reference (implemented). Use `docs/AGENT_PROMPT_DECISION_TREE.md` and `docs/status/PLAN_AGENT_ENTRY.md` for entry and “which prompt when.”

| Plan file                                                 | Role                                                          | Status                                                                                                   |
| --------------------------------------------------------- | ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `perfect_execution_prompt_aca26457.plan.md`               | Phase 0 (mandatory cleanup/finalization)                      | **Current** — gate for all other work                                                                    |
| `cursor-github-shopify-pipeline.plan.md`                  | Cursor → GitHub → Shopify pipeline                            | **Current** — workflow, theme branch, preview/approval                                                   |
| `full_project_update_perfection_guru.plan.md`             | Full project update & perfection (audit, new system, cleanup) | **Current** — run when consolidating/updating project                                                    |
| `expert_team_security_and_platform_plan_fbf7f611.plan.md` | Security & platform (Shopify ToS, browser-first, no headless) | **Reference (implemented)** — rules and workflow reflect it; see `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md` |

**Entry**: Read `docs/status/PLAN_AGENT_ENTRY.md` first; then Phase 0 per `prompts/PERFECT_EXECUTION_PROMPT.md`; then use decision tree for audits or specialist work.
