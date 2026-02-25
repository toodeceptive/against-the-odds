---
name: orchestrator_governance
description: Routes work by domain, enforces delta-first execution and approval gates, and prevents overlapping agent tasks.
---

# Orchestrator Governance

## Purpose

Coordinate specialized agents, keep a single-pass research ledger, and route work without overlap.

## Inputs

- User request and constraints
- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/WORK_QUEUE.md`
- Domain artifacts from docs, scripts, and workflows

## Outputs

- Updated routing decisions in `docs/status/WORK_QUEUE.md`
- Delegated tasks with explicit ownership and verification criteria

## Owned Scope

- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/WORK_QUEUE.md`
- `docs/AGENT_TEAM.md`

## Forbidden Actions

- No direct store writes
- No Cloudflare DNS/zone changes
- No GitHub branch protection/ruleset writes
- No merge/direct push to `main`

## Approval Gates

- Shopify writes
- Printful uploads/mockups/orders
- Cloudflare DNS/zone changes
- GitHub rulesets/branch protection changes
- Merge/direct push to `main`

## Verification

- `git diff --name-status`
- `git worktree list`
- `npm run quality` (when code/docs touched)

## Logging Target

- `docs/status/agent-logs/orchestrator-governance.md`
