# Pending approval (store-affecting changes)

**No pending changes.** This file is overwritten by the agent when there are changes waiting for your approval. After you approve and the agent applies, it is cleared again.

---

## When there are pending changes, the agent will fill in:

- **Summary:** What will change (e.g. "Add product X", "Theme: update homepage hero").
- **Preview:** Dry-run output (products) or theme dev URL + diff summary (theme).
- **To approve:** Reply in Cursor chat with "approve", "yes", or "looks good". The agent will then apply and append to [deploy-log.md](deploy-log.md).

Run **Tasks → Open pending approval** to open this file, or open it from the file tree.
