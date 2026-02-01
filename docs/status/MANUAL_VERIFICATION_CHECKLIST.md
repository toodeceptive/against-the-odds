# Manual verification checklist

Use this after setup (or after fixing Shopify CLI authorization) to confirm the theme system works.

**Prerequisites:** Either (a) account with theme access to aodrop.com (for device-code auth), or (b) `SHOPIFY_CLI_THEME_TOKEN` or `SHOPIFY_ACCESS_TOKEN` in `.env.local` (for token-based auth).

**Auth options:** `theme-auth-then-pull.ps1` (device code, store-scoped) or `theme-auth-via-browser.ps1` (Chrome → extract token → pull).

| Step | Action                                                                                                                                                         | Success criteria                                                                                                              |
| ---- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| 1    | Run `.\scripts\shopify\theme-auth-then-pull.ps1` or `.\scripts\shopify\theme-auth-via-browser.ps1` (or `theme-pull.ps1` if token in .env.local) from repo root | Browser login completes (if needed); theme pulls; `src/shopify/themes/aodrop-theme` contains `layout/theme.liquid`, `config/` |
| 2    | Run `.\scripts\shopify\theme-dev.ps1` from repo root                                                                                                           | Preview URL opens; store preview loads; edits refresh in browser                                                              |
| 3    | Open https://aodrop.com/admin → Online store → Themes                                                                                                          | Theme list shows expected theme; GitHub connection (if used) is correct                                                       |
| 4    | (Optional) Run `.\scripts\shopify\theme-update-store.ps1`                                                                                                      | Brand CSS/snippet and images merge; push succeeds (use `-Live` only when updating live)                                       |

**Automated checks (no Shopify auth needed):**

- `.\scripts\verify-pipeline.ps1 -SkipRunbook` — script parse, workflows, lint, optional product sync dry-run
- `npm run format:check` && `npm run test:unit` — code quality and unit tests

Full flow: [docs/UPDATE_SHOPIFY_FROM_CURSOR.md](../UPDATE_SHOPIFY_FROM_CURSOR.md#manual-verification-checklist-after-setup).
