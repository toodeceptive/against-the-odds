# Cursor and agent optimization — full audit

**Purpose**: In-depth cross-comparative audit of all Cursor-related settings, rules, skills, subagents, commands, context, extensions, and tools to identify issues, enhancements, and implementations that improve personal Cursor settings and agent performance.

**Scope**: Project (`.cursor/`, `AGENTS.md`, repo config) and **personal (user)** settings to set in Cursor UI. Last review: 2026-02-06.

---

## 1. Executive summary

| Area                     | Status           | Actions                                                                                                      |
| ------------------------ | ---------------- | ------------------------------------------------------------------------------------------------------------ |
| Rules                    | ✅ Coherent      | 5 always-on + 1 agent-decided; no conflicts. Optional: add globs to ao-guru.                                 |
| Skills                   | ✅ Complete      | 4 skills (pp, phantasm, godmode, agentic-performance); descriptions and triggers clear.                      |
| Subagents                | ✅ 9 custom      | Operational roster + verifier deployed; built-in Explore/Bash/Browser still used automatically.              |
| Commands                 | ✅ 3 commands    | `/review`, `/pr`, `/pp`; updated to match deterministic, current repo workflows.                             |
| Context                  | ✅ Aligned       | github, shopify, node-and-automation match docs and workflows.                                               |
| AGENTS.md                | ✅ Consistent    | Mirrors safety rules; points to .cursor/rules and docs.                                                      |
| Project settings         | ✅ Good          | Worktree opts set; extensions via `.cursor/extensions.json`; no repo `.vscode/settings.json` mirror shipped. |
| Extensions               | ✅ Single source | `.cursor/extensions.json` is the repo-tracked recommendation source.                                         |
| .cursorignore            | ✅ Implemented   | Repo root `.cursorignore` is in place for secrets/build noise.                                               |
| .cursorindexingignore    | ✅ Implemented   | Added for archive/generated-history indexing reduction.                                                      |
| Personal (user) settings | 📋 Checklist     | Set in Cursor Settings UI (§6).                                                                              |

---

## 2. Rules audit

| File                         | alwaysApply | globs              | Notes                                                                 |
| ---------------------------- | ----------- | ------------------ | --------------------------------------------------------------------- |
| agent-permissions.mdc        | true        | —                  | Full permission; references safety rules. ✅                          |
| env-credentials.mdc          | true        | —                  | .env.local only; never commit. ✅                                     |
| shopify-preview-approval.mdc | true        | —                  | Preview → pending-approval → approve. ✅                              |
| use-user-browser.mdc         | true        | —                  | Use user's Chrome for credentials/setup. ✅                           |
| pp-basis.mdc                 | true        | —                  | PP baseline; references env, shopify, browser. ✅                     |
| ao-guru.rules.md             | false       | globs (src, tests) | Agent-decided when editing source/tests. Quality gates, reporting. ✅ |

**Findings**: No redundancy; order is consistent. All safety-critical rules are always-on.

---

## 3. Skills, subagents, commands

- **Skills**: prodigy-protocol (pp), prodigy-phantasm, universal-godmode, agentic-performance. All reference pp where appropriate; agentic-performance is the single workflow/tooling hub.
- **Subagents**: Operational roster in `.cursor/agents/` now includes orchestrator_governance, governance_archguard, cursorops_environment, themeops_shopify, storeops_productsync, assetprep_printful, uploadops_printful, cloudflareops_domain, and verifier.
- **Commands**: `/review` — read-only checks (`format:check`, lint, deterministic tests); `/pr` — finalize branch for PR/handoff (no automatic PR creation); `/pp` — load AO PP prompt and run in Prodigy Protocol mode (see [prompts/AO_AGENT_PP_PROMPT.md](../../prompts/AO_AGENT_PP_PROMPT.md)).

---

## 4. Context and AGENTS.md

- **context/github.md**: Repo, branch strategy, workflows, secrets. ✅
- **context/shopify.md**: Store, theme, scripts, workflow doc refs. ✅
- **context/node-and-automation.md**: Playwright vs desktop-automation, npm scripts, Cursor tasks. ✅
- **AGENTS.md**: Permission, safety (preview, no secrets), browser use, workflow pointers. Aligned with .cursor/rules. ✅

---

## 5. Project settings (`.cursor/settings.json`)

Workspace settings live in `.cursor/settings.json` (Cursor). This repo does not currently ship a `.vscode/settings.json` mirror, so docs should treat `.cursor/settings.json` as the tracked source.

