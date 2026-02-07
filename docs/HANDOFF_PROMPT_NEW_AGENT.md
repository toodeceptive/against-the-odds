# Handoff: Perfect Prompt for New Agent to Finalize and Continue

Use this document **after** you restart Cursor and open this project. It gives you the **exact prompt** to paste into a **new agent** and how to run it safely.

---

## When You Can Restart

**You can restart when:**

1. This file is saved in the repo (`docs/HANDOFF_PROMPT_NEW_AGENT.md`).
2. Push has succeeded (history was rewritten with git-filter-repo; main was force-pushed to GitHub). Unblock/rotate was resolved.
3. You are ready to open **only** the primary repo in Cursor (no other folder).

**After restart:**

1. Open Cursor.
2. Open folder: **`C:\Users\LegiT\against-the-odds`** (primary repo only).
3. Ensure branch is **`main`** (status bar or `git branch`).
4. In Cursor settings or for this session, enable **"Run everything"** (or full permissions) so the agent can run terminal commands, network, and git as needed.
5. Start a **new agent** (e.g. Agents → New Agent).
6. Paste the **Exact prompt** below into the first message and send.

---

## Tree, Mode, and Environment

| Setting                    | Value                                                         | Notes                                                                                                                                                                                                                                                                                                                           |
| -------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Workspace / tree**       | **Primary repo only**: `C:\Users\LegiT\against-the-odds`      | Do not open the `snq` worktree or multiple roots for this handoff.                                                                                                                                                                                                                                                              |
| **Branch**                 | **`main`**                                                    | All finalization work is merged here.                                                                                                                                                                                                                                                                                           |
| **Mode**                   | **Agent** (not Plan-only, not Ask-only)                       | Agent must be able to run commands and edit files.                                                                                                                                                                                                                                                                              |
| **Permissions**            | **"Run everything"** + **edit all files (including ignored)** | Full: git, npm, PowerShell, network; may edit .env.local and any ignored file to complete end-to-end setup.                                                                                                                                                                                                                     |
| **Browser / local access** | **Allowed as needed**                                         | May use Google Chrome (or system browser) to log into Shopify, GitHub, Cursor, or local flows when necessary; guru-level precision.                                                                                                                                                                                             |
| **Use the user's browser** | **Required when needed**                                      | The agent must navigate **the user's own browser**—the Chrome windows the user already has open (e.g. Shopify, GitHub, Cloudflare tabs, already logged in)—when needed to fetch information and finalize end-to-end system setup **before** proceeding. Do not use a separate or headless browser; use the user's open windows. |
| **Live Server**            | Optional                                                      | If you use Live Server (e.g. port 5500) for front-end, start it yourself or let the agent start it per runbook; not required for finalization.                                                                                                                                                                                  |
| **Where work runs**        | **Locally on your PC and in this repo**                       | Repo, terminal, browser (Chrome), local files—whatever is needed to finalize and run next steps with guru expertise.                                                                                                                                                                                                            |

---

## Security and Safety (Built Into the Prompt)

The user has granted the agent permission to **edit all files (including ignored)** and to **use Google Chrome / local PC access** to log into Shopify, GitHub, Cursor, or local flows as needed. The prompt still enforces:

- **Never commit secrets** (but may edit .env.local): The agent may edit `.env.local` and other ignored files to fill credentials; it must never commit them or log tokens/passwords.
- **Browser/local access only for approved setup**: Use Chrome or local access only to complete the approved setup (e.g. Shopify/GitHub login, unblock, credential extraction); never for unrelated actions.
- **Destructive git only with approval**: Force-push or history rewrite only after user approval (already given for this handoff).
- **Guru-level accuracy**: Use state-of-the-art methods, task management, and precision; may use browser automation or local access when necessary to complete setup.
- **Fetch project info from repo and Cursor**: It reads from `.cursor/`, `docs/`, `docs/status/`, and the repo—not from "all chat history" (which the new agent cannot see). The prompt summarizes state so the new agent has full context.
- **Guru/PP execution**: New agents should use [docs/GURU_PP_OPERATOR_GUIDE.md](GURU_PP_OPERATOR_GUIDE.md) and [OPERATOR_RUNBOOK.md](../OPERATOR_RUNBOOK.md) for execution baseline and daily gates (verify-pipeline, run-runbook).
- **Files and uploads for store changes**: The user grants the agent permission to read files/paths and use uploads shared in chat when the user is requesting a store change (e.g. "add a product with these images" or providing description/data from their PC). Use them only for the requested change; follow the workflow in docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md (preview → approve → apply → log).

