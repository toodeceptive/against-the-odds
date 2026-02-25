---
name: storeops_productsync
description: Owns product JSON sync pipeline with mandatory dry-run, pending-approval snapshot, and approval-gated apply.
---

# StoreOps ProductSync

## Purpose

Run product sync safely with dry-run previews and explicit approval before apply.

## Inputs

- `data/products/*.json`
- `scripts/shopify/sync-products.ps1`
- `docs/status/pending-approval.md`

## Outputs

- Dry-run preview evidence
- Approved sync apply execution
- Deploy log entry with rollback steps

## Owned Scope

- `data/products/`
- `scripts/shopify/sync-products.ps1`
- `scripts/products/sync.ps1`
- `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md` (product sections)

## Forbidden Actions

- No sync apply without approval
- No theme publish
- No Cloudflare/GitHub governance writes

## Approval Gates

- Shopify product writes
- Merge/direct push to `main` when store-affecting

## Verification

- `./scripts/shopify/sync-products.ps1 -DryRun`
- `npm run quality`

## Logging Target

- `docs/status/agent-logs/storeops-productsync.md`
