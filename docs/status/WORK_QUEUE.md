# Work Queue (Canonical)

Single source of truth for active execution. This queue is compression-first and links to existing docs instead of duplicating workflows.

## P0

- [x] Restore missing `codeql.yml` so `scripts/verify-pipeline.ps1` and workflow docs are consistent.
- [x] Add project-scoped `.cursor/mcp.json` with secret-free MCP config (`envmcp` + `.env.local`).
- [x] Deploy non-overlapping agent roster in `.cursor/agents/` and document it in `docs/AGENT_TEAM.md`.
- [x] Keep marker current in `docs/status/PP_AUDIT_MARKER.md`.
- [x] Harden `ci.yml` schema mutation guard for non-push events and full-history diff context.

## P1

- [x] Align legacy GitHub setup guidance with main-only strategy (`docs/SETUP_GITHUB.md`).
- [x] Align branch protection check names in `.github/settings.optimization.md`.
- [x] Point onboarding to this queue (`NEXT_STEPS.md`).
- [x] Refresh worktree/branch inventory drift (`docs/status/WORKTREE_INVENTORY.md`, `docs/status/BRANCH_INVENTORY.md`).
- [x] Gate `shopify-sync.yml` so CI push/schedule are preview-only and write apply is explicit manual dispatch.
- [x] Compress Shopify docs/scripts guidance onto canonical sync + preview/approval flow (`docs/UPDATE_SHOPIFY_FROM_CURSOR.md`, `scripts/README.md`).

## P2

- [ ] Clean residual stale references in older audit docs only when touched by active work.

## Approval Gates (Must Ask First)

- Shopify writes (theme publish/push, product sync apply, Shopify Admin save actions)
- Printful uploads/mockups/orders
- Cloudflare DNS/zone/redirect/workers writes
- GitHub rulesets or branch protection changes
- Merge to `main` or direct push to `main`

## References

- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/INDEX_REPORTS.md`
- `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`
- `OPERATOR_RUNBOOK.md`
