# Cursor → GitHub → Shopify: Visual Usage Guide

**Against The Odds (AO) store** — Edit in Cursor, preview live, push to GitHub, store updates. **New system (2026):** All tasks run from **repo root**; every store change uses **preview → snapshot to `docs/status/pending-approval.md` → you approve → apply → append to `docs/status/deploy-log.md`**. Products: JSON path (bulk) or browser path (one-off with uploads). No headless Admin automation; API or your browser only. See [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](../AGENT_WORKFLOW_CURSOR_SHOPIFY.md) and [OPERATOR_RUNBOOK.md](../../OPERATOR_RUNBOOK.md).

---

## System readiness (what runs automatically)

| Check                | What happens                                                                                                                                                                         |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Shopify CLI**      | If missing, `theme-pull` / `theme-dev` / `update-theme` **install it automatically** (`npm install -g @shopify/cli @shopify/theme`). No manual install needed.                       |
| **Store / theme ID** | Scripts **load `.env.local`** from repo root when present. Set `SHOPIFY_STORE_DOMAIN` (e.g. `aodrop.com`) and optionally `SHOPIFY_THEME_ID` there so you don’t pass them every time. |
| **One-time auth**    | Run `shopify auth login` once (select store). Required for theme pull and local preview.                                                                                             |
| **Theme folder**     | If `src/shopify/themes/aodrop-theme` is empty, run `.\scripts\shopify\theme-pull.ps1` once from repo root (CLI installs if needed; store from `.env.local`).                         |

---

## Preview system vs Update feature

```mermaid
flowchart TB
  subgraph preview_system [Preview system — see changes before commit]
    P1[Tasks → Shopify: Theme Dev]
    P2[Or Ctrl+Alt+T]
    P3[theme-dev.ps1: loads .env.local, ensures CLI]
    P4[Dev server starts]
    P5[Browser opens http://127.0.0.1:9292]
    P6[Or: View → Simple Browser, paste URL]
    P7[Edit theme files → hot reload]
    P1 --> P3
    P2 --> P3
    P3 --> P4
    P4 --> P5
    P4 --> P6
    P5 --> P7
    P6 --> P7
  end

  subgraph update_feature [Update feature — go live]
    U1[Option A: GitHub flow]
    U2[Commit and push to main]
    U2 --> U3[CI updates shopify-theme]
    U3 --> U4[Shopify deploys from branch]
    U1 --> U2

    U5[Option B: CLI push]
    U6[.\scripts\shopify\update-theme.ps1]
    U6 --> U7[Loads .env.local, ensures CLI]
    U7 --> U8[Push to dev or live theme]
    U5 --> U6
  end

  preview_system -.->|When satisfied| update_feature
```

- **Preview:** Run from repo root. No commit required; browser (or Simple Browser) shows live theme. CLI and store are resolved automatically.
- **Update:** After approval, either **commit and push** (GitHub → store) or run **`update-theme.ps1`** for direct CLI push.

---

## At a glance

```mermaid
flowchart LR
  subgraph edit [Edit in Cursor]
    A[Theme files]
    B[Product JSON]
  end
  subgraph preview [Preview before commit]
    C[Tasks: Shopify Theme Dev]
    D[Open URL in browser]
  end
  subgraph apply [Apply]
    E[You approve]
    F[Commit and push]
  end
  subgraph live [Live store]
    G[Shopify]
  end
  A --> C
  B --> C
  C --> D
  D --> E
  E --> F
  F --> G
```

---

## 1. Preview your theme before committing (see work live)

**Goal:** See Shopify theme changes in the browser without committing. Run the task from **repo root** so script paths resolve.

**Seamless:** Press **Ctrl+Alt+T** (after adding the keybinding once — see `docs/KEYBINDING_PENDING_APPROVAL.md`) to start the theme dev server; your browser opens the preview URL automatically when the server is ready.

