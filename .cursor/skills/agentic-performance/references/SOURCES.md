# Agentic performance – sources and references

Curated from high-rated, up-to-date expert repos and official docs (2024–2026).

## Official Cursor

- [Context: Rules](https://cursor.com/docs/context/rules) – .mdc frontmatter (description, globs, alwaysApply); Always / Apply Intelligently / Apply to Specific Files / Manual; AGENTS.md; Team Rules; import from GitHub.
- [Context: Skills](https://cursor.com/docs/context/skills) – SKILL.md format, directories, scripts/references/assets, disable-model-invocation; /migrate-to-skills.
- [Context: Subagents](https://cursor.com/docs/context/subagents) – when to use subagents vs skills, foreground/background, built-in Explore/Bash/Browser; .cursor/agents/.
- [Context: Ignore files](https://cursor.com/docs/context/ignore-files) – .cursorignore (semantic search, Agent, @ mentions); .cursorindexingignore; .gitignore syntax.
- [Context: @ Mentions](https://cursor.com/docs/context/mentions) – @Files, @Folder, @Code, @Docs, @Web; @Past Chats, @Branch for context.
- [Configuration: Parallel Agents (Worktrees)](https://cursor.com/docs/configuration/worktrees) – worktrees.json, setup-worktree, Best-of-N, Apply, cleanup.
- [Cookbook: Agent Workflows](https://cursor.com/docs/cookbook/agent-workflows) – TDD, git commands, codebase understanding, long-running loops, design-to-code.
- [Blog: Best practices for coding with agents](https://cursor.com/blog/agent-best-practices) – plan-first, context discipline, rules vs skills, parallel agents, review.
- [Blog: Debug Mode](https://cursor.com/blog/debug-mode) – hypothesis → instrumentation → reproduce → targeted fix → verify; for tricky/reproducible bugs.
- [Cloud Agents](https://cursor.com/docs/cloud-agent) – remote sandbox, clone → branch → PR; cursor.com/agents; Slack/Linear/GitHub triggers.

## Agent Skills standard

- [Agent Skills (skill.md / agentskills.io)](https://skill.md/) – open format; portable, version-controlled, executable, progressive loading.
- Cursor loads from `.cursor/skills/`, `~/.cursor/skills/`, and Claude/Codex compat paths.

## Community and repos

- **sparesparrow/cursor-rules** – hierarchical rules (core, framework, domain, security, patterns); .mdc metadata, globs, priority, dependencies.
- **digitalchild/cursor-best-practices** – rule precedence, what to put in .mdc, instructions.md, .cursorignore.
- **Git worktrees + agents** – parallel worktrees for AI agents (e.g. Nx blog, Worktrunk CLI); 1–2 parallel agents often optimal.

## Subagent trade-offs

- **Benefits**: context isolation, parallel execution, specialized config.
- **Costs**: startup overhead, higher token use, can be slower for simple tasks. Use for complex/long/parallel work.

## Settings (performance-oriented)

- `cursor.worktreeCleanupIntervalHours` – cleanup interval for old worktrees.
- `cursor.worktreeMaxCount` – max worktrees per workspace (e.g. 20).
- `git.showCursorWorktrees` – show Cursor worktrees in SCM pane.

## Audit and maintenance

- Repo audit: [docs/status/AGENTIC_SETUP_AUDIT.md](../../../docs/status/AGENTIC_SETUP_AUDIT.md) – inventory, cross-comparison matrix, gaps, implementation checklist.
