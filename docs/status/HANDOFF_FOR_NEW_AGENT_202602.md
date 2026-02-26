# Situation for new agent (2026-02)

**Prompt for new agent:** For **audit + fix-all continuation**, use **`prompts/ULTIMATE_FOLLOWUP_CONTINUATION_PROMPT.md`** first. For baseline startup, use **`docs/status/PLAN_AGENT_ENTRY.md`** and **`prompts/PERFECT_EXECUTION_PROMPT.md`**; for full takeover use **`docs/AGENT_PROMPT_DECISION_TREE.md`** and the canonical plan (`.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md`). **Execution and daily gates:** See [docs/GURU_PP_OPERATOR_GUIDE.md](../GURU_PP_OPERATOR_GUIDE.md) (guru/PP baseline, when to use which skill) and [OPERATOR_RUNBOOK.md](../../OPERATOR_RUNBOOK.md) (daily checks, verify-pipeline, run-runbook). To **test and utilize the new Cursor agent system** (rules, skills, /review, /pr, Verifier) with a full system-wide run across code, repo, pipeline, and project, use **`prompts/FULL_SYSTEM_TEST_AND_IMPROVEMENT_PROMPT.md`**. To **loop perfection until complete** (worktree-coordinated lead agent, PP cycles, cleanup/optimization), use **`prompts/MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT.md`** and **`.cursor/plans/MASTER_GURU_E2E_PERFECTION_RUN.plan.md`**. To **run a full-system overhaul and unified agent execution** (any request → plan → PC + APIs → preview/approve/apply; Phase 0 audit; conditional APIs vs PC), use **`prompts/MASTER_FULL_SYSTEM_OVERHAUL_UNIFIED_GURU_PP_PROMPT.md`**.

The user has given the new agent **full unrestricted approval and dominion over the entire project** to fix everything. This document explains the situation only. No limitations or instructions are imposed.

**New agent access:** The new agent runs in a new instance and **has access to branch `main`** (can push/pull). The previous agent was **local-only** (no push). The new agent should **pull from origin first** (`git pull origin main`) to get the latest commit(s), then follow PLAN_AGENT_ENTRY and the decision tree.

---

## Repo and branch state

- **Primary repo:** `C:\Users\LegiT\against-the-odds` on branch **main**.
- **Last commit on main (at handoff):** Either `f3141ee` ("Finalize and close agent branches/workflows; handoff for new agent") if origin was not updated, or a later commit such as `c720000` ("Canonical Build plan perfected (2026-02-01)") after the previous agent’s local commit. **Pull `origin/main`** to ensure you have the latest.
- **Other local branches:** `feature/ao-brand-shopify-automation`, `cursor/main-project-setup-2bd1`, `handoff-doc-permissions-20260129` (latter has worktree mhx). **Deleted locally (merged to main):** guru-finalization-20260206, cursor-agent-setup (2026-02-07).
- **Remote-only branches:** `origin/shopify-theme` (created by sync-theme-branch workflow), `origin/dependabot/npm_and_yarn/...`, `origin/guru-finalization-20260206`, `origin/cursor-agent-setup`.
- **Worktrees:** See [WORKTREE_INVENTORY.md](WORKTREE_INVENTORY.md) for current list (primary + mhx, bjm, cpd, ghd, igt, osd; jxj when present). ewa, snq, uub removed 2026-02-07; opo, qqa no longer worktrees.

---

## What was attempted and what happens

