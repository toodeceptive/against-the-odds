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

- [x] Clean residual stale references in older audit docs when touched by active work (completed 2026-02-26: stale workflow badge reference and volatile script-count wording updated).
- [x] Harden verification reliability and cross-platform parsing (`scripts/debug/parse-all-ps1.ps1`, `scripts/github/verify-auth.ps1`, `scripts/shopify/test-connection.ps1`, `scripts/verify-pipeline.ps1`) (completed 2026-02-26).
- [x] Resolve GitHub CodeQL default-vs-advanced conflict (default setup disabled in repo security settings; advanced workflow retained) and upgrade `github/codeql-action` to `@v4` in `.github/workflows/codeql.yml` (completed 2026-02-26).
- [x] Harden Shopify theme-ID browser extraction reliability (`scripts/shopify/browser/get-theme-id.ps1`, `src/browser-automation/shopify-admin.js`) and add canonical cloud delta-first prompt routing (`prompts/CLOUD_GURU_PERFECTION_PROMPT_V7_DELTA_FIRST.md`, `docs/AGENT_PROMPT_DECISION_TREE.md`) (completed 2026-02-26).
- [x] Complete Shopify credential recovery and deterministic runbook verification (`scripts/shopify/browser/get-token-client-credentials.ps1`, `scripts/shopify/test-connection.ps1`, `scripts/run-runbook.ps1`; local `.env.local` updated with Shopify API key/secret/token/theme ID) (completed 2026-02-26).
- [x] Regenerate and validate structural integrity signature chain (`infra/STRUCTURAL_STATE.json`, `infra/STRUCTURAL_SIGNATURE.txt`, `infra/allowed_signers`, `infra/structural.pub`) to clear empty-signature risk before CI `arch_guard` verification (completed 2026-02-26).
- [x] Add and execute V8 project-wide delta perfection run (`prompts/CLOUD_GURU_PERFECTION_PROMPT_V8_PROJECT_WIDE_DELTA_MASTER.md`) with net-new remediations for secrets verification determinism and theme-branch sync failure visibility (`scripts/github/verify-secrets.ps1`, `.github/workflows/sync-theme-branch.yml`, `.github/workflows/README.md`) (completed 2026-02-26).
- [x] Add and execute local/main cloud-escalation run assets (`prompts/LOCAL_MAIN_GURU_PERFECTION_PROMPT_V1_CLOUD_ESCALATION.md`, `docs/status/LOCAL_MAIN_CLOUD_ESCALATION_EXECUTION_PACK_20260226.md`) for cloud-unresolvable blocker closure by local guru team (completed 2026-02-26).

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
