# Handoff: Perfect Prompt for New Agent to Finalize and Continue

Use this document **after** you restart Cursor and open this project. It gives you the **exact prompt** to paste into a **new agent** and how to run it safely.

---

## When You Can Restart

**You can restart when:**

1. This file is saved in the repo (`docs/HANDOFF_PROMPT_NEW_AGENT.md`).
2. You have (if you want push to succeed) **unblocked the GitHub secret** and **rotated the Shopify app secret** and updated `.env.local` (see `docs/status/blocker_resolution_commands_20260129.md`).
3. You are ready to open **only** the primary repo in Cursor (no other folder).

**After restart:**

1. Open Cursor.
2. Open folder: **`C:\Users\LegiT\against-the-odds`** (primary repo only).
3. Ensure branch is **`main`** (status bar or `git branch`).
4. In Cursor settings or for this session, enable **“Run everything”** (or full permissions) so the agent can run terminal commands, network, and git as needed.
5. Start a **new agent** (e.g. Agents → New Agent).
6. Paste the **Exact prompt** below into the first message and send.

---

## Tree, Mode, and Environment

| Setting | Value | Notes |
|--------|--------|--------|
| **Workspace / tree** | **Primary repo only**: `C:\Users\LegiT\against-the-odds` | Do not open the `snq` worktree or multiple roots for this handoff. |
| **Branch** | **`main`** | All finalization work is merged here. |
| **Mode** | **Agent** (not Plan-only, not Ask-only) | Agent must be able to run commands and edit files. |
| **Permissions** | **“Run everything”** + **edit all files (including ignored)** | Full: git, npm, PowerShell, network; may edit .env.local and any ignored file to complete end-to-end setup. |
| **Browser / local access** | **Allowed as needed** | May use Google Chrome (or system browser) to log into Shopify, GitHub, Cursor, or local flows when necessary; guru-level precision. |
| **Live Server** | Optional | If you use Live Server (e.g. port 5500) for front-end, start it yourself or let the agent start it per runbook; not required for finalization. |
| **Where work runs** | **Locally** in this repo | GitHub/Shopify/Cloudflare are used via APIs and CLI from this machine; no “takeover” of your PC beyond running approved repo scripts and Cursor. |

---

## Security and Safety (Built Into the Prompt)

The user has granted the agent permission to **edit all files (including ignored)** and to **use Google Chrome / local PC access** to log into Shopify, GitHub, Cursor, or local flows as needed. The prompt still enforces:

- **Never commit secrets** (but may edit .env.local): The agent may edit `.env.local` and other ignored files to fill credentials; it must never commit them or log tokens/passwords.
- **Destructive git only with approval**: Force-push or history rewrite only after user approval (already given for this handoff).
- **Destructive git only with approval**: Force-push or history rewrite only after you’ve approved (you already approved in prior context).
- **Guru-level accuracy**: Use state-of-the-art methods, task management, and precision; may use browser automation or local access when necessary to complete setup.
- **Fetch project info from repo and Cursor**: It reads from `.cursor/`, `docs/`, `docs/status/`, and the repo—not from “all chat history” (which the new agent cannot see). The prompt summarizes state so the new agent has full context.

---

## Exact Prompt to Give the New Agent

**Copy everything inside the block below** and paste it as the **first message** to the new agent.