```mermaid
sequenceDiagram
  participant You
  participant Cursor
  participant Terminal
  participant Browser

  You->>Cursor: Ctrl+Shift+P → Run Task
  You->>Cursor: Choose "Shopify: Theme Dev (preview before commit)"
  Cursor->>Terminal: Runs theme dev server
  Terminal->>You: Shows preview URL
  You->>Browser: Click URL or View → Simple Browser, paste URL
  You->>Cursor: Edit files under src/shopify/themes/aodrop-theme/
  Note over Cursor,Browser: Preview hot-reloads automatically
  You->>Cursor: When satisfied → commit and push (after approval)
```

| Step | Action                                                                                   |
| ---- | ---------------------------------------------------------------------------------------- |
| 1    | In Cursor: **Ctrl+Shift+P** (Mac: **Cmd+Shift+P**) → type **Run Task**                   |
| 2    | Select **Shopify: Theme Dev (preview before commit)**                                    |
| 3    | Wait for the preview URL in the terminal (e.g. `https://...` or `http://127.0.0.1:9292`) |
| 4    | **Click the URL** in the terminal, or **View → Simple Browser** and paste the URL        |
| 5    | Edit theme files; the preview updates live. No commit needed to preview.                 |

**One-time:** If the theme folder is empty, run `.\scripts\shopify\theme-pull.ps1` from repo root. The script installs Shopify CLI if missing and reads `SHOPIFY_STORE_DOMAIN` from `.env.local`; you only need to run `shopify auth login` once.

---

## 2. Product listing flow (add or change a product)

**Goal:** Add or update a product on the store from Cursor.

```mermaid
flowchart TD
  R[You: add/change product] --> J[Agent: create/edit JSON in data/products/]
  J --> P[Preview: sync-products.ps1 -DryRun]
  P --> S[Show you dry-run output]
  S --> A{You approve?}
  A -->|Yes| Run[Apply: sync-products.ps1]
  A -->|No| Stop[Stop]
  Run --> Push[Commit and push]
  Push --> Log[Append to deploy-log.md]
  Log --> Done[Product live on store]
```

| Step | Action                                                                                                                                                  |
| ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1    | Ask in Cursor (e.g. "list this product on my page")                                                                                                     |
| 2    | Agent creates/edits JSON in `data/products/` (see `data/products/example-hoodie.json`)                                                                  |
| 3    | **Preview:** Agent runs `.\scripts\shopify\sync-products.ps1 -DryRun` and shows output                                                                  |
| 4    | **Snapshot:** Agent writes summary + dry-run output to `docs/status/pending-approval.md`. You open it via **Tasks → Open pending approval** or in chat. |
| 5    | **Approve:** You confirm in chat (e.g. "yes", "approve")                                                                                                |
| 6    | **Apply:** Agent runs sync without `-DryRun`, commit and push; clears pending-approval                                                                  |
| 7    | **Log:** Agent appends entry to `docs/status/deploy-log.md` (timestamp, summary, rollback)                                                              |

**Product with uploads from your PC:** Agent can use **JSON path** (bulk: add image URLs to product JSON after you upload to Shopify/CDN, then dry-run → approve → sync) or **browser path** (one-off: agent uses your browser via Cursor MCP to add product in Admin and attach your files; you approve before Save). See AGENT_WORKFLOW_CURSOR_SHOPIFY.md.

---

## 3. Theme / page flow (change store pages)

**Goal:** Change theme or pages; preview, then go live.

```mermaid
flowchart TD
  R[You: theme/page change] --> E[Agent: edit src/shopify/themes/aodrop-theme/]
  E --> P[Preview: Theme Dev task or PR diff]
  P --> A{You approve?}
  A -->|Yes| Push[Commit and push to main]
  A -->|No| Stop[Stop]
  Push --> CI[CI updates shopify-theme branch]
  CI --> Shopify[Shopify deploys from branch]
  Shopify --> Log[Append to deploy-log.md]
```

| Step | Action                                                                                                                             |
| ---- | ---------------------------------------------------------------------------------------------------------------------------------- |
| 1    | Ask in Cursor for theme or page changes                                                                                            |
| 2    | Agent edits files under `src/shopify/themes/aodrop-theme/`                                                                         |
| 3    | **Preview:** Run **Tasks → Shopify: Theme Dev** (from repo root), open URL or review diff                                          |
| 4    | **Snapshot:** Agent writes summary + URL/diff to `docs/status/pending-approval.md`; you open via **Tasks → Open pending approval** |
| 5    | **Approve:** You confirm in chat                                                                                                   |
| 6    | **Apply:** Commit and push to `main`; CI updates `shopify-theme`; Shopify deploys                                                  |
| 7    | **Log:** Append to `docs/status/deploy-log.md` (timestamp, summary, rollback)                                                      |

