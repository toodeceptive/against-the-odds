# Situation for new agent (2026-02)

**Prompt for new agent:** See **`docs/status/PROMPT_FOR_NEW_AGENT.md`** for a copy-paste prompt to start the next agent.

The user has given the new agent **full unrestricted approval and dominion over the entire project** to fix everything. This document explains the situation only. No limitations or instructions are imposed.

---

## Repo and branch state

- **Primary repo:** `C:\Users\LegiT\against-the-odds` on branch **main**.
- **Last commit on main:** `f3141ee` — "Finalize and close agent branches/workflows; handoff for new agent". Local main is in sync with **origin/main** (https://github.com/toodeceptive/against-the-odds.git).
- **Other local branches:** `feature/ao-brand-shopify-automation`, `cursor/main-project-setup-2bd1`, `handoff-doc-permissions-20260129` (latter exists only locally and has an associated worktree at mhx).
- **Remote-only branches:** `origin/shopify-theme` (created by sync-theme-branch workflow), `origin/dependabot/npm_and_yarn/...`.
- **Worktrees:** Primary at the path above (main). Cursor worktrees at `.../ewa`, `.../mhx`, `.../snq`, `.../uub` (ewa, snq, uub are detached HEAD; mhx is on handoff-doc-permissions-20260129).

---

## What was attempted and what happens

- **Theme pull:** Scripts `theme-pull.ps1` and `theme-pull-rest.ps1` exist. When run from this environment, **theme pull fails**: TLS/SSL handshake errors when connecting to `aodrop.com.myshopify.com` (both the Node-based Shopify CLI and the PowerShell REST fallback fail with SSL errors). Tokens and auth flows (device-code, browser token extraction) are configured; the failure is at the TLS connection to Shopify from this machine/network.
- **Theme folder:** `src/shopify/themes/aodrop-theme` has brand assets (ao-brand.css, ao-hero-brand.liquid, 7 brand images) merged in by scripts. It does **not** have a full theme structure (e.g. no `layout/theme.liquid`) because a successful theme pull from Shopify has not been achieved from this environment. So `theme-dev.ps1` may not run successfully until the theme is fully pulled or the folder is brought to a valid state some other way.
- **Pipeline:** `verify-pipeline.ps1` runs 70 PowerShell scripts and 7 GitHub workflows; lint and product-sync dry-run pass. `npm run format`, `npm run lint`, `npm run test:unit` have been run and pass in this environment.
- **finish-setup.ps1** has been run with theme pull skipped (because pull fails); it verified pipeline, merged brand assets into the theme folder, and wrote `docs/status/SETUP_STATUS.md`.

---

## What exists in the repo

- **Scripts:** Under `scripts/shopify/`: theme-pull.ps1 (tries REST first when token set, then Node CLI), theme-pull-rest.ps1 (PowerShell REST API pull), theme-dev.ps1, theme-auth-then-pull.ps1, theme-auth-via-browser.ps1, finish-setup.ps1, theme-update-store.ps1, merge-brand-into-theme.ps1, copy-brand-images-to-theme.ps1, update-theme.ps1, and others. Theme path defaults: `src/shopify/themes/aodrop-theme`. Repo root is resolved from script location (PSScriptRoot).
- **Credentials:** `.env.local` at repo root (gitignored) is used for SHOPIFY_STORE_DOMAIN, SHOPIFY_CLI_THEME_TOKEN or SHOPIFY_ACCESS_TOKEN. Scripts load it when present.
- **Docs:** Many status and handoff docs in `docs/status/`, including CONSOLIDATION_LOG.md (chronological log of what was done), BRANCH_INVENTORY.md, WORKTREE_INVENTORY.md, GURU_COMPLETION_SUMMARY.md, SETUP_STATUS.md, MANUAL_VERIFICATION_CHECKLIST.md, INDEX_REPORTS.md, SHOPIFY_ADMIN_CHECKLIST.md. Root-level: OPERATOR_RUNBOOK.md, AGENTS.md, docs/UPDATE_SHOPIFY_FROM_CURSOR.md, docs/TROUBLESHOOTING.md.
- **GitHub workflows:** `.github/workflows/` — ci.yml, quality-check.yml, deploy.yml, shopify-sync.yml, sync-theme-branch.yml, sync.yml, maintenance.yml. They trigger on **main**; no develop branch in use.
- **Store:** Shopify store domain `aodrop.com` (myshopify: aodrop.com.myshopify.com). Theme source in repo: `src/shopify/themes/aodrop-theme`. Shopify GitHub App can connect to repo/branch for theme deployment.

---

## User’s position

The user considers **the system broken** and has granted the new agent **full unrestricted approval and dominion over the entire project** to fix everything. This handoff only explains the situation; it does not restrict or instruct the new agent.
