# Cursor data boundary

Summary for operators and agents: what stays on your machine and what Cursor may send for AI assistance.

---

## Secrets (never leave your machine)

- **Storage**: All secrets (GitHub PAT, Shopify Admin API token, etc.) live only in **`.env.local`** at repo root. This file is gitignored and must never be committed.
- **In Cursor**: The agent may read or write `.env.local` only to complete credential setup (e.g. after you provide values or a browser flow). The agent must **never** paste secrets into chat, include them in prompts, log them, or commit them.
- **Rule**: See [.cursor/rules/env-credentials.mdc](../../.cursor/rules/env-credentials.mdc). If in doubt, do not put a secret anywhere except `.env.local`.

---

## Non-secret content (may be sent to Cursor for AI)

- **Code and docs**: When you use Cursor for editing, commands, or chat, code and documentation from the repo may be sent to Cursor’s services to provide AI assistance. This is how Cursor works and is accepted for normal editing and assistance.
- **What not to paste**: Do not paste or attach `.env.local` or any file containing tokens, passwords, or API keys into chat or into context. Use scripts and rules so the agent never reads secrets into the conversation.

---

## Browser MCP (your Chrome)

- When Cursor uses the **browser MCP** (e.g. to navigate Shopify Admin or GitHub), it uses **your local Chrome** and the pages you have open. Data is not “sent to Cursor” beyond what is needed for the agent to assist (e.g. navigation, clicking). You remain in control of the browser session.

---

## Reference

- [docs/security/AGENT_AND_REPO_SECURITY.md](AGENT_AND_REPO_SECURITY.md)
- [.cursor/rules/env-credentials.mdc](../../.cursor/rules/env-credentials.mdc)
