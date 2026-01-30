# Cursor → GitHub → Shopify: Visual Usage Guide

**Against The Odds (AO) store** — Edit in Cursor, preview live, push to GitHub, store updates.

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

**Goal:** See Shopify theme changes in the browser without committing.

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

**One-time:** If the theme folder is empty, run `.\scripts\shopify\theme-pull.ps1` first (requires Shopify CLI and `shopify auth login`).

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

| Step | Action                                                                                 |
| ---- | -------------------------------------------------------------------------------------- |
| 1    | Ask in Cursor (e.g. "list this product on my page")                                    |
| 2    | Agent creates/edits JSON in `data/products/` (see `data/products/example-hoodie.json`) |
| 3    | **Preview:** Agent runs `.\scripts\shopify\sync-products.ps1 -DryRun` and shows output |
| 4    | **Approve:** You confirm (e.g. "yes", "apply")                                         |
| 5    | **Apply:** Agent runs sync without `-DryRun`, then commit and push                     |
| 6    | **Log:** Agent appends entry to `docs/status/deploy-log.md`                            |

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

| Step | Action                                                                            |
| ---- | --------------------------------------------------------------------------------- |
| 1    | Ask in Cursor for theme or page changes                                           |
| 2    | Agent edits files under `src/shopify/themes/aodrop-theme/`                        |
| 3    | **Preview:** Run **Tasks → Shopify: Theme Dev** and open URL, or review PR diff   |
| 4    | **Approve:** You confirm                                                          |
| 5    | **Apply:** Commit and push to `main`; CI updates `shopify-theme`; Shopify deploys |
| 6    | **Log:** Append to `docs/status/deploy-log.md`                                    |

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

| Goal                              | Command or action                                                                  |
| --------------------------------- | ---------------------------------------------------------------------------------- |
| **Theme preview (before commit)** | **Tasks** → **Shopify: Theme Dev** → open URL in terminal or View → Simple Browser |
| Product sync (preview)            | `.\scripts\shopify\sync-products.ps1 -DryRun`                                      |
| Product sync (apply)              | `.\scripts\shopify\sync-products.ps1`                                              |
| Theme dev (terminal)              | `.\scripts\shopify\theme-dev.ps1`                                                  |
| Theme push (apply)                | `.\scripts\shopify\update-theme.ps1`                                               |
| Deploy log                        | `docs/status/deploy-log.md`                                                        |
| Pipeline verification             | `npm run verify:pipeline`                                                          |

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

_Reference: [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](../AGENT_WORKFLOW_CURSOR_SHOPIFY.md), [.cursor/plans/cursor-github-shopify-pipeline.plan.md](../../.cursor/plans/cursor-github-shopify-pipeline.plan.md)_
