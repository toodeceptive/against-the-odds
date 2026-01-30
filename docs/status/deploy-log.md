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

_(Further entries will appear below as theme deploys and product syncs are applied.)_