- **Theme pull:** Scripts `theme-pull.ps1` and `theme-pull-rest.ps1` exist. When run from this environment, **theme pull fails**: TLS/SSL handshake errors when connecting to `aodrop.com.myshopify.com` (both the Node-based Shopify CLI and the PowerShell REST fallback fail with SSL errors). Tokens and auth flows (device-code, browser token extraction) are configured; the failure is at the TLS connection to Shopify from this machine/network.
- **Theme folder:** `src/shopify/themes/aodrop-theme` has brand assets (ao-brand.css, ao-hero-brand.liquid, 7 brand images) merged in by scripts. It does **not** have a full theme structure (e.g. no `layout/theme.liquid`) because a successful theme pull from Shopify has not been achieved from this environment. So `theme-dev.ps1` may not run successfully until the theme is fully pulled or the folder is brought to a valid state some other way.
- **Pipeline:** `verify-pipeline.ps1` runs PowerShell scripts and 6 GitHub workflows (ci, codeql, shopify-sync, sync-theme-branch, sync, maintenance); lint and product-sync dry-run pass. `npm run format`, `npm run lint`, `npm run test:unit` have been run and pass in this environment.
- **finish-setup.ps1** has been run with theme pull skipped (because pull fails); it verified pipeline, merged brand assets into the theme folder, and wrote `docs/status/SETUP_STATUS.md`.

### Deferred (by design; no change unless credentials/env fixed)

- **verify-pipeline runbook step (Shopify 401, GITHUB_TOKEN):** Credential-gated; documented. When `.\scripts\run-runbook.ps1` or the runbook step in verify-pipeline runs, Shopify returns 401 Unauthorized and GITHUB_TOKEN is not set in this environment. Resolve by configuring `.env.local` and/or GitHub Secrets when available; then re-run.
- **Integration tests:** Skipped when credentials are missing; documented. `npm run test:integration` skips Shopify/GitHub tests without tokens; by design.
- **Theme pull / E2E:** Environment/SSL blocker per HANDOFF; no change. Theme pull fails with TLS/SSL errors from this machine/network; E2E and full theme-dev depend on a successful pull or alternate path (e.g. browser-based flow).

---

## What exists in the repo

- **Scripts:** Under `scripts/shopify/`: theme-pull.ps1 (tries REST first when token set, then Node CLI), theme-pull-rest.ps1 (PowerShell REST API pull), theme-dev.ps1, theme-auth-then-pull.ps1, theme-auth-via-browser.ps1, finish-setup.ps1, theme-update-store.ps1, merge-brand-into-theme.ps1, copy-brand-images-to-theme.ps1, update-theme.ps1, and others. Theme path defaults: `src/shopify/themes/aodrop-theme`. Repo root is resolved from script location (PSScriptRoot).
- **Credentials:** `.env.local` at repo root (gitignored) is used for SHOPIFY_STORE_DOMAIN, SHOPIFY_CLI_THEME_TOKEN or SHOPIFY_ACCESS_TOKEN. Scripts load it when present.
- **Docs:** Many status and handoff docs in `docs/status/`, including CONSOLIDATION_LOG.md (chronological log of what was done — read latest entries for full follow-up context), BRANCH_INVENTORY.md, WORKTREE_INVENTORY.md, EXECUTIVE_DECISION_WORK_PRINCIPLES.md (binding rules), GURU_COMPLETION_SUMMARY.md, SETUP_STATUS.md, MANUAL_VERIFICATION_CHECKLIST.md, INDEX_REPORTS.md, SHOPIFY_ADMIN_CHECKLIST.md. **Canonical Build plan:** `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` (read "Current Operating Mode" first). Root-level: OPERATOR_RUNBOOK.md, AGENTS.md, docs/UPDATE_SHOPIFY_FROM_CURSOR.md, docs/TROUBLESHOOTING.md.
- **GitHub workflows:** `.github/workflows/` — ci.yml (consolidated quality gate), codeql.yml, shopify-sync.yml, sync-theme-branch.yml, sync.yml, maintenance.yml. They trigger on **main**; no develop branch in use.
- **Store:** Shopify store domain `aodrop.com` (myshopify: aodrop.com.myshopify.com). Theme source in repo: `src/shopify/themes/aodrop-theme`. Shopify GitHub App can connect to repo/branch for theme deployment.

---

## User’s position

The user considers **the system broken** and has granted the new agent **full unrestricted approval and dominion over the entire project** to fix everything. This handoff only explains the situation; it does not restrict or instruct the new agent.
