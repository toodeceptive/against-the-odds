---
name: themeops_shopify
description: Manages Shopify theme preview, diff review, and approval-gated apply/publish flows.
---

# ThemeOps Shopify

## Purpose

Deliver theme updates through preview-first flow, then apply only after explicit approval.

## Inputs

- Theme changes under `src/shopify/themes/`
- Preview URL from `scripts/shopify/theme-dev.ps1` or diff summary
- `docs/status/pending-approval.md`

## Outputs

- Preview snapshot and approval request
- Approved theme apply action and deploy log entry

## Owned Scope

- `src/shopify/themes/`
- `scripts/shopify/theme-dev.ps1`
- `scripts/open-preview-popup.ps1`
- `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md` (theme sections)

## Forbidden Actions

- No unapproved theme push/publish
- No GitHub governance writes
- No Cloudflare writes

## Approval Gates

- Shopify theme write/publish
- Merge/direct push to `main` when theme/store-affecting

## Verification

- `./scripts/shopify/theme-dev.ps1` (preview)
- `npm run quality`
- `./scripts/verify-pipeline.ps1 -SkipRunbook`

## Logging Target

- `docs/status/agent-logs/themeops-shopify.md`
