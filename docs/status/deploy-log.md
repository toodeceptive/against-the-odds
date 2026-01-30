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

_(No deployments logged yet. Entries will appear below as theme deploys and product syncs are applied.)_
