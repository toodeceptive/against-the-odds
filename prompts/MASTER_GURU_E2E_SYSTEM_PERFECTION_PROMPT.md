# Master Guru E2E System Perfection Prompt (lead-agent / worktree-coordinated)

**Use this prompt to drive repeated, multi-agent, multifaceted work until the entire system is perfect and fully usable by Cursor AI agents. Lead agent may coordinate worktrees and confer via shared status/docs.**

---

## Master directive

I approve you to **repeatedly run multi-agent, multifaceted tasks** to finish and improve the setup and to use **live-testing** to ensure **complete end-to-end system functionality and optimization** until the entire system is perfect.

- **Employ subagents and as many guru expert teams as needed** to work continuously, step by step, **tracking progress** until the task is finished.
- **Automatically access, automate, and use** as needed: **PC control, mouse, screen reading, PC navigation, browser usage** (Cursor browser MCP, Playwright E2E, desktop-automation) to complete every aspect of necessary project actions.
- **Context**: I prompt Cursor agents in the local Cursor desktop app to **edit Shopify/theme** and **access my personal accounts and websites** using the best methods, practices, processes, strategies, systems, automations, integrations, coding, scripting, pipelines, and agentic workflows.
- **Method**: Use **deep-research PP cycles** to improve, enhance, and optimize until the system is **perfectly efficient, effective, and flawless**, and **seamlessly usable by Cursor AI agents** for any work or tasks I assign.
- **Worktree coordination**: If you are the lead agent across worktrees, confer by exchanging live data (read/write `docs/status/`, `.cursor/plans/`, runbook results); choose the best methods from group results; do not stop until complete. If work stops short, assign new guru expert agent/subagent teams to the workflow until finished.

---

## Scope (what “entire system” means)

- **Credentials and env**: `.env.local`, Shopify token/theme ID, GitHub token; full-setup and verify-credentials.
- **Pipeline**: `verify-pipeline.ps1`, `run-runbook.ps1`, CI workflows, quality gates (format, lint, test:unit, test:integration).
- **Shopify**: Theme dev/pull/push, product sync, store operations, preview-before-apply workflow.
- **Browser and PC**: Cursor browser MCP, Playwright E2E, desktop-automation (mouse, keyboard, screen, navigation), credential flows.
- **Repo and Cursor**: Scripts (portable paths, parse-all), docs (OPERATOR_RUNBOOK, GURU_PP_OPERATOR_GUIDE), Cursor tasks, rules, skills, agents.

---

## Execution rules

1. **Baseline**: Follow [docs/GURU_PP_OPERATOR_GUIDE.md](../docs/GURU_PP_OPERATOR_GUIDE.md) and [OPERATOR_RUNBOOK.md](../OPERATOR_RUNBOOK.md); use Prodigy Protocol and agentic-performance skills.
2. **Safety**: Preview before apply for store changes; no secrets in commits. See [AGENTS.md](../AGENTS.md) and `.cursor/rules/`.
3. **Live-testing**: Run `npm run quality`, `.\scripts\verify-pipeline.ps1`, and `.\scripts\run-runbook.ps1` (and E2E/Playwright/desktop when relevant) to verify each improvement.
4. **Tracking**: Log progress in `docs/status/` (e.g. CONSOLIDATION_LOG.md); use todo lists and plans in `.cursor/plans/` for multi-step work.
5. **Iterate**: Use PP audit loops (aligned / efficient / improvable / obsolete) and deep-research cycles until the system is perfect.
6. **Completion**: Optimize, finalize, commit, push, and pull as needed. Do not stop until complete; if stopped short, use Cursor to assign new guru expert agent/subagent teams until finished.

---

## Success criteria

The system is **finished** when:

- All quality gates and pipeline steps pass (with credentials set where required).
- Agents can complete setup, credentials, theme/Shopify, and GitHub flows using scripts, browser, and PC automation as needed.
- Runbooks and operator guide are accurate; improvements are documented and wired into the pipeline.
- Any work or task the user prompts in Cursor can be executed by agents in a seamless, efficient, and flawless way.

---

_Save and re-use this prompt to drive continuous guru-led perfection. Lead agent: coordinate worktrees via `docs/status/` and `.cursor/plans/`; assign new teams if work stops short._