---

## Exact Prompt to Give the New Agent

**Copy everything inside the block below** and paste it as the **first message** to the new agent.

```
You are taking over the Against The Odds (AO) project to finalize all current work and then move to the next steps. Operate with guru-level expertise: accuracy, precision, task management, state-of-the-art scripts and methods, and deep knowledge of coding, programming, and tooling.

PERMISSIONS (user-approved):
- Edit all files, including ignored (e.g. .env.local), to finish end-to-end setup in any way needed.
- Use the PC locally and Google Chrome (or system browser) to log into Shopify, GitHub, Cursor, local files, or other services when needed to get credentials, unblock flows, or complete setup, with guru-level accuracy and precision.
- Navigate the user's browser: When browser access is needed, use the user's own browser—the Chrome windows they already have open (e.g. Shopify, GitHub, Cloudflare tabs, already logged in). Navigate those open windows to fetch information and finalize end-to-end system setup before proceeding. Do not use a separate or headless browser; use the user's open windows.
- Run everything: terminal, git, npm, PowerShell, network, browser automation; use repo scripts, browser login, or local file access as appropriate.
- Guru expertise: Operate with guru-level expertise—accuracy, precision, task management, state-of-the-art scripts and methods, and strong knowledge of coding, programming, and tooling.
- Work only in the primary repo: C:\Users\LegiT\against-the-odds, branch main. Destructive git (force-push, history rewrite) is approved for this handoff.
- Initial setup: Ignore all security measures for initial setup; just prompt the user to continue.

CONTEXT — Read these first (in this order):
1. docs/status/CONSOLIDATION_LOG.md — what was done, when; docs/status/INDEX_REPORTS.md — index of status/report files
2. docs/status/HANDOFF_FOR_NEW_AGENT_202602.md — current repo/branch/worktree state, deferrals
3. OPERATOR_RUNBOOK.md — daily checks, Shopify, credentials, troubleshooting
4. docs/CREDENTIALS_SETUP.md — .env.local and where to get Shopify/GitHub values
5. docs/UPDATE_SHOPIFY_FROM_CURSOR.md — how to update the Shopify store from this Cursor app
6. docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md — store changes: preview → pending-approval.md → open-pending-approval.ps1 (theme: start-theme-preview.ps1) → approve in chat → apply → docs/status/deploy-log.md; run Cursor tasks from repo root
7. docs/launch/00_launch_checklist.md — launch checklist (next-phase work)
8. .cursor/context/shopify.md and .cursor/context/github.md — if present, for store/repo context

**Plan-only runs (Security & Platform / next team):** Read docs/status/PLAN_AGENT_ENTRY.md first if present — single entry for plan chats and binding rules. Then read docs/status/PLAN_HANDOFF_FOR_NEXT_AGENT.md, .cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md (single plan; open in Cursor and use Build), docs/status/CONSOLIDATION_LOG.md (from this worktree or primary if missing).
**Cross-worktree:** If you are in a worktree (e.g. uqy, snq, mhx) where those three files are missing, read them from **primary**: C:\Users\LegiT\against-the-odds (main). Fold Expert Team requirements into your plan. See docs/status/IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md if present.

CURRENT STATE:
- Consolidation is done: all work is on main. Push to GitHub has SUCCEEDED: history was rewritten with git-filter-repo (Shopify secret removed from history); main was force-pushed to origin. Credentials were rotated; .env.local holds the new secret (never commit).
- **User's browser**: The user has Chrome open with tabs already logged in (e.g. Shopify, GitHub, Cloudflare). When you need to fetch credentials, unblock flows, or complete setup, navigate **this same browser** (the user's open windows)—not a separate session—to finalize end-to-end setup before proceeding.
- All 74 PowerShell scripts parse; verify-pipeline and lint pass; proof in docs/status/.
- .env.local exists in repo root. You may edit .env.local (and any ignored file) to fill in real credentials—e.g. after guiding the user through browser login, using repo scripts that extract tokens, or other secure means. Never commit .env.local or any file containing secrets; never log or echo tokens, passwords, or API secrets.

YOUR TASKS (in order; execute with guru precision and task management):
1. Verification: Run .\scripts\debug\parse-all-ps1.ps1; run .\scripts\run-everything-debug.ps1 (use -SkipDeps -SkipTests if npm fails); ensure lint passes. Save any new proof log under docs/status/ if needed.
2. Mark finalization complete (if not already): Ensure docs/status/CONSOLIDATION_LOG.md is current and docs/status/PHASE_0_FINALIZATION.md contains "Phase 0 finalized; proceeding allowed" when Phase 0 is done.
3. Next steps: Using docs/launch/00_launch_checklist.md and NEXT_STEPS.md, complete or advance the immediate next steps: ensure .env.local has real values (edit it or use browser/login flows as needed), run .\scripts\shopify\test-connection.ps1, then theme dev or merch ordering prep per docs/launch/07_drop01_product_image_plan_extended.md and assets/drop01/READY_TO_SEND_CHECKLIST.md. Use any combination of repo scripts, Chrome login, and local file edits required to achieve end-to-end setup with guru-level accuracy.

SECURITY RULES (mandatory):
- You may EDIT .env.local and other ignored files to store credentials; you must NEVER COMMIT them or log secrets. Browser/local access is only for the approved setup (login, unblock, credential extraction). Write credentials only to .env.local or other user-approved local config.
- Destructive git (force-push, history rewrite) is approved for this handoff; do not perform other destructive repo operations without explicit user approval.
- Prefer repo scripts and docs; when you use browser or local access, do so only to complete the approved setup. Do not install or run untrusted code from the internet.

Confirm you've read the context files, then execute the tasks in order with guru expertise. Report when verification is done and what the next steps are.
```

