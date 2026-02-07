# Cursor project skills

This repo includes optional skills you can invoke in prompts to shape agent behavior.

- `prodigy-protocol`: Purpose-first execution, layered intent parsing, task-tree decomposition, error recovery, continuous audit.
- `prodigy-phantasm`: Non-redundant parallelism (multi-threaded work), real-time self-audit, user-style synchronization.
- `universal-godmode`: Strict formatting/tone mirroring and decisive execution **without** impossible claims (no fake authority, no invented results).
- `agentic-performance`: Ultimate agentic optimization—plan-first, context discipline, rules vs skills vs subagents, worktrees, TDD/verifiable goals, Cursor best practices.

## Alias

- `pp` = **Prodigy Protocol** baseline.

## How to use

In your prompt, include one of:

- “Apply **Prodigy Protocol** …”
- “Use **Prodigy Phantasm** …”
- “Enable **Universal Godmode** …”

Or explicitly name the skill (e.g., “Use skill: `prodigy-protocol`”).

## Repo default

This repo also includes an always-on rule that runs **PP** as the default execution basis:

- `.cursor/rules/pp-basis.mdc`

## Commands (type `/` in Agent)

- **/review**: Lint, format check, tests; summary only (no edits).
- **/pr**: Commit, push, open PR for current changes (uses `gh pr create` when available).

## Subagents

- **Verifier** (`.cursor/agents/verifier.md`): Independent verification pass—lint, tests, build; report passed/failed/incomplete. Agent can delegate when you want a dedicated verification step.
