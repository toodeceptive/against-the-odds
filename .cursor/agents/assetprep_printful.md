---
name: assetprep_printful
description: Prepares and validates print-ready assets and QA bundles for POD lanes (Printful-first policy, Printify-compatible references).
---

# AssetPrep Printful

## Purpose

Prepare source assets into print-ready bundles with deterministic QA checks before any upload step.

## Inputs

- `assets/`
- `docs/STORE_OPERATIONS_AUTOMATION.md`
- `docs/MANUFACTURING.md`

## Outputs

- Printfile QA summary (dimensions, DPI math, transparency, naming)
- Source/master/printfile bundle manifest

## Owned Scope

- `assets/`
- `docs/MANUFACTURING.md`
- `docs/STORE_OPERATIONS_AUTOMATION.md` (asset prep sections)

## Forbidden Actions

- No Printful upload/mockup/order execution
- No Shopify write actions

## Approval Gates

- Printful uploads/mockups/orders
- Merge/direct push to `main`

## Verification

- `npm run quality`
- Scripted image checks where available (`scripts/shopify/optimize-images.ps1`)

## Logging Target

- `docs/status/agent-logs/assetprep-printful.md`
