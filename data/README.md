# Data — Structure and Usage

**Purpose**: Source data for products, manufacturers, and samples. Product JSON here is the source for sync to Shopify via [scripts/shopify/sync-products.ps1](../scripts/shopify/sync-products.ps1). See [scripts/README.md](../scripts/README.md) and [OPERATOR_RUNBOOK.md](../OPERATOR_RUNBOOK.md).

---

## Layout

| Directory               | Purpose                                                                |
| ----------------------- | ---------------------------------------------------------------------- |
| **data/products/**      | Product JSON (e.g. example-hoodie.json). Source for repo → store sync. |
| **data/manufacturers/** | Manufacturer profiles (e.g. example-manufacturer.json).                |
| **data/samples/**       | Sample tracking data (e.g. .gitkeep; add sample records as needed).    |

---

## Schemas and examples

- **products**: Use `example-hoodie.json` as template; structure aligns with Shopify Admin API product representation where used by sync scripts.
- **manufacturers**: Use `example-manufacturer.json` as template; see [NEXT_STEPS.md](../NEXT_STEPS.md) and [docs/business-plan/04_ops_plan.md](../docs/business-plan/04_ops_plan.md) for usage.
- **Expert 9** (database/data) owns data schema and consistency per the final plan.

_Last updated: 2026-01-31_