---

## 4. Rollback

```mermaid
flowchart LR
  subgraph theme_rollback [Theme rollback]
    T1[Shopify Admin] --> T2[Online Store → Themes]
    T2 --> T3[Theme card → Actions]
    T3 --> T4[Reset to last commit]
  end
  subgraph product_rollback [Product rollback]
    P1[Revert JSON in repo] --> P2[Run sync-products.ps1]
  end
```

| What         | How                                                                                                                                           |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **Theme**    | Shopify Admin → Online Store → Themes → on theme card → **Actions** → **Reset to last commit**. Or revert commit on `shopify-theme` and push. |
| **Products** | Revert `data/products/*.json` in repo and run `.\scripts\shopify\sync-products.ps1`; or fix in Shopify Admin.                                 |

---

## 5. Quick reference

| Goal                              | Command or action                                                                                                                                       |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Theme preview (before commit)** | **Tasks** → **Shopify: Theme Dev** or **Ctrl+Alt+T**. CLI auto-installs if missing; `.env.local` loaded. Open URL in terminal or View → Simple Browser. |
| **Theme update (go live)**        | **GitHub:** Commit and push to `main`. **CLI:** `.\scripts\shopify\update-theme.ps1` (loads `.env.local`, ensures CLI).                                 |
| Pull theme into repo              | `.\scripts\shopify\theme-pull.ps1` (CLI auto-install, `.env.local` for store)                                                                           |
| Product sync (preview)            | `.\scripts\shopify\sync-products.ps1 -DryRun`                                                                                                           |
| Product sync (apply)              | `.\scripts\shopify\sync-products.ps1`                                                                                                                   |
| Theme dev (terminal)              | `.\scripts\shopify\theme-dev.ps1`                                                                                                                       |
| Theme push (apply)                | `.\scripts\shopify\update-theme.ps1`                                                                                                                    |
| **Open pending approval**         | **Ctrl+Alt+P** (add keybinding once — see `docs/KEYBINDING_PENDING_APPROVAL.md`) or **Tasks** → **Open pending approval**. Opens in same window.        |
| **Theme preview (dev server)**    | **Ctrl+Alt+T** (add keybinding once) or **Tasks** → **Shopify: Theme Dev**. Browser opens preview URL automatically.                                    |
| Pending snapshot                  | `docs/status/pending-approval.md`                                                                                                                       |
| Deploy log                        | `docs/status/deploy-log.md`                                                                                                                             |
| Pipeline verification             | `npm run verify:pipeline` or `.\scripts\verify-pipeline.ps1`                                                                                            |

---

## 6. Full pipeline (end-to-end)

```mermaid
flowchart TB
  subgraph cursor [Cursor]
    Agent[Agent / You]
    Edit[Edit theme and product JSON]
    Preview[Preview: dry-run or Theme Dev URL]
  end
  subgraph approval [Your approval]
    OK[You confirm]
  end
  subgraph github [GitHub]
    Main[main branch]
    ThemeBranch[shopify-theme branch]
    CI[CI: sync theme branch and product sync]
  end
  subgraph shopify [Shopify]
    Store[Live store]
  end
  subgraph audit [Audit]
    DeployLog[deploy-log.md]
  end
  Agent --> Edit
  Edit --> Preview
  Preview --> OK
  OK --> Agent
  Agent --> Main
  Main --> CI
  CI --> ThemeBranch
  CI --> Store
  ThemeBranch --> Store
  CI --> DeployLog
```

---

_Reference: [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](../AGENT_WORKFLOW_CURSOR_SHOPIFY.md), [docs/UPDATE_SHOPIFY_FROM_CURSOR.md](../UPDATE_SHOPIFY_FROM_CURSOR.md), [.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md](../../.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md). Last updated: 2026-02-01._
