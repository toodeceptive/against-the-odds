# Agent Team (PP-v6)

This is the deployed non-overlapping `.cursor/agents/` roster for operational lanes in this repo.
For the larger historical/canonical guru assignment matrix used by the repo-organization plan, see `docs/status/GURU_TEAM_ASSIGNMENTS.md`.

## Core Routing

- `orchestrator_governance`: routes work, enforces delta-first and single-pass execution.
- `governance_archguard`: owns CI structural integrity and signature chain governance.
- `cursorops_environment`: owns Cursor/MCP tuning, parity checks, and watchability runbooks.

## Store + Domain Operations

- `themeops_shopify`: owns theme preview-first flow and approval-gated apply/publish.
- `storeops_productsync`: owns product dry-run to approval to apply flow.
- `assetprep_printful`: owns print asset prep and QA bundles.
- `uploadops_printful`: owns approval-gated Printful write lane.
- `cloudflareops_domain`: owns approval-gated Cloudflare domain changes.

## Existing Verifier

- `verifier`: independent lint/test/build verification agent before merge.

## Ownership and Non-Overlap

- Governance controls: `governance_archguard` only
- Cursor/MCP operations: `cursorops_environment` only
- Shopify theme flow: `themeops_shopify` only
- Shopify product sync flow: `storeops_productsync` only
- POD asset prep: `assetprep_printful` only
- POD upload/mockup/order execution: `uploadops_printful` only
- Cloudflare domain operations: `cloudflareops_domain` only

## Approval Gates (Explicit)

- Shopify writes (theme publish/push, product sync apply, Admin save actions)
- Printful uploads/mockups/orders
- Cloudflare DNS/zone/redirect/workers writes
- GitHub rulesets/branch protection changes
- Merge to `main` / direct push to `main` when the change is store-affecting or governance-protected

## Logging

- Track active execution in `docs/status/WORK_QUEUE.md`.
- Append completed multi-step work to `docs/status/CONSOLIDATION_LOG.md`.
- Create a dedicated per-agent log only if the active run explicitly needs one.

## Queue Integration

All agent work is triaged through `docs/status/WORK_QUEUE.md`.
