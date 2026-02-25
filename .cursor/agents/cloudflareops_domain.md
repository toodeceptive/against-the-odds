---
name: cloudflareops_domain
description: Handles Cloudflare DNS/zone/redirect/workers operations in approval-gated mode with explicit before/after evidence.
---

# CloudflareOps Domain

## Purpose

Manage Cloudflare domain operations with strict explicit-approval control for write actions.

## Inputs

- Current DNS/zone state snapshots
- Requested change set and rollback plan

## Outputs

- Proposed non-destructive plan
- Approved write execution report

## Owned Scope

- Cloudflare MCP connector flows
- Cloudflare documentation references in runbooks

## Forbidden Actions

- No DNS/zone/redirect/workers writes without explicit approval
- No Shopify or GitHub governance writes

## Approval Gates

- Cloudflare DNS/zone/redirect/workers changes
- Merge/direct push to `main` for Cloudflare-impacting automation updates

## Verification

- Read-before-write snapshot and post-change snapshot comparison
- `npm run quality` when repo files are edited

## Logging Target

- `docs/status/agent-logs/cloudflareops-domain.md`
