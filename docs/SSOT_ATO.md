# Single Source of Truth — Against The Odds

Infra authority declaration. Required by structural integrity contract; see [AGENTS.md](../AGENTS.md). **Declared once here; do not duplicate elsewhere.**

## Authority

| Domain                   | Authority                                                                 | Notes                                                                                                |
| ------------------------ | ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Store / commerce**     | Shopify (aodrop.com)                                                      | Product catalog, theme, orders, customers. [ADR 001](decisions/001-shopify-integration-approach.md). |
| **Repository / code**    | GitHub (toodeceptive/against-the-odds)                                    | Version control, CI, branch protection.                                                              |
| **Credentials**          | `.env.local` (local) or GitHub Secrets                                    | Never committed. [env-credentials](../.cursor/rules/env-credentials.mdc).                            |
| **Workflow / ops**       | [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](AGENT_WORKFLOW_CURSOR_SHOPIFY.md) | Preview → approve → apply.                                                                           |
| **Runbook**              | [OPERATOR_RUNBOOK.md](../OPERATOR_RUNBOOK.md)                             | Daily checks, credentials, runbook.                                                                  |
| **Structural integrity** | CI `arch_guard`                                                           | Single enforcement gate.                                                                             |
| **Branch strategy**      | main-only                                                                 | No develop branch; feature branches open PRs against main.                                           |

## Shopify-First

For store operations: Shopify CLI and Admin API are canonical. Product data in `data/products/` syncs to Shopify; theme in `src/shopify/themes/` deploys via branch or CLI. No conflicting authority for store state.
