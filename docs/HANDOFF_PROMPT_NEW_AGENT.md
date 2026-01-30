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
| **Permissions** | **“Run everything”** or equivalent | So it can run git, npm, PowerShell, and network (e.g. push, Shopify CLI). |
| **Live Server** | Optional | If you use Live Server (e.g. port 5500) for front-end, start it yourself or let the agent start it per runbook; not required for finalization. |
| **Where work runs** | **Locally** in this repo | GitHub/Shopify/Cloudflare are used via APIs and CLI from this machine; no “takeover” of your PC beyond running approved repo scripts and Cursor. |

---

## Security and Safety (Built Into the Prompt)

The prompt instructs the new agent to:

- **Never commit or log secrets**: `.env.local` is gitignored; credentials stay out of repo and logs.
- **No account takeover**: It does not ask for your passwords or 2FA; it uses existing `.env.local` and approved scripts (e.g. `shopify auth login` in terminal, scripts that read `.env.local`).
- **Destructive git only with approval**: Force-push or history rewrite only after you’ve approved (you already approved in prior context).
- **Use only repo assets**: Scripts in `scripts/`, docs in `docs/`, config in repo. No arbitrary downloads or execution of untrusted code.
- **Fetch project info from repo and Cursor**: It reads from `.cursor/`, `docs/`, `docs/status/`, and the repo—not from “all chat history” (which the new agent cannot see). The prompt summarizes state so the new agent has full context.

---

## Exact Prompt to Give the New Agent

**Copy everything inside the block below** and paste it as the **first message** to the new agent.

```
You are taking over the Against The Odds (AO) project to finalize all current work and then move to the next steps. The user has approved full permissions ("run everything") and has approved destructive git (force-push) and credential rotation where needed. Work only in the primary repo: C:\Users\LegiT\against-the-odds, branch main.

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
- .env.local exists in repo root with placeholders; user should paste real Shopify/GitHub credentials there. Never commit .env.local or log secrets.

YOUR TASKS (in order):
1. Finalize push: If the user has already unblocked and rotated, run: git push origin main --force. If push still fails (secret), output the unblock URL and rotate instructions from blocker_resolution_commands_20260129.md and wait for user to complete then say "Push again."
2. Verification: Run .\scripts\debug\parse-all-ps1.ps1; run .\scripts\run-everything-debug.ps1 (use -SkipDeps -SkipTests if npm fails); ensure lint passes. Save any new proof log under docs/status/ if needed.
3. Mark finalization complete: Update docs/status/system_finalization_report_20260129.md status to "Finalization complete" and add one line that push succeeded (or document that push is pending user unblock+rotate).
4. Next steps: Using docs/launch/00_launch_checklist.md and NEXT_STEPS.md, outline or start the immediate next steps: ensure .env.local has real values (guide user if not), run .\scripts\shopify\test-connection.ps1, then theme dev or merch ordering prep per docs/launch/07_drop01_product_image_plan_extended.md and assets/drop01/READY_TO_SEND_CHECKLIST.md. Do not skip verification; do not expose secrets in any file or log.

SECURITY RULES (mandatory):
- Never commit .env.local or any file containing secrets. Never echo or log tokens, passwords, or API secrets.
- Destructive git (force-push, history rewrite) only after user approval; user has already approved force-push for this handoff.
- Use only scripts and docs in this repo. Credentials only from .env.local. Do not install or run untrusted code from the internet.
- For Shopify/GitHub/Cloudflare: use .env.local and approved repo scripts (e.g. scripts/shopify/test-connection.ps1, shopify theme dev). Do not ask the user to paste secrets into chat; direct them to .env.local and docs/CREDENTIALS_SETUP.md.

Confirm you've read the context files, then execute the four tasks in order. Report when push succeeds (or what the user must do), when verification is done, and what the next steps are.
```

---

## Guru / Expert Notes for Prompt Design

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
