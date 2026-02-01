# Push approval — 2026-02-01

**Scope:** Preview system + update feature finalization; user guide visualization; CLI auto-install and `.env.local` loading.

---

## Changes in this push

| Area           | Files                                                                                                                                               | Summary                                                                                              |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Scripts**    | `scripts/shopify/Ensure-ShopifyCli.ps1` (new), `theme-pull.ps1`, `theme-dev.ps1`, `update-theme.ps1`                                                | Auto-install Shopify CLI if missing; load `.env.local` from repo root; invoke CLI via helper array.  |
| **User guide** | `docs/guides/SHOPIFY_CURSOR_USAGE_GUIDE.md`                                                                                                         | System readiness table; "Preview system vs Update feature" Mermaid diagram; quick reference updated. |
| **Docs**       | `docs/UPDATE_SHOPIFY_FROM_CURSOR.md`, `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`, `docs/guides/WORKFLOW_PIPELINE_VISUAL_GUIDE.md`, `scripts/README.md` | One-time setup and daily workflow updated; CLI auto-install and `.env.local` noted.                  |

---

## Verification (completed)

| Check            | Result                                                                                               |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| **ESLint**       | 0 errors (22 pre-existing warnings in other files; unchanged).                                       |
| **Prettier**     | All matched files pass after formatting the 3 edited docs.                                           |
| **Unit tests**   | `npm run test:unit` — 2 passed.                                                                      |
| **Script logic** | theme-pull/dev/update: load .env.local → ensure CLI → run command via `$ShopifyCmd`.                 |
| **Docs**         | SHOPIFY_CURSOR_USAGE_GUIDE has system readiness + Preview vs Update diagram; cross-links consistent. |

---

## Approval

**Approved for commit and push.** These changes are final and verified. Safe to commit from repo root and push to your branch.

Suggested commit message:

```
fix: finalize preview/update system; user guide visualization; CLI auto-install + .env.local

- Add scripts/shopify/Ensure-ShopifyCli.ps1; theme-pull, theme-dev, update-theme load .env.local and use it
- SHOPIFY_CURSOR_USAGE_GUIDE: system readiness table, Preview vs Update Mermaid diagram, quick ref
- UPDATE_SHOPIFY_FROM_CURSOR, AGENT_WORKFLOW_CURSOR_SHOPIFY, WORKFLOW_PIPELINE_VISUAL_GUIDE, scripts/README aligned
- Prettier on edited docs; unit tests pass
```

---

_Generated 2026-02-01. Delete or archive this file after push._
