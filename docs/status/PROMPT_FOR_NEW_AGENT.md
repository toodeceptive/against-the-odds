# Prompt for new agent (copy-paste into new chat)

Use the block below in a **new agent instance** to continue work on the Against the Odds project. The new agent has **access to branch main** (can push/pull); the previous agent was local-only, so pull first to get the latest commit.

---

## Copy from here ↓

You are a new AI agent in a new instance taking over the **Against the Odds** project. The user has given you **full approval and dominion** to follow up on all work done so far.

**You have access to branch `main`** (you can push and pull). The previous agent was only locally enabled and may have left one or more commits on main that are not yet on origin. **Do this first:**

1. **Sync with main**  
   From the repo root: `git pull origin main` (or `git fetch origin && git merge origin/main`). This brings in the latest work (e.g. "Canonical Build plan perfected" and related docs).

2. **Read the handoff (situation)**  
   Open **`docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`**. It describes repo state, what was attempted, what currently fails (e.g. theme pull / SSL in one environment), what exists (scripts, credentials, workflows), and the user’s grant of full dominion.

3. **Read the execution rules**  
   Open **`docs/status/EXECUTIVE_DECISION_WORK_PRINCIPLES.md`**. It defines: Phase 0 and Tracks A–G are already done (do not re-run); only incremental, outcome-based fixes; worktree rule; no new artifacts by default.

4. **Read the canonical Build plan (operating mode)**  
   Open **`.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md`** and read the **"Current Operating Mode (Read This First)"** section at the top. It states: incremental fix batches only; hybrid Shopify model (GitHub for history/CI, local + browser always valid); no new artifacts; link to CONSOLIDATION_LOG.

5. **Read the consolidation log**  
   Skim **`docs/status/CONSOLIDATION_LOG.md`** (latest entries) so you know what was done and when. Use it as the single place to append new work (one dated entry per batch).

6. **Proceed**  
   Decide next steps from the **Incremental Fix List** in the canonical plan and/or from the handoff (e.g. fix theme pull/SSL, complete theme setup, or other outcome-based fixes). Run one batch → verify (format, lint, test:unit, verify-pipeline) → append CONSOLIDATION_LOG → commit. Do not re-run Phase 0 or Tracks A–G. Do not create new tracker or progress docs unless the user asks.

**Binding rules (do not contradict):**

- Store-affecting changes: preview first, snapshot to `docs/status/pending-approval.md`, get user approval in chat, then apply; log in `docs/status/deploy-log.md`.
- Secrets only in `.env.local` (gitignored); never commit or log secrets.
- No unattended headless Shopify Admin (ToS); use user’s browser when needed (see `.cursor/rules/use-user-browser.mdc` and `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`).

**Quick refs:**

- Plan index: `.cursor/plans/README.md`
- Status index: `docs/status/INDEX_REPORTS.md`
- Daily ops: `OPERATOR_RUNBOOK.md` (root)
- Agent permissions: `AGENTS.md` (root)

---

## Copy to here ↑
