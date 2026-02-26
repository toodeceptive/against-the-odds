# Work Queue (Canonical)

Single source of truth for active execution. This queue is compression-first and links to existing docs instead of duplicating workflows.

## P0

- [x] Restore missing `codeql.yml` so `scripts/verify-pipeline.ps1` and workflow docs are consistent.
- [x] Add project-scoped `.cursor/mcp.json` with secret-free MCP config (`envmcp` + `.env.local`).
- [x] Deploy non-overlapping agent roster in `.cursor/agents/` and document it in `docs/AGENT_TEAM.md`.
- [x] Keep marker current in `docs/status/PP_AUDIT_MARKER.md`.

## P1

- [x] Align legacy GitHub setup guidance with main-only strategy (`docs/SETUP_GITHUB.md`).
- [x] Align branch protection check names in `.github/settings.optimization.md`.
- [x] Point onboarding to this queue (`NEXT_STEPS.md`).
- [x] Refresh worktree/branch inventory drift (`docs/status/WORKTREE_INVENTORY.md`, `docs/status/BRANCH_INVENTORY.md`).

## P2

- [ ] Clean residual stale references in older audit docs only when touched by active work.

## P0 (Local Main Finalization - 2026-02-26 run)

- [x] Confirm repository is operating on `main` and execute full local verification matrix.
- [x] Install GitHub CLI locally and validate command availability.
- [x] Harden `scripts/github/verify-secrets.ps1` strict mode and fallback `gh` detection (`C:\Program Files\GitHub CLI\gh.exe`).
- [x] Run browser-admin checks in GitHub settings (`branches`, `rules`, `security_analysis`) using logged-in session.
- [x] Resolve stale local lock handles on `infra/STRUCTURAL_*` files and unblock rebase on `main`.
- [x] Re-run strict verification matrix and capture deterministic blocker evidence.
- [x] Revalidate Codacy MCP analyze path end-to-end (MCP reachable, CLI install repaired, per-file analyze pass).
- [x] Publish integration cost/value audit and optimal default stack (`docs/status/INTEGRATION_STACK_COST_VALUE_AUDIT_20260226.md`).
- [x] Generate and execute recursive prompts (`V6` + `V7` delta-only) for non-redundant closure.
- [ ] Complete GitHub CLI authentication and scope refresh (`repo`, `workflow`, `read:org`) for strict secrets closure.
- [x] Align/enforce branch protection or ruleset required checks for `main` per policy docs.
- [x] Restore strict runbook credentials in `.env.local` (`SHOPIFY_ACCESS_TOKEN`; optional `GITHUB_TOKEN`) and rerun strict runbook to exit `0`.
- [x] Regenerate valid structural signature payload (`infra/STRUCTURAL_SIGNATURE.txt`) and pass `ssh-keygen -Y verify`.

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
- `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`
- `OPERATOR_RUNBOOK.md`
- `docs/status/INTEGRATION_STACK_COST_VALUE_AUDIT_20260226.md`