```
You are taking over the Against The Odds (AO) project to finalize all current work and then move to the next steps. Operate with guru-level expertise: accuracy, precision, task management, state-of-the-art scripts and methods, and deep knowledge of coding, programming, and tooling.

PERMISSIONS (user-approved):
- Edit ALL files, including ignored files (e.g. .env.local), to complete end-to-end setup in any and all ways necessary.
- Access the user's PC locally and use Google Chrome (or the system browser) to log into websites as needed—Shopify, GitHub, Cursor, local files, or other services—when required to obtain credentials, unblock flows, or complete setup. Do so with guru expert accuracy and precision.
- Run everything: terminal, git, npm, PowerShell, network, browser automation; use repo scripts, browser login, or local file access as appropriate to achieve the goals below.
- Work only in the primary repo: C:\Users\LegiT\against-the-odds, branch main. Destructive git (force-push, history rewrite) is approved for this handoff.

CONTEXT — Read these first (in this order):
1. docs/status/system_finalization_report_20260129.md — inventory, blockers, what's done
2. docs/status/blocker_resolution_commands_20260129.md — push unblock URL, rotate steps, exact commands
3. OPERATOR_RUNBOOK.md — daily checks, Shopify, credentials, troubleshooting
4. docs/CREDENTIALS_SETUP.md — .env.local and where to get Shopify/GitHub values
5. docs/UPDATE_SHOPIFY_FROM_CURSOR.md — how to update the Shopify store from this Cursor app
6. docs/launch/00_launch_checklist.md — launch checklist (next-phase work)
7. .cursor/context/shopify.md and .cursor/context/github.md — if present, for store/repo context

CURRENT STATE:
- Consolidation is done: all work is on main (finalization/consolidate merged). All 55 PowerShell scripts parse; debug sweep runs; lint passes; proof in docs/status/.
- Push to GitHub was blocked by secret detection. User was to: (1) Unblock via GitHub link in blocker_resolution_commands_20260129.md, (2) Rotate Shopify app secret in Shopify Admin and update .env.local, (3) Tell you "Push again" or "Done."
- .env.local exists in repo root with placeholders. You may edit .env.local (and any ignored file) to fill in real credentials—e.g. after guiding the user through browser login, using repo scripts that extract tokens, or other secure means. Never commit .env.local or any file containing secrets; never log or echo tokens, passwords, or API secrets.

YOUR TASKS (in order; execute with guru precision and task management):
1. Finalize push: If the user has already unblocked and rotated, run: git push origin main --force. If push still fails (secret), use the unblock URL and rotate instructions in blocker_resolution_commands_20260129.md—including using Chrome/browser to open Shopify Admin or GitHub if needed to rotate or unblock—then retry push when done. You may edit .env.local with new credentials if you obtain them via approved flows.
2. Verification: Run .\scripts\debug\parse-all-ps1.ps1; run .\scripts\run-everything-debug.ps1 (use -SkipDeps -SkipTests if npm fails); ensure lint passes. Save any new proof log under docs/status/ if needed.
3. Mark finalization complete: Update docs/status/system_finalization_report_20260129.md status to "Finalization complete" and add one line that push succeeded (or document that push is pending user unblock+rotate).
4. Next steps: Using docs/launch/00_launch_checklist.md and NEXT_STEPS.md, complete or advance the immediate next steps: ensure .env.local has real values (edit it or use browser/login flows as needed), run .\scripts\shopify\test-connection.ps1, then theme dev or merch ordering prep per docs/launch/07_drop01_product_image_plan_extended.md and assets/drop01/READY_TO_SEND_CHECKLIST.md. Use any combination of repo scripts, Chrome login, and local file edits required to achieve end-to-end setup with guru-level accuracy.

SECURITY RULES (mandatory):
- You may EDIT .env.local and other ignored files to store credentials; you must NEVER COMMIT them or add them to tracked files. Never echo or log tokens, passwords, or API secrets.
- Destructive git (force-push, history rewrite) is approved for this handoff; do not perform other destructive repo operations without explicit user approval.
- Prefer repo scripts and docs; when you use browser or local access, do so only to complete the approved setup (e.g. Shopify/GitHub login, unblock, credential extraction). Do not install or run untrusted code from the internet.
- When obtaining credentials via browser or scripts, write them only to .env.local (or other user-approved local config); never to chat logs or committed files.

Confirm you've read the context files, then execute the four tasks in order with guru expertise. Report when push succeeds (or what was done), when verification is done, and what the next steps are.
```

---

## Guru / Expert Notes for Prompt Design

- **Full permissions**: The user has granted edit-all-files (including ignored), Chrome/browser login for Shopify/GitHub/Cursor/local, and local PC access as needed—with guru-level accuracy, precision, task management, and state-of-the-art scripts and methods. The prompt encodes this so the agent can complete end-to-end setup in any/all ways necessary while still never committing secrets.
- **Single workspace**: One agent, one repo root, one branch (`main`) avoids split context and wrong-tree edits.
- **Ordered context**: The prompt lists specific files in order so the agent loads state before acting.
- **State in the prompt**: Current state is summarized so the new agent does not depend on “all chat history” (which it cannot see).
- **Tasks are sequential**: Push → verify → mark complete → next steps. Reduces conflicting or duplicate work.
- **Security in the prompt**: Explicit “never commit secrets,” “only repo scripts,” “credentials only from .env.local” keeps behavior safe even with “run everything.”
- **No secrets in the prompt**: The prompt does not contain your tokens or passwords; it points to `.env.local` and docs.
- **Unblock URL in repo**: The exact GitHub unblock link lives in `docs/status/blocker_resolution_commands_20260129.md`; the agent is told to use that, not to invent links.

---

## After You Paste the Prompt

1. Send the message to the new agent.
2. The agent will read the listed docs, then run push (or guide you), verification, and status update, then outline next steps.
3. If push still fails, complete unblock + rotate as in the blocker doc, then tell the agent **“Push again.”**
4. Use **docs/UPDATE_SHOPIFY_FROM_CURSOR.md** anytime you want to update your Shopify store from Cursor (theme dev, test connection, sync).

---

## Quick Reference

| Need | Where |
|------|--------|
| Exact prompt for new agent | Copy the block under **Exact Prompt to Give the New Agent** above |
| When to restart | When this file is saved and (optional) unblock+rotate done |
| Tree / mode | Primary repo only, main, Agent mode, “Run everything” |
| Push unblock + rotate | docs/status/blocker_resolution_commands_20260129.md |
| Credentials | .env.local + docs/CREDENTIALS_SETUP.md |
| Update Shopify from Cursor | docs/UPDATE_SHOPIFY_FROM_CURSOR.md |