| Key                                 | Value                | Purpose                                                                  |
| ----------------------------------- | -------------------- | ------------------------------------------------------------------------ |
| cursor.worktreeMaxCount             | 20                   | Max worktrees per workspace. (Cursor only.)                              |
| cursor.worktreeCleanupIntervalHours | 6                    | Cleanup old worktrees. (Cursor only.)                                    |
| git.showCursorWorktrees             | true                 | Show worktrees in SCM. (Cursor only.)                                    |
| editor.formatOnSave                 | true                 | Prettier on save.                                                        |
| editor.formatOnPaste                | true                 | Format pasted code.                                                      |
| editor.codeActionsOnSave            | source.fixAll.eslint | ESLint fix on save.                                                      |
| editor.bracketPairColorization      | true                 | Bracket pair colorization.                                               |
| editor.detectIndentation            | true                 | Respect file indentation; EditorConfig applies when extension installed. |
| files.autoSave                      | afterDelay           | Reduce risk of losing work.                                              |
| files.trimTrailingWhitespace        | true                 | Align with .editorconfig.                                                |
| files.insertFinalNewline            | true                 | Align with .editorconfig.                                                |
| files.associations                  | \*.liquid → liquid   | Shopify theme files.                                                     |
| eslint.useFlatConfig                | true                 | Use ESLint 9 flat config.                                                |
| markdownlint.config                 | default, MD060 off   | Align with .markdownlint.json.                                           |
| Extensions                          | —                    | Sourced from `.cursor/extensions.json`.                                  |

**Gaps**: None critical. Optional: if Cursor supports more `cursor.*` keys in workspace (e.g. agent iterate on lints), add when documented.

---

## 6. Personal (user) Cursor settings — checklist

These are set in **Cursor Settings** (UI), not in the repo. Configure for best agent and Composer behavior. **Actionable tick list**: [CURSOR_UI_OPTIMIZATION_CHECKLIST_20260207.md](CURSOR_UI_OPTIMIZATION_CHECKLIST_20260207.md) (Iterate on Lints, Auto-apply to files outside context, and all §6 items).

| Setting area              | Recommendation                                                                                                                                                                                                                                                                                                              |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Models**                | Choose default model for Agent; consider Max Mode / larger context for complex tasks.                                                                                                                                                                                                                                       |
| **Chat & Composer**       | **Agent mode stickiness**: On if you want Agent mode to persist across new conversations. **Auto-apply to files outside context**: On to let agent edit files not currently open. **Iterate on Lints (Beta)**: On so agent fixes linter errors during runs. **Large context**: On for large codebases if you have capacity. |
| **Features → Editor**     | **Index new files by default**: On. **Git graph relationships**: On to improve context (if acceptable). **Hierarchical Cursor Ignore**: On if you use nested .cursorignore.                                                                                                                                                 |
| **Ignore files (global)** | Add `**/.env`, `**/.env.*`, `**/*.key`, `**/*.pem` if you want global protection across all projects.                                                                                                                                                                                                                       |
| **Rules (user)**          | Optional: e.g. "Reply concisely; avoid filler." or "Prefer Windows paths in scripts when in this environment."                                                                                                                                                                                                              |
| **Notifications**         | Enable for parallel agents / worktrees so you know when runs complete.                                                                                                                                                                                                                                                      |

---

## 7. Extensions alignment

All recommended extensions are **free**, **guru/expert-approved**, and **compatible** with this repo (Node, ESLint, Prettier, Vitest, Playwright, Shopify Liquid, PowerShell, Codacy, Markdown, YAML).

| Source                      | Extensions                                                                                                                                                                                                                                                            |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **.cursor/extensions.json** | EditorConfig, PowerShell, Prettier, ESLint, Playwright, Vitest, GitLens, GitHub PR, dotenv, markdownlint, YAML, TypeScript Next, Tailwind, auto-rename-tag, path-intellisense, **Shopify Theme Check**, **Codacy**, Python (18). Copilot/Copilot Chat omitted (paid). |

**Done**: **.cursor/extensions.json** is the tracked source for extension recommendations in this repo. No paid extensions (e.g. Copilot) are in the list; add them locally if desired.

---

## 7a. Extensions in-depth (Playwright, Vitest, Shopify Liquid, Auto Rename Tag)

Per [.cursor/plans/extensions_setup_and_utilization.plan.md](../../.cursor/plans/extensions_setup_and_utilization.plan.md):

