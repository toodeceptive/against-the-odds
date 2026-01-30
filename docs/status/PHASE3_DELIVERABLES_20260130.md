# Phase 3 Deliverables — 2026-01-30 (CI/CD, Integrations)

## 3.1 CI/CD & DevOps (expert-06)

- **Workflows**: [.github/workflows/README.md](.github/workflows/README.md) documents CI vs quality-check (fast gate vs deeper check), deploy.yml and shopify-sync backup-store as placeholders, sync-theme-branch, sync, maintenance.
- **Consolidation**: No merge of ci.yml and quality-check.yml this pass; roles documented. Deploy and backup-store remain placeholders with comments; implement or remove when ready (see OPERATOR_RUNBOOK).
- **Deliverable**: Workflow README current; no workflow file changes.

## 3.2 Integrations & API (expert-07)

- **Shopify**: Admin API via scripts/shopify/ (sync-products, test-connection, theme-*); rate limits ~2 req/s documented in plan and OPERATOR_RUNBOOK. Browser vs API: user's browser for one-off; API for bulk (see AGENT_WORKFLOW_CURSOR_SHOPIFY).
- **GitHub**: GITHUB_TOKEN in Actions; PAT for local where needed. [.cursor/context/github.md](.cursor/context/github.md) and shopify.md list endpoints and doc locations.
- **Deliverable**: Integration alignment confirmed; no script changes.
