# Documentation index

Single entry point for all docs. Each concept has one canonical file; others link here or to it.

## Workflow and store (canonical)

| Doc                                                                                  | Purpose                                                                     |
| ------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| [AGENT_WORKFLOW_CURSOR_SHOPIFY.md](AGENT_WORKFLOW_CURSOR_SHOPIFY.md)                 | **Canonical** — Preview-before-apply workflow for theme and product changes |
| [UPDATE_SHOPIFY_FROM_CURSOR.md](UPDATE_SHOPIFY_FROM_CURSOR.md)                       | Alternate entry: how to update Shopify from Cursor                          |
| [guides/SHOPIFY_CURSOR_USAGE_GUIDE.md](guides/SHOPIFY_CURSOR_USAGE_GUIDE.md)         | User guide: what to run / what to say when giving prompts                   |
| [guides/WORKFLOW_PIPELINE_VISUAL_GUIDE.md](guides/WORKFLOW_PIPELINE_VISUAL_GUIDE.md) | Visual workflow/pipeline: when you prompt an agent (store vs other work)    |

## Setup and credentials

| Doc                                                      | Purpose                                                          |
| -------------------------------------------------------- | ---------------------------------------------------------------- |
| [SETUP_GITHUB.md](SETUP_GITHUB.md)                       | GitHub and development setup                                     |
| [SHOPIFY_SETUP.md](SHOPIFY_SETUP.md)                     | Complete Shopify setup guide                                     |
| [CREDENTIALS_SETUP.md](CREDENTIALS_SETUP.md)             | Credentials and .env.local (canonical)                           |
| [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md)             | Full environment and tooling (see CREDENTIALS_SETUP for secrets) |
| [BROWSER_CREDENTIAL_FLOW.md](BROWSER_CREDENTIAL_FLOW.md) | Browser-based credential flow                                    |
| [CODACY_MCP_SETUP.md](CODACY_MCP_SETUP.md)               | Codacy MCP troubleshooting (agents)                              |
| [guides/quick-start.md](guides/quick-start.md)           | Quick start                                                      |

## Operations and runbooks

| Doc                                                | Purpose                                             |
| -------------------------------------------------- | --------------------------------------------------- |
| [../OPERATOR_RUNBOOK.md](../OPERATOR_RUNBOOK.md)   | Daily checks, Shopify flow, credentials (repo root) |
| [FINALIZATION_RUNBOOK.md](FINALIZATION_RUNBOOK.md) | Finalization runbook                                |

## Security and compliance

| Doc                                                                        | Purpose                 |
| -------------------------------------------------------------------------- | ----------------------- |
| [security/00_security_checklist.md](security/00_security_checklist.md)     | Security checklist      |
| [security/AGENT_AND_REPO_SECURITY.md](security/AGENT_AND_REPO_SECURITY.md) | Agent and repo security |
| [security/CURSOR_DATA_BOUNDARY.md](security/CURSOR_DATA_BOUNDARY.md)       | Cursor data boundary    |

## Agent and handoff

| Doc                                                                                                              | Purpose                                                                                                 |
| ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| [../AGENTS.md](../AGENTS.md)                                                                                     | Agent permission and when agents use your browser (repo root)                                           |
| [AGENT_PROMPT_DECISION_TREE.md](AGENT_PROMPT_DECISION_TREE.md)                                                   | Agent prompt decision tree                                                                              |
| [AGENT_SYSTEM.md](AGENT_SYSTEM.md)                                                                               | Agent system and capabilities                                                                           |
| [AGENT_PROMPTS.md](AGENT_PROMPTS.md)                                                                             | Agent prompts index                                                                                     |
| [HANDOFF_PROMPT_NEW_AGENT.md](HANDOFF_PROMPT_NEW_AGENT.md)                                                       | Handoff prompt for new agent                                                                            |
| [status/HANDOFF_FOR_NEW_AGENT_202602.md](status/HANDOFF_FOR_NEW_AGENT_202602.md)                                 | Situation for new agent (fix everything / takeover)                                                     |
| [status/PLAN_AGENT_ENTRY.md](status/PLAN_AGENT_ENTRY.md)                                                         | Agent entry plan                                                                                        |
| [status/INDEX_REPORTS.md](status/INDEX_REPORTS.md)                                                               | Index of reports and status files                                                                       |
| [../.cursor/plans/ao_agent_pp_prompt_conversion.plan.md](../.cursor/plans/ao_agent_pp_prompt_conversion.plan.md) | AO Agent PP Prompt Conversion: -pp / /pp setup; remove OpenClaw from session-start; create AO PP prompt |

## Subfolders

| Folder                               | Purpose                                                               |
| ------------------------------------ | --------------------------------------------------------------------- |
| [guides/](guides/)                   | User and Cursor guides (quick-start, SHOPIFY_CURSOR_USAGE_GUIDE)      |
| [launch/](launch/)                   | Launch checklist and store readiness                                  |
| [status/](status/)                   | Deploy log, pending-approval, audits, reports                         |
| [security/](security/)               | Security checklist and boundaries                                     |
| [knowledge-base/](knowledge-base/)   | KB articles (Shopify, GitHub, automation)                             |
| [business-plan/](business-plan/)     | Business plan and financial model                                     |
| [decisions/](decisions/)             | ADRs (e.g. Shopify integration approach)                              |
| [expert-analyses/](expert-analyses/) | Expert audit outputs                                                  |
| [screenshots/](screenshots/)         | Screenshot output dir (content gitignored; see screenshots/README.md) |

## Other

| Doc                                              | Purpose                                  |
| ------------------------------------------------ | ---------------------------------------- |
| [HOOKS.md](HOOKS.md)                             | Git hooks (pre-commit; Windows-oriented) |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md)         | Troubleshooting                          |
| [CODING_STANDARDS.md](CODING_STANDARDS.md)       | Coding standards                         |
| [CODE_REVIEW_PROCESS.md](CODE_REVIEW_PROCESS.md) | Code review process                      |
| [MANUFACTURING.md](MANUFACTURING.md)             | Manufacturing workflow                   |
| [MONITORING.md](MONITORING.md)                   | Performance and health monitoring        |
| [PROJECT_MANAGEMENT.md](PROJECT_MANAGEMENT.md)   | Branching and task workflow              |