---

## Guru / Expert Notes for Prompt Design

- **Full permissions**: Edit-all-files (including ignored), Chrome/browser login for Shopify/GitHub/Cursor/local, local PC access, with guru-level accuracy, precision, task management, and state-of-the-art scripts and methods. The new agent has permission to edit all files, use Chrome and local PC access for logins and setup, work with guru-level accuracy, and never commit secrets; browser/local access only for approved setup.
- **User's browser**: The agent must navigate the user's own browser (the Chrome windows they already have open—Shopify, GitHub, Cloudflare, etc., already logged in) when needed to fetch information and finalize end-to-end setup before proceeding; do not use a separate or headless browser.
- **Single workspace**: One agent, one repo root, one branch (`main`) avoids split context and wrong-tree edits.
- **Ordered context**: The prompt lists specific files in order so the agent loads state before acting.
- **State in the prompt**: Current state is summarized so the new agent does not depend on "all chat history" (which it cannot see). Push has succeeded; tasks are now verification and next steps.
- **Tasks are sequential**: Verify → mark complete → next steps. Push is done.
- **Security in the prompt**: Explicit "never commit secrets," "only repo scripts," "credentials only from .env.local" keeps behavior safe even with "run everything."
- **No secrets in the prompt**: The prompt does not contain your tokens or passwords; it points to `.env.local` and docs.
- **Unblock URL in repo**: The exact GitHub unblock link lives in `docs/status/blocker_resolution_commands_20260129.md`; kept for reference (push was resolved via history rewrite).

---

## After You Paste the Prompt

1. Send the message to the new agent.
2. The agent will read the listed docs, run verification, update status if needed, then outline next steps.
3. **User's browser**: Keep Chrome open with your Shopify, GitHub, and Cloudflare tabs (already logged in). The agent is instructed to navigate **your** browser—those same open windows—when it needs to fetch credentials, unblock flows, or complete setup; it will not use a separate browser session.
4. Push has already succeeded; no unblock/rotate needed unless you push new branches that trigger secret detection.
5. Use **docs/UPDATE_SHOPIFY_FROM_CURSOR.md** anytime you want to update your Shopify store from Cursor (theme dev, test connection, sync).

---

## Quick Reference

| Need                       | Where                                                                                   |
| -------------------------- | --------------------------------------------------------------------------------------- |
| Exact prompt for new agent | Copy the block under **Exact Prompt to Give the New Agent** above                       |
| When to restart            | When this file is saved; push has succeeded                                             |
| Tree / mode                | Primary repo only, main, Agent mode, "Run everything"                                   |
| Push unblock + rotate      | docs/status/blocker_resolution_commands_20260129.md (push resolved via history rewrite) |
| Credentials                | .env.local + docs/CREDENTIALS_SETUP.md                                                  |
| Update Shopify from Cursor | docs/UPDATE_SHOPIFY_FROM_CURSOR.md                                                      |
