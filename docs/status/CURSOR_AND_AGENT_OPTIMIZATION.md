# Cursor and agent optimization — full audit

**Purpose**: In-depth cross-comparative audit of all Cursor-related settings, rules, skills, subagents, commands, context, extensions, and tools to identify issues, enhancements, and implementations that improve personal Cursor settings and agent performance.

**Scope**: Project (`.cursor/`, `AGENTS.md`, repo config) and **personal (user)** settings to set in Cursor UI. Last review: 2026-02-06.

---

## 1. Executive summary

| Area                     | Status           | Actions                                                                                           |
| ------------------------ | ---------------- | ------------------------------------------------------------------------------------------------- |
| Rules                    | ✅ Coherent      | 5 always-on + 1 agent-decided; no conflicts. Optional: add globs to ao-guru.                      |
| Skills                   | ✅ Complete      | 4 skills (pp, phantasm, godmode, agentic-performance); descriptions and triggers clear.           |
| Subagents                | ✅ 1 custom      | Verifier; built-in Explore/Bash/Browser used automatically.                                       |
| Commands                 | ✅ 1 command     | `/review`; add `/pr`, `/fix-issue` when needed.                                                   |
| Context                  | ✅ Aligned       | github, shopify, node-and-automation match docs and workflows.                                    |
| AGENTS.md                | ✅ Consistent    | Mirrors safety rules; points to .cursor/rules and docs.                                           |
| Project settings         | ✅ Good          | Worktree opts set; extensions via extensions.json only.                                           |
| Extensions               | ✅ Single source | .cursor/extensions.json only (no duplicate in settings.json).                                     |
| .cursorignore            | 📋 Template      | Copy [CURSORIGNORE_TEMPLATE.txt](CURSORIGNORE_TEMPLATE.txt) to repo root as `.cursorignore` once. |
| Personal (user) settings | 📋 Checklist     | Set in Cursor Settings UI (§6).                                                                   |

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
- **Subagents**: Verifier (`.cursor/agents/verifier.md`) for independent lint/test/build pass. Built-in Explore, Bash, Browser used by Cursor when appropriate.
- **Commands**: `/review` — lint, format, tests, summary; `/pr` — commit, push, open PR (see `.cursor/commands/pr/COMMAND.md`).

---

## 4. Context and AGENTS.md

- **context/github.md**: Repo, branch strategy, workflows, secrets. ✅
- **context/shopify.md**: Store, theme, scripts, workflow doc refs. ✅
- **context/node-and-automation.md**: Playwright vs desktop-automation, npm scripts, Cursor tasks. ✅
- **AGENTS.md**: Permission, safety (preview, no secrets), browser use, workflow pointers. Aligned with .cursor/rules. ✅

---

## 5. Project settings (`.cursor/settings.json` and `.vscode/settings.json`)

Workspace settings live in `.cursor/settings.json` (Cursor) and are mirrored in `.vscode/settings.json` for VS Code and cross-editor compatibility.

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
| Extensions                          | —                    | Sourced from .cursor/extensions.json and .vscode/extensions.json.        |

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
| **.vscode/extensions.json** | Same list as above for VS Code and Cursor when opening via .vscode.                                                                                                                                                                                                   |

**Done**: **.cursor/extensions.json** and **.vscode/extensions.json** are the single source for extension recommendations. No paid extensions (e.g. Copilot) in the list; add locally if desired. Cursor and VS Code both read the respective extensions.json.

---

## 8. Worktrees and tasks

- **worktrees.json**: `setup-worktree` / `setup-worktree-windows` run `npm install` and copy `.env.local` from root worktree into the new worktree (when present), so parallel agents have env; `inventoryDoc` → docs/status/WORKTREE_INVENTORY.md. ✅
- **tasks.json**: Setup, credentials, Shopify theme dev/pull, lint, format, tests, runbook, pipeline verify, E2E, desktop automation. ✅ Aligned with context and docs.

---

## 9. .cursorignore

- **Template**: [docs/status/CURSORIGNORE_TEMPLATE.txt](CURSORIGNORE_TEMPLATE.txt) — copy its contents to repo root as **`.cursorignore`** (one-time). Cursor then excludes those paths from semantic search, Agent, and @ mentions.
- **Suggested patterns**: `.env*`, `*.key`, `*.pem`, `node_modules/`, `dist/`, `build/`, `*.log`, `logs/`, `.cache/`.

---

## 10. Implemented and recommended changes

| #   | Change                                                                                                       | Status                                     |
| --- | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------ |
| 1   | Unify extensions: use extensions.json as single source; remove extensions.recommendations from settings.json | ✅ Done                                    |
| 2   | .cursorignore: copy [CURSORIGNORE_TEMPLATE.txt](CURSORIGNORE_TEMPLATE.txt) to repo root as `.cursorignore`   | One-time (user)                            |
| 3   | Optional: ao-guru globs for `src/**/*.ts`, `**/*.test.*`                                                     | ✅ Done                                    |
| 4   | Optional: add command `/pr` (see cookbook)                                                                   | ✅ Done (`.cursor/commands/pr/COMMAND.md`) |
| 5   | Worktrees: copy `.env.local` into new worktrees so agents have env                                           | ✅ Done (worktrees.json)                   |
| 6   | Document personal settings checklist (§6)                                                                    | Done (this doc; linked from AGENTS.md)     |

---

## 11. Cross-references

- **Codacy MCP troubleshooting**: [docs/CODACY_MCP_SETUP.md](../CODACY_MCP_SETUP.md)
- **Agentic setup (rules/skills/subagents)**: [AGENTIC_SETUP_AUDIT.md](AGENTIC_SETUP_AUDIT.md)
- **Agent workflow (Shopify, preview, runbook)**: [OPERATOR_RUNBOOK.md](../../OPERATOR_RUNBOOK.md), [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](../AGENT_WORKFLOW_CURSOR_SHOPIFY.md)
- **Skills index**: [.cursor/skills/README.md](../../.cursor/skills/README.md)
- **Reports index**: [INDEX_REPORTS.md](INDEX_REPORTS.md)
