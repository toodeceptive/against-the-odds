# Cursor Plans — Index

**Purpose**: Single canonical plan for full repo organization and audit. All other plans have been consolidated into this one. Use [docs/AGENT_PROMPT_DECISION_TREE.md](docs/AGENT_PROMPT_DECISION_TREE.md) and [docs/status/PLAN_AGENT_ENTRY.md](docs/status/PLAN_AGENT_ENTRY.md) for entry and "which prompt when."

| Plan file                                     | Role                                                                | Status                                                                          |
| --------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| **FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md** | Full repo organization and audit (Phase 0 + Tracks A–G + Synthesis) | **Current** — the only plan; execute Phase 0 first, then tracks, then Synthesis |
| **MASTER_1000_GURU_FULL_SYSTEM_OVERHAUL.plan.md** | Master 1,000 guru audit; full file inventory (~476 files); step-by-step overhaul | Reference — corrected counts (docs **141**, docs/status **77**); gitignored coverage/, etc. |
| **FULL_SYSTEM_AUDIT_AND_FIX_ADDENDUM.md**     | Exhaustive inventory, issues 13–30, U1–U14, plan insights           | Execute with FINAL plan                                                         |
| **GURU_1000_QA_AUDIT_AND_INSIGHTS.md**        | 20 dimensions, 1,000-QA audit, unaddressed issues, insights        | Reference for plan insights                                                     |

**Entry**: Read [docs/status/PLAN_AGENT_ENTRY.md](docs/status/PLAN_AGENT_ENTRY.md) first; then Phase 0 per [prompts/PERFECT_EXECUTION_PROMPT.md](prompts/PERFECT_EXECUTION_PROMPT.md); then follow this plan for organization and audit.

**Fix everything / takeover**: If the user has granted full dominion to fix the entire project, read [docs/status/HANDOFF_FOR_NEW_AGENT_202602.md](docs/status/HANDOFF_FOR_NEW_AGENT_202602.md) and [docs/status/PROMPT_FOR_NEW_AGENT.md](docs/status/PROMPT_FOR_NEW_AGENT.md) first, then execute this plan and the addendum.

**Reference (already implemented)**:

- Pipeline and preview-before-apply: [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md)
- Security and platform (browser-first, no headless): [.cursor/rules/use-user-browser.mdc](.cursor/rules/use-user-browser.mdc), [.cursor/rules/shopify-preview-approval.mdc](.cursor/rules/shopify-preview-approval.mdc), [docs/security/00_security_checklist.md](docs/security/00_security_checklist.md)

**Extensions**: [.cursor/settings.json](.cursor/settings.json) extensions.recommendations are a subset of [.cursor/extensions.json](.cursor/extensions.json); both are valid.
