# Agent instructions

## Guru / PP approved methodology (user-approved)

The user has approved the **guru-expert, deep-research, and Prodigy Protocol (pp) style** as the default approach for this repo. When prompted to improve setups, automations, or systems:

- **Research-first:** Use expert-backed research, best practices, and up-to-date patterns (languages, repos, tooling) before implementing.
- **Multi-faceted cycles:** Apply pp-style decomposition, verification steps, and recovery where useful (see `.cursor/skills/prodigy-protocol/SKILL.md` and `.cursor/rules/pp-basis.mdc`).
- **Implement and optimize:** Add or extend scripts, pipeline automations, Cursor tasks, and docs so improvements are **permanent** and wired into the pipeline where needed.
- **Systems-wide:** Apply the same standard across all aspects—credentials, store operations, theme/product flows, images, E2E, desktop automation, and CI—so the setup stays dependable and ideal.

Deliver trusted, logical, and perfected setups; prefer upgrades, extensions, and automations that integrate into existing runbooks and workflows (e.g. `OPERATOR_RUNBOOK.md`, `docs/AUTOMATION_IMPLEMENTATION_GUIDE.md`, `docs/STORE_OPERATIONS_AUTOMATION.md`).

## Agent permission

The user grants agents **full permission** to perform all actions in this repository and worktree. The system is fully functional; no operations are inhibited. Agents may run scripts, edit files, commit, push, and execute workflows as needed to complete tasks.

**Existing safety rules still apply:**

- **Preview before apply:** Store-affecting changes (theme push, product sync) require preview (e.g. `sync-products.ps1 -DryRun` or theme dev URL), snapshot to `docs/status/pending-approval.md`, and explicit user approval in chat before apply. See `.cursor/rules/shopify-preview-approval.mdc`.
- **No secrets in commits:** Credentials live only in `.env.local` or GitHub Secrets; never commit or log secrets. See `.cursor/rules/env-credentials.mdc`.

## Playwright and desktop automation

Agents may use **Playwright** for scripted E2E and browser automation, and **desktop-automation** (and remote-PC flows) for operations that cannot be performed via GitHub or Shopify API. See `.cursor/context/node-and-automation.md` and [docs/AGENT_SYSTEM.md](docs/AGENT_SYSTEM.md). Use **your browser** (Cursor browser MCP) for interactive credential or one-off UI flows; use Playwright for automated, repeatable E2E runs when appropriate.

**User approval (2026-02-07):** The user has approved agents to perform **all setup tasks** using **e2e, PC control, browser automation, screen-reader flows, and other guru-approved methods** as needed and necessary by the guru expert team. No additional permission prompt is required for these methods when they are the right tool for a setup task.

**User approval (perfection loop):** The user approves **looping the perfection process** until all work is fixed, perfected, complete, and optimized; **creating new guru expert team analysts/specialists** as needed to carry out new orders; and **controlling the user's PC** to navigate, perfect, optimize, test (processes, e2e, systems, pipeline), and perform/execute setup and optimization tasks **as defined by the lead agent**. Safety rules (preview-before-apply, no secrets in commits) unchanged.

## When agents use your browser

With your permission, agents use **your browser** (Cursor browser MCP, your Chrome) when an action is impossible, limited, or unsafe via API—for example:

- **GitHub or Shopify settings** that have no safe API or would compromise security/settings.
- **One-off UI flows** (e.g. add one product with uploads in Shopify Admin; you watch; agent stops before Save and asks approval).
- **Credential setup** (e.g. navigate to login, you log in, agent extracts token and writes to `.env.local` only).

You stay in control: agents use your open windows, you watch, and approval is required before destructive or store-affecting saves. See [docs/BROWSER_CREDENTIAL_FLOW.md](docs/BROWSER_CREDENTIAL_FLOW.md) and [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md) (browser path). Rule: `.cursor/rules/use-user-browser.mdc`.

## Where to find workflows

- **Runbook (daily checks, Shopify, credentials):** [OPERATOR_RUNBOOK.md](OPERATOR_RUNBOOK.md)
- **Store workflow (preview → approve → apply → log):** [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md)

## Cursor and agent optimization

For a full audit of rules, skills, extensions, and **personal (user) Cursor settings** to improve agent performance, see [docs/status/CURSOR_AND_AGENT_OPTIMIZATION.md](docs/status/CURSOR_AND_AGENT_OPTIMIZATION.md). It includes a checklist of UI settings (agent stickiness, iterate on lints, indexing, etc.) and project settings in `.cursor/`.

## Cursor Cloud specific instructions

This is an operational infrastructure repo for the "Against The Odds" Shopify store (aodrop.com). There is no traditional application build/server — `npm run build` and `npm run dev` are no-op echo commands.

### Key commands

| Task              | Command                                                             |
| ----------------- | ------------------------------------------------------------------- |
| Install deps      | `npm install`                                                       |
| Lint              | `npx eslint .`                                                      |
| Format check      | `npx prettier --check "**/*.{js,ts,jsx,tsx,json,css,md,html}"`      |
| Unit tests        | `npm run test:unit` (Vitest)                                        |
| Integration tests | `npm run test:integration` (skipped without Shopify/GitHub creds)   |
| Full quality gate | `npm run quality` (format + lint + unit tests)                      |
| Serve static site | `python3 -m http.server 8080` (from repo root; serves `index.html`) |
| E2E tests         | `npm run test:e2e` (requires `npx playwright install` first)        |

### Caveats

- **No Docker, no database.** All product data lives in `data/products/*.json`; the store is Shopify-hosted.
- **Integration tests require credentials** (`SHOPIFY_ACCESS_TOKEN`, `GITHUB_TOKEN`, etc. in `.env.local`). Without them, integration tests are auto-skipped — this is expected.
- **PowerShell scripts** (`.ps1`) are used for Shopify sync, setup, and operational tasks. Install `pwsh` if you need to run them on Linux (`apt-get install -y powershell`), but they are not required for lint/test/build.
- **Desktop automation** (`src/desktop-automation/`) depends on optional native modules (`robotjs`, `node-window-manager`) that only work on Windows with a display. These fail to install on Linux — this is expected and handled via `optionalDependencies`.
- **Playwright E2E** uses `python3 -m http.server 8080` as its webServer. Python 3 must be on PATH. Run `npx playwright install` once to fetch browsers before running E2E tests.
