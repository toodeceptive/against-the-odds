# Version Policy

Schema and data-contract versioning. Required by structural integrity contract; see [AGENTS.md](../AGENTS.md).

## Principle

Schema or data-contract changes **must** bump the declared version. CI fails if structural files change without a version bump.

## Scope

- **data/products/\*.json** — Product schema (Shopify Product resource shape). Declare `schema_version` in each file or in a manifest.
- **data/manufacturers/\*.json** — Manufacturer schema.
- **schemas/** — Any formal JSON schema files (if added).

## How to Bump

1. Edit the schema or data contract.
2. Increment `schema_version` (e.g. `1` → `2`) in the affected file or in `infra/STRUCTURAL_STATE.json` metadata.
3. Run `.\scripts\infra\sign-structural-state.ps1` to regenerate STRUCTURAL_STATE and re-sign.
4. Commit the changed files plus updated `infra/STRUCTURAL_STATE.json` and `infra/STRUCTURAL_SIGNATURE.txt`.

## Current Schema Version

- **data/products** — `1` (implicit; example-hoodie.json is reference)
- **data/manufacturers** — `1` (implicit)

When adding `schema_version` to product JSON, use a top-level field:

```json
{
  "schema_version": 1,
  "title": "...",
  ...
}
```
