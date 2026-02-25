# Shopify scripts

**Purpose**: Theme and store operations: theme pull/dev, product sync, connection tests, setup. Single theme path convention for this repo.

---

## Theme path convention

All scripts default to the same theme directory:

- **Path**: `src/shopify/themes/aodrop-theme`
- Scripts accept an optional `-ThemePath` (or equivalent) parameter; when omitted, they resolve repo root and use the path above.

---

## Main scripts

| Script                           | Purpose                                                                  |
| -------------------------------- | ------------------------------------------------------------------------ |
| `theme-pull.ps1`                 | Pull theme from store (Shopify CLI or REST fallback) into `aodrop-theme` |
| `theme-dev.ps1`                  | Run `shopify theme dev` for local preview                                |
| `theme-pull-and-preview.ps1`     | Pull then start theme dev                                                |
| `sync-products.ps1`              | Sync product data from `data/products/` to store (Admin API)             |
| `test-connection.ps1`            | Verify Shopify store connection                                          |
| `finish-setup.ps1`               | Guided setup (env, theme path, credentials)                              |
| `update-theme.ps1`               | Push theme to store (after preview/approval)                             |
| `merge-brand-into-theme.ps1`     | Merge AO brand customization into theme                                  |
| `copy-brand-images-to-theme.ps1` | Copy brand images to theme assets                                        |

Other scripts under `scripts/shopify/` and `scripts/shopify/browser/` support auth, token extraction, and store verification.

---

## Daily flow and runbook

See [OPERATOR_RUNBOOK.md](../../OPERATOR_RUNBOOK.md) for daily checks, theme dev shortcut (Ctrl+Alt+T), and deploy-log discipline for store-affecting changes.
