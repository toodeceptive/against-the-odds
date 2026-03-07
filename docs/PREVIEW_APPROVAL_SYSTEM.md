# Preview & Approval System (Theme / Product Changes)

Single reference for the **preview-before-apply** flow. Product changes and theme changes use different preview helpers, but both must snapshot to `docs/status/pending-approval.md` and wait for approval before apply.

---

## Product changes

1. **Agent** prepares a dry run (for example `node scripts/shared/run-powershell.cjs scripts/shopify/sync-products.ps1 -DryRun`).
2. **Agent** writes [docs/status/pending-approval.md](status/pending-approval.md) with summary, dry-run output, and "To approve: say 'approve' in chat."
3. **Agent** runs from repo root:

   ```sh
   node scripts/shared/run-powershell.cjs scripts/open-pending-approval.ps1
   ```

4. **User** reviews the pending approval file in Cursor and says **"approve"** (or "yes" / "looks good") in chat.
5. **Agent** applies the product change, appends [docs/status/deploy-log.md](status/deploy-log.md), and clears [docs/status/pending-approval.md](status/pending-approval.md).

## Theme changes

1. **Agent** edits theme files and writes [docs/status/pending-approval.md](status/pending-approval.md) with summary and "To approve: say 'approve' in chat."
2. **Agent** runs from repo root:

   ```sh
   node scripts/shared/run-powershell.cjs scripts/open-preview-popup.ps1
   ```

   Or: `node scripts/shared/run-powershell.cjs scripts/start-theme-preview.ps1` (same effect), or **Tasks → Start theme preview (new window, desktop helper)**.

3. **User** sees:
   - **Cursor**: `pending-approval.md` opens (or refocuses).
   - **Browser**: AO preview opens (static mock immediately; live theme at `http://127.0.0.1:9292` when theme dev server is ready).
   - **New window**: Theme dev server runs (may prompt for Shopify login once if no token).
4. **User** says **"approve"** (or "yes" / "looks good") in chat.
5. **Agent** applies the theme change, appends [docs/status/deploy-log.md](status/deploy-log.md), and clears [docs/status/pending-approval.md](status/pending-approval.md).

---

## Making it seamless (no login prompt)

- Put **SHOPIFY_CLI_THEME_TOKEN** in `.env.local` so theme dev starts without asking to log in. `SHOPIFY_ACCESS_TOKEN` is for Admin API / REST flows instead. See [docs/CREDENTIALS_SETUP.md](CREDENTIALS_SETUP.md).
- Optional: set **PREVIEW_POPUP_MAX_WAIT_SECONDS** (e.g. `45`) to shorten the wait for the live server; default is 90.

---

## Scripts

| Script                        | Purpose                                                                                                            |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **open-preview-popup.ps1**    | Opens approval file in Cursor, static mock in browser, starts theme dev, then opens live URL when server responds. |
| **start-theme-preview.ps1**   | Calls `open-preview-popup.ps1` (single entry point for tasks/docs).                                                |
| **open-pending-approval.ps1** | Opens only `pending-approval.md` in Cursor (no browser). Use when no theme preview is needed.                      |

---

## Rules (agents)

- **Preview first**: Never push theme or run product sync without preview and user approval. See [.cursor/rules/shopify-preview-approval.mdc](../.cursor/rules/shopify-preview-approval.mdc).
- **Snapshot**: Always write pending-approval.md before asking for approval. For product changes run **open-pending-approval.ps1**; for theme changes, the cross-platform default is **Open pending approval** + **Shopify: Theme Dev**, while **open-preview-popup.ps1** / **start-theme-preview.ps1** remain desktop helper options.
- **After apply**: Log to deploy-log.md and clear pending-approval.md.

See [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](AGENT_WORKFLOW_CURSOR_SHOPIFY.md) for full product/theme flows and rollback.
