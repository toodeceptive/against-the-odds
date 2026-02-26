# Agent workflow: Cursor → GitHub → Shopify

Step-by-step for fulfilling store change requests (products, theme) with preview and approval. Reference: [.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md](../.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md) (single plan; open in Cursor and use Build); pipeline implemented here and in rules.

---

## Product listing flow

1. **Request**: User asks to add or change a product (e.g. "list this product on my page").
2. **Create/edit**: Create or update JSON in `data/products/` per [Shopify Product resource](https://shopify.dev/docs/api/admin-rest/latest/resources/product). Use [data/products/example-hoodie.json](data/products/example-hoodie.json) as schema reference (title, body_html, vendor, product_type, tags, status, variants, images, options).
3. **Preview**: Run `.\scripts\shopify\sync-products.ps1 -DryRun` and capture the output.
4. **Snapshot**: Write [docs/status/pending-approval.md](status/pending-approval.md) with: Summary (what will change), the dry-run output, and "To approve: reply in Cursor chat with 'approve' or 'yes'." **Then run `.\scripts\open-pending-approval.ps1`** from repo root so the file opens in Cursor automatically for the user. Tell the user: "I've opened the pending changes for you. When ready, say 'approve' in this chat."
5. **Approval**: Wait for explicit user confirmation in chat (e.g. "approve", "yes", "looks good").
6. **Apply**: Run `.\scripts\shopify\sync-products.ps1` (no -DryRun); commit and push product JSON to the connected branch (e.g. `main`). If CI is configured, product sync may also run on push.
7. **Log**: Append an entry to [docs/status/deploy-log.md](status/deploy-log.md): timestamp, action "product sync", branch/commit, summary (e.g. "Added product X"), rollback (e.g. "Restore data/products/previous.json and run sync-products.ps1"). Clear [docs/status/pending-approval.md](status/pending-approval.md) (write "No pending changes" placeholder).

---

## Theme / page flow

1. **Request**: User asks for theme or page changes (e.g. "update the homepage", "add this section").
2. **Edit**: Edit files under `src/shopify/themes/aodrop-theme/` (layout, sections, templates, assets, etc.). Ensure structure matches [Shopify theme architecture](https://shopify.dev/docs/storefronts/themes/architecture). Use Theme Check (Shopify Liquid extension) and `.theme-check.yml` for lint; run `.\scripts\shopify\theme-check.ps1` for CLI validation.
3. **Preview**: Either (a) run `shopify theme dev --store=aodrop.com --path=src/shopify/themes/aodrop-theme` and get the preview URL, or (b) summarize the diff (e.g. `git diff src/shopify/themes/aodrop-theme`).
4. **Snapshot**: Write [docs/status/pending-approval.md](status/pending-approval.md) with: Summary (what will change), theme dev URL or diff summary, and "To approve: reply in Cursor chat with 'approve' or 'yes'." **Then run `.\scripts\open-preview-popup.ps1`** (or `.\scripts\start-theme-preview.ps1`) from repo root. That opens the approval file in Cursor, opens the AO preview in the browser (static mock right away; live theme when dev server is ready), and starts theme dev in a new window. Tell the user: "I've opened the pending changes and preview. When ready, say 'approve' in this chat."
5. **Approval**: Wait for explicit user confirmation in chat (e.g. "approve", "yes", "looks good").
6. **Apply**: Commit and push to `main`. If theme-branch CI is configured, it will update `shopify-theme`; Shopify deploys from the connected branch. Alternatively, run `.\scripts\shopify\update-theme.ps1` for direct CLI push (still requires approval first).
7. **Log**: Append an entry to [docs/status/deploy-log.md](status/deploy-log.md): timestamp, action "theme deploy", branch/commit, summary, rollback (e.g. "Revert commit abc123 and push" or "Shopify Admin → theme card → Actions → Reset to last commit"). Clear [docs/status/pending-approval.md](status/pending-approval.md) (write "No pending changes" placeholder).

---

## Product with uploads from your PC

When you ask to add or change a product using **images, files, or descriptions from anywhere on your PC** (paths you provide or files you share in chat), the agent may use either path below. Permission to read those files and use uploads is granted when you request the store change or share them in chat.

### JSON path (bulk / catalog)

1. **Agent reads** the files you provide (paths or uploads): images, copy, specs.
2. **Images**: Agent uploads images to Shopify (e.g. via Admin API / Files) or places them in repo and uses public URLs; then adds image URLs to the product JSON.
3. **Create/edit** `data/products/*.json` with title, body_html, variants, and image URLs per [Shopify Product resource](https://shopify.dev/docs/api/admin-rest/latest/resources/product).
4. **Preview**: Run `.\scripts\shopify\sync-products.ps1 -DryRun`; capture output.
5. **Snapshot** → Write [docs/status/pending-approval.md](status/pending-approval.md), then run `.\scripts\open-pending-approval.ps1` so the file opens automatically → you approve in chat → **Apply** (sync without -DryRun) → **Log** to [docs/status/deploy-log.md](status/deploy-log.md).

### Browser path (one-off with uploads)

1. **Agent uses your browser** (Cursor browser MCP): navigates to Shopify Admin → Products → Add product.
2. Agent (or you with agent guidance) fills title, description, and **attaches files from your PC** (e.g. images you provided).
3. **Before Save**: Agent stops and asks "does this look good?" You confirm in chat (e.g. "approve", "yes").
4. **Apply**: Agent or you clicks Save. Agent then appends [docs/status/deploy-log.md](status/deploy-log.md) with summary and rollback (e.g. "Delete product X in Shopify Admin → Products" or revert steps).

---

## Rollback

- **Theme**: In Shopify Admin → Online Store → Themes → on the theme card → **Actions** → **Reset to last commit**. Or revert the commit on `shopify-theme` (or `main`) and push.
- **Products**: Revert the product JSON file(s) in the repo and run `.\scripts\shopify\sync-products.ps1` again; or fix in Shopify Admin and optionally export back to repo.

---

## Rules (Cursor)

- **Preview before apply**: Never run sync without `-DryRun` or push theme/product changes to the live store without showing a preview and getting user approval. See [.cursor/rules/shopify-preview-approval.mdc](../.cursor/rules/shopify-preview-approval.mdc).
- **Snapshot before approval**: Before asking for approval, write the preview (dry-run output or theme URL + diff) to [docs/status/pending-approval.md](status/pending-approval.md). **Then run `.\scripts\open-preview-popup.ps1`** (or `.\scripts\start-theme-preview.ps1`) so the approval file opens in Cursor and the preview opens in the browser (static mock + live theme when server is ready). After apply, clear the file (write "No pending changes" placeholder).
- **Deploy log**: Every store-affecting change (theme push, product sync, one-off browser change) must have an entry in [docs/status/deploy-log.md](status/deploy-log.md) with timestamp, action, branch/commit, summary, and **rollback steps** (e.g. revert commit, restore JSON and sync, or "Revert in Shopify Admin: …"). No secrets in the log.
- **Credentials**: Secrets only in `.env.local` (local) or GitHub Actions secrets; never commit or log. See [.cursor/rules/env-credentials.mdc](../.cursor/rules/env-credentials.mdc).
- **Browser-first, no headless**: For live store changes use official Admin API (product sync with approval) or the user's browser (Cursor browser MCP) with you watching; do not use unattended headless automation of Shopify Admin (ToS). See [.cursor/rules/use-user-browser.mdc](../.cursor/rules/use-user-browser.mdc), [.cursor/rules/shopify-preview-approval.mdc](../.cursor/rules/shopify-preview-approval.mdc), and [docs/security/00_security_checklist.md](security/00_security_checklist.md).

---

## Preview before commit (see work live in Cursor/browser)

To see your Shopify theme changes **live before committing**:

1. **Start the theme dev server**: In Cursor, press **Ctrl+Alt+T** or **Run Task** → **Shopify: Theme Dev (preview before commit)**. Or run in terminal: `.\scripts\shopify\theme-dev.ps1`. Scripts load `.env.local` and install Shopify CLI if missing.
2. **Open the preview URL**: When the server starts, a preview URL appears in the terminal (e.g. `https://...trycloudflare.com` or `http://127.0.0.1:9292`). The browser may open it automatically. Otherwise:
   - **Click the URL** in the terminal (most terminals make it clickable), or
   - **Cursor Simple Browser**: **View → Simple Browser**, then paste the URL.
3. Edit theme files under `src/shopify/themes/aodrop-theme/`; the preview hot-reloads. When satisfied, commit and push (after approval per the rule above).

No "Go Live" or commit needed to preview—the dev server shows your local changes live.

---

## Quick reference

| Goal                                | Command or action                                                                                                                                                                                                                                                            |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Theme preview (before commit)**   | Tasks → **Shopify: Theme Dev**; then open URL from terminal in browser or View → Simple Browser                                                                                                                                                                              |
| Product sync (preview)              | `.\scripts\shopify\sync-products.ps1 -DryRun`                                                                                                                                                                                                                                |
| Product sync (apply)                | `.\scripts\shopify\sync-products.ps1`                                                                                                                                                                                                                                        |
| Theme dev (terminal)                | `.\scripts\shopify\theme-dev.ps1`                                                                                                                                                                                                                                            |
| Theme push (apply)                  | `.\scripts\shopify\update-theme.ps1`                                                                                                                                                                                                                                         |
| **Open pending approval**           | Tasks → **Open pending approval** or **Ctrl+Alt+P** (opens docs/status/pending-approval.md). After writing the file, agent runs `.\scripts\open-preview-popup.ps1` so Cursor + browser + theme dev all open.                                                                 |
| **Start theme preview (full flow)** | `.\scripts\open-preview-popup.ps1` or `.\scripts\start-theme-preview.ps1` — opens approval file in Cursor, AO preview in browser (static + live when server ready), theme dev in new window. Set `SHOPIFY_CLI_THEME_TOKEN` in `.env.local` for non-interactive server start. |
| **Apply after approval (theme)**    | Run `.\scripts\shopify\update-theme.ps1`; append to [deploy-log.md](status/deploy-log.md); clear [pending-approval.md](status/pending-approval.md) (write "No pending changes").                                                                                             |
| Pending snapshot                    | [docs/status/pending-approval.md](status/pending-approval.md)                                                                                                                                                                                                                |
| Deploy log                          | [docs/status/deploy-log.md](status/deploy-log.md)                                                                                                                                                                                                                            |
| Pipeline verification               | `npm run verify:pipeline` or `.\scripts\verify-pipeline.ps1`                                                                                                                                                                                                                 |

**Visual usage guide:** [docs/guides/SHOPIFY_CURSOR_USAGE_GUIDE.md](guides/SHOPIFY_CURSOR_USAGE_GUIDE.md) (diagrams and step-by-step). For a printable/downloadable version: open [docs/guides/SHOPIFY_CURSOR_USAGE_GUIDE.html](guides/SHOPIFY_CURSOR_USAGE_GUIDE.html) in a browser and use **Print → Save as PDF**.

See also: [docs/UPDATE_SHOPIFY_FROM_CURSOR.md](UPDATE_SHOPIFY_FROM_CURSOR.md), [OPERATOR_RUNBOOK.md](../../OPERATOR_RUNBOOK.md).