- **Playwright**: Use Testing sidebar; gear icon to switch between `playwright.config.js` and `playwright.shopify.config.js`. Enable Show Browser for live debugging; Trace Viewer for flaky tests. CodeGen for new tests.
- **Vitest**: Run from Testing sidebar; use "Run Tests with Coverage" or `npm run test:coverage`. Watch mode: `npm run test`.
- **Shopify Liquid**: Requires `.theme-check.yml` at repo root for activation. Liquid formatter: `shopifyLiquid.formatterDevPreview: true`; `[liquid]` defaultFormatter: `Shopify.theme-check-vscode`. Theme Check CLI: `scripts/shopify/theme-check.ps1`.
- **Auto Rename Tag**: Works with HTML and Liquid. `editor.linkedEditing: false` avoids conflict on HTML files.

---

## 7b. Known issues and inhibiting factors

| Issue                                            | Impact                                 | Mitigation                                  |
| ------------------------------------------------ | -------------------------------------- | ------------------------------------------- |
| Codacy ESLint 8 vs repo ESLint 9                 | Duplicate or conflicting lint results  | Document; verify Codacy flat config support |
| Shopify Liquid formatter dev preview             | May be unstable                        | Fallback: disable formatOnSave for liquid   |
| Theme Check requires .theme-check.yml            | Extension will not activate without it | Create at repo root (done)                  |
| Playwright baseURL vs webServer                  | Tests may hit wrong URL                | Verify test intent                          |
| run-all.ps1 does not run test:shopify by default | Shopify E2E not in "all" run           | Use `-Shopify` flag                         |

---

## 8. Worktrees and tasks

- **worktrees.json**: `setup-worktree` / `setup-worktree-windows` run `npm install` and copy `.env.local` from root worktree into the new worktree (when present), so parallel agents have env; `inventoryDoc` still points to `docs/status/WORKTREE_INVENTORY.md`, but agents should trust live `git worktree list` first because that doc is a documented local snapshot.
- **tasks.json**: Setup, credentials, Shopify theme dev/pull, quality gate/fix, deterministic tests, preview/apply product sync, runbook, pipeline verify, E2E, desktop automation. PowerShell-backed tasks now route through a cross-platform Node launcher for Linux/cloud parity.

---

## 9. Ignore files

- **`.cursorignore`**: Implemented at repo root for secrets/build/log noise (`.env*`, keys, node_modules, dist/build, logs, cache).
- **`.cursorindexingignore`**: Implemented to keep archive/generated history out of indexing while preserving normal file access when explicitly needed.
- **Template**: [docs/status/CURSORIGNORE_TEMPLATE.txt](CURSORIGNORE_TEMPLATE.txt) remains a reference template if patterns need expansion.

---

## 10. Implemented and recommended changes

| #   | Change                                                                                                       | Status                                     |
| --- | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------ |
| 1   | Unify extensions: use extensions.json as single source; remove extensions.recommendations from settings.json | ✅ Done                                    |
| 2   | `.cursorignore` at repo root for secrets/build noise                                                         | ✅ Done                                    |
| 3   | Optional: ao-guru globs for `src/**/*.ts`, `**/*.test.*`                                                     | ✅ Done                                    |
| 4   | Add command `/pr` and align it to branch-finalization workflow                                               | ✅ Done (`.cursor/commands/pr/COMMAND.md`) |
| 5   | Worktrees: copy `.env.local` into new worktrees so agents have env                                           | ✅ Done (worktrees.json)                   |
| 6   | Document personal settings checklist (§6)                                                                    | Done (this doc; linked from AGENTS.md)     |
| 7   | Add `.cursorindexingignore` to reduce archive/generated indexing noise                                       | ✅ Done                                    |

---

## 11. Cross-references

- **Codacy MCP troubleshooting**: [docs/CODACY_MCP_SETUP.md](../CODACY_MCP_SETUP.md)
- **Agentic setup (rules/skills/subagents)**: [AGENTIC_SETUP_AUDIT.md](AGENTIC_SETUP_AUDIT.md)
- **Agent workflow (Shopify, preview, runbook)**: [OPERATOR_RUNBOOK.md](../../OPERATOR_RUNBOOK.md), [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](../AGENT_WORKFLOW_CURSOR_SHOPIFY.md)
- **Skills index**: [.cursor/skills/README.md](../../.cursor/skills/README.md)
- **Reports index**: [INDEX_REPORTS.md](INDEX_REPORTS.md)
