# Cursor Plans — Index

**Purpose**: Single canonical plan for full repo organization and audit. All other plans have been consolidated into this one. Use [docs/AGENT_PROMPT_DECISION_TREE.md](docs/AGENT_PROMPT_DECISION_TREE.md) and [docs/status/PLAN_AGENT_ENTRY.md](docs/status/PLAN_AGENT_ENTRY.md) for entry and "which prompt when."

| Plan file                                     | Role                                                                | Status                                                                          |
| --------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| **FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md** | Full repo organization and audit (Phase 0 + Tracks A–G + Synthesis) | **Current** — the only plan; execute Phase 0 first, then tracks, then Synthesis |

**Entry**: Read [docs/status/PLAN_AGENT_ENTRY.md](docs/status/PLAN_AGENT_ENTRY.md) first; then Phase 0 per [prompts/PERFECT_EXECUTION_PROMPT.md](prompts/PERFECT_EXECUTION_PROMPT.md); then follow this plan for organization and audit.

**Reference (already implemented)**:

- Pipeline and preview-before-apply: [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md)
- Security and platform (browser-first, no headless): [.cursor/rules/use-user-browser.mdc](.cursor/rules/use-user-browser.mdc), [.cursor/rules/shopify-preview-approval.mdc](.cursor/rules/shopify-preview-approval.mdc), [docs/security/00_security_checklist.md](docs/security/00_security_checklist.md)

**Extensions**: [.cursor/settings.json](.cursor/settings.json) extensions.recommendations are a subset of [.cursor/extensions.json](.cursor/extensions.json); both are valid.
