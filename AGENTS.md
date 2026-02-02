# Agent instructions

## Agent permission

The user grants agents **full permission** to perform all actions in this repository and worktree. The system is fully functional; no operations are inhibited. Agents may run scripts, edit files, commit, push, and execute workflows as needed to complete tasks.

**Existing safety rules still apply:**

- **Preview before apply:** Store-affecting changes (theme push, product sync) require preview (e.g. `sync-products.ps1 -DryRun` or theme dev URL), snapshot to `docs/status/pending-approval.md`, and explicit user approval in chat before apply. See `.cursor/rules/shopify-preview-approval.mdc`.
- **No secrets in commits:** Credentials live only in `.env.local` or GitHub Secrets; never commit or log secrets. See `.cursor/rules/env-credentials.mdc`.

## Playwright and desktop automation

Agents may use **Playwright** for scripted E2E and browser automation, and **desktop-automation** (and remote-PC flows) for operations that cannot be performed via GitHub or Shopify API. See `.cursor/context/node-and-automation.md` and [docs/AGENT_SYSTEM.md](docs/AGENT_SYSTEM.md). Use **your browser** (Cursor browser MCP) for interactive credential or one-off UI flows; use Playwright for automated, repeatable E2E runs when appropriate.

## When agents use your browser

With your permission, agents use **your browser** (Cursor browser MCP, your Chrome) when an action is impossible, limited, or unsafe via API—for example:

- **GitHub or Shopify settings** that have no safe API or would compromise security/settings.
- **One-off UI flows** (e.g. add one product with uploads in Shopify Admin; you watch; agent stops before Save and asks approval).
- **Credential setup** (e.g. navigate to login, you log in, agent extracts token and writes to `.env.local` only).

You stay in control: agents use your open windows, you watch, and approval is required before destructive or store-affecting saves. See [docs/BROWSER_CREDENTIAL_FLOW.md](docs/BROWSER_CREDENTIAL_FLOW.md) and [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md) (browser path). Rule: `.cursor/rules/use-user-browser.mdc`.

## Where to find workflows

- **Runbook (daily checks, Shopify, credentials):** [OPERATOR_RUNBOOK.md](OPERATOR_RUNBOOK.md)
- **Store workflow (preview → approve → apply → log):** [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md)
