---
name: agentic-performance
description: Ultimate agentic performance enhancement—plan-first execution, context discipline, rules vs skills vs subagents, worktrees, TDD/verifiable goals, and Cursor best practices. Use when optimizing agent workflows, configuring Cursor, or when the user asks for best-in-class agent performance, worktrees, subagents, or skills.
---

<!-- markdownlint-disable MD060 -->

# Agentic Performance (Ultimate)

Apply this skill when optimizing agent behavior, configuring Cursor, or pursuing best possible outcomes. Integrates with the **Prodigy Protocol (pp)** baseline already in effect.

## 1. Plan before coding

- **Plan Mode** (Shift+Tab in agent input): agent researches codebase → clarifies requirements → produces implementation plan → waits for approval before building.
- Save plans to `.cursor/plans/` for documentation, resume, and future agent context.
- If the agent drifts: revert, refine the plan, re-run rather than fix in-place.

## 2. Verifiable goals

- Prefer **tests** as acceptance criteria: write tests first (TDD), then implementation; agent iterates until tests pass.
- Use **typed languages, linters, and clear success signals** so the agent can validate changes.
- Long-running loops: use **hooks** (e.g. `.cursor/hooks.json` stop hook) to iterate until a condition (e.g. "DONE" in scratchpad, all tests pass).

## 3. Context discipline

- **Let the agent find context**: avoid tagging every file; use semantic search and grep. Tag only when the file is known.
- **@-mentions**: use **@Past Chats** to pull prior context into a new conversation; use **@Branch** to give agent current branch/changes context (“review changes on this branch”, “what am I working on?”).
- **New conversation when**: switching task/feature, agent confused or repeating mistakes, or one logical unit done.
- **Continue when**: iterating same feature, agent needs prior context, or debugging recent work.

## 4. Rules vs skills vs subagents

| Use                                      | For                                                                                                                                                |
| ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Rules** (`.cursor/rules/*.mdc`)        | Static, always-on or glob-scoped context (commands, style, workflow). Keep focused; reference files, don’t copy.                                   |
| **Skills** (`.cursor/skills/*/SKILL.md`) | Dynamic, on-demand capabilities and workflows. Use when task is single-purpose or repeatable; use `disable-model-invocation: true` for slash-only. |
| **Subagents** (`.cursor/agents/*.md`)    | Context isolation, parallel workstreams, or specialized multi-step work. Use for long research, heavy exploration, or independent verification.    |

Precedence: Local (manual @) → Auto Attached (globs) → Agent Requested → Always.

## 5. Worktrees and parallel agents

- **Worktrees**: each parallel agent runs in its own worktree (isolated files). Use for multiple models on same prompt (Best-of-N) or separate tasks.
- **Apply**: when done, use "Apply" to merge worktree changes back to your branch.
- **Setup**: configure `.cursor/worktrees.json` with `setup-worktree` / `setup-worktree-windows` for install, env copy, migrations.
- Best-of-N: run same prompt on multiple models; compare and apply the best result. Enable notifications for completion.

## 6. Commands and hooks

- **Commands** (`.cursor/commands/<name>/COMMAND.md`): multi-step workflows triggered by `/` (e.g. `/pr`, `/fix-issue 123`, `/review`, `/update-deps`). Check into git for team use.
- **Hooks** (`.cursor/hooks.json`): run scripts before/after agent actions (e.g. stop-hook to continue until tests pass or goal met).

## 7. Prompt and review discipline

- **Specific prompts** beat vague ones: include patterns, paths, and constraints (e.g. "use patterns in `__tests__/`, no mocks").
- **Review carefully**: read diffs; use Agent Review (Find Issues) and Bugbot for PRs.
- **Iterate on setup**: add rules/skills when the agent repeats the same mistake; don’t over-optimize upfront.

## 8. Built-in subagents (automatic)

Cursor uses **Explore** (codebase search), **Bash** (shell commands), **Browser** (MCP) as subagents when appropriate—no config needed. Custom subagents go in `.cursor/agents/` (project) or `~/.cursor/agents/` (user).

## 9. Ignore files and indexing

- **`.cursorignore`** (repo root): Excludes paths from semantic search, Agent, and @ mentions. Use .gitignore-style patterns. Improves performance and limits exposure of secrets; add `.env*`, `**/secrets*`, heavy/vendor dirs as needed. Terminal/MCP are not restricted by .cursorignore.
- **`.cursorindexingignore`**: Excludes from indexing only; files remain @-mentionable. Use when you want search to skip certain dirs but still allow explicit reference.

## 10. Debug Mode and Cloud Agents

- **Debug Mode** (agent dropdown): For tricky, reproducible bugs. Agent generates hypotheses → instruments code with logging → you reproduce → agent uses runtime data for targeted fix → removes instrumentation. Use for race conditions, perf issues, regressions.
- **Cloud Agents** (cursor.com/agents, editor, Slack): Async agents in remote sandbox; clone → branch → work → open PR. Use for bug fixes, refactors, tests, docs while you do other work. Review and merge PR when done.

## 11. Progressive skill layout

- Keep `SKILL.md` under ~500 lines; put detail in `references/` or `scripts/`.
- Use `scripts/` for runnable automation; reference with relative paths from skill root.
- Use `references/` for on-demand docs so context stays efficient.

## 12. Rules vs AGENTS.md

- **Project rules** (`.cursor/rules/*.mdc`): Scoped (globs, always, agent-decided, manual); version-controlled; best for domain knowledge, workflows, style.
- **AGENTS.md** (repo root): Plain markdown, no metadata; simple alternative for straightforward project instructions. Cursor supports both; use rules when you need scoping or multiple files.

## Quick checklist (high-performance run)

- [ ] Goal is clear and verifiable (tests, lint, or explicit success criteria).
- [ ] Plan created or refined (Plan Mode or .cursor/plans/) for non-trivial work.
- [ ] Correct use of rules (static) vs skills (dynamic) vs subagents (isolated/parallel).
- [ ] Worktree/parallel used when comparing models or isolating heavy work.
- [ ] Commands/hooks used for repeatable workflows.
- [ ] Context kept clean (new conversation when switching focus; @Past Chats when resuming).
- [ ] .cursorignore in place for performance/secrets; Debug Mode or Cloud Agent chosen when appropriate.

For detailed references, sources, and audit, see [references/SOURCES.md](references/SOURCES.md) and repo [docs/status/AGENTIC_SETUP_AUDIT.md](../../../docs/status/AGENTIC_SETUP_AUDIT.md).
