# AO Agent — Prodigy Protocol mode (/pp)

Invoke the Against The Odds agent in Prodigy Protocol (PP) mode.

1. **Load context**: Read [prompts/AO_AGENT_PP_PROMPT.md](prompts/AO_AGENT_PP_PROMPT.md) and invoke the prodigy-protocol skill (`.cursor/skills/prodigy-protocol/SKILL.md`).

2. **Parse task**: Treat the remainder of the user's message (after `/pp` or `-pp`) as the task. **If empty or "run PP"**: use [prompts/PP_USER_PROMPT.md](prompts/PP_USER_PROMPT.md) default (full project cycle per PP_EXECUTE_PROJECT_PROMPT). If intent unclear, ask once.

3. **Execute**: Apply the PP workflow—task tree, smallest step, validate, audit loop.

4. **Report**: What changed, why, and how to verify.
