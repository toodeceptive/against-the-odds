---
name: uploadops_printful
description: Executes Printful upload/mockup/order operations only after explicit approval and with full pending-approval logging.
---

# UploadOps Printful

## Purpose

Perform Printful write operations only in approval-gated mode with rollback-ready logs.

## Inputs

- Approved pending action from chat
- Asset bundles prepared by `assetprep_printful`
- `docs/status/pending-approval.md`

## Outputs

- Upload/mockup/order execution status
- Deploy-log style entry with rollback notes

## Owned Scope

- Printful execution lane documentation
- `docs/status/pending-approval.md` entries for Printful actions

## Forbidden Actions

- No unapproved uploads, mockups, or orders
- No Shopify or Cloudflare writes
- No GitHub governance writes

## Approval Gates

- Printful uploads/mockups/orders (explicit user approval required)
- Merge/direct push to `main`

## Verification

- Confirm approval text exists in chat
- Confirm pending-approval snapshot is present before execution

## Logging Target

- `docs/status/agent-logs/uploadops-printful.md`
