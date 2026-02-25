# Deploy and rollback log

Append-only log for store-affecting changes. Each entry: **Timestamp** (ISO), **Action**, **Branch/commit**, **Summary**, **Rollback**.

**Format (copy for new entries):**

```
## YYYY-MM-DDTHH:mm:ssZ — Action
- **Branch/commit:** `main` @ abc123 (or `shopify-theme` @ def456)
- **Summary:** e.g. Added product X; Updated section Y
- **Rollback:** Revert commit abc123 and push | Restore data/products/previous.json and run sync-products.ps1 | Theme: Shopify Admin → theme card → Actions → Reset to last commit
```

---

## 2026-01-30 — Page bio update (index.html)

- **Branch/commit:** `main` (pending commit)
- **Summary:** Updated hero bio on index.html: refreshed AO brand copy and added verification line to prove system workflow.
- **Rollback:** Revert commit that touches index.html and push.

---

## 2026-02 — Theme brand + CI workflow resilience (no store deploy)

- **Branch/commit:** `main` @ 8d36600 (theme), 58711f8 (CI)
- **Summary:** Theme: AO brand drip/magenta/teal CSS, store-update docs, theme-preview-mock. CI: quality-check (test:unit required, coverage/audit optional); ci (test:unit only, trivy/sarif continue-on-error); shopify-sync skips gracefully when secrets missing; sync-theme-branch token + continue-on-error.
- **Rollback:** Revert commits 8d36600 and 58711f8 and push; re-run workflows. No live store deploy from these commits.

---

## 2026-02-07 — Theme + store copy (AO Hero, About, Footer; preview popup fix)

- **Branch/commit:** `main` (local changes not yet pushed to origin)
- **Summary:** Theme: added layout/theme.liquid, config/settings_data.json, templates/index.json; sections ao-hero, ao-about, ao-footer; snippet ao-footer-brand. Store copy: docs/launch/STORE_COPY_AND_CONTENT.md, APPLY_STORE_COPY_AND_IMAGES.md. Preview: scripts/open-preview-popup.ps1 opens pending-approval in Cursor (not Invoke-Item) and opens browser to theme dev URL after 12s. Theme push to Shopify was attempted but required interactive login (verification code); deploy is ready once you run `.\scripts\shopify\update-theme.ps1` and complete auth, or set SHOPIFY_CLI_THEME_TOKEN in .env.local.
- **Rollback:** Theme: Shopify Admin → Online Store → Themes → theme card → Actions → Reset to last commit. Repo: revert commits that add layout/, sections/, templates/, scripts/open-preview-popup.ps1, and the launch docs.

---

## 2026-02-07 — Finalize theme + static mock; theme push pending login

- **Branch/commit:** `main` (local)
- **Summary:** Static mock (theme-preview-mock.html) updated to match real Shopify homepage: same hero (THE ODDS WERE NEVER EVEN, subhead, slogan, Join the drop list), same footer (tagline, bio, copyright). Removed large “style mock only” banner; one small “Local preview only” note at bottom. Theme push to Shopify was run but requires one-time login: open the link shown when you run `.\scripts\shopify\update-theme.ps1`, complete auth, then the push will finish. To avoid login next time, set SHOPIFY_CLI_THEME_TOKEN in .env.local (see docs/CREDENTIALS_SETUP.md).
- **Rollback:** Revert changes to docs/guides/theme-preview-mock.html. Theme: Shopify Admin → theme card → Reset to last commit if needed.

_(Further entries will appear below as theme deploys and product syncs are applied.)_
