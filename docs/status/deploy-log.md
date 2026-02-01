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

_(Further entries will appear below as theme deploys and product syncs are applied.)_
