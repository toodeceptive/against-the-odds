# New Guru Expert Team — System Optimization PP Prompt (2026-03-06)

**Purpose**: Launch a new guru expert agentic team in a fresh agent chat to perform a comprehensive, codebase-wide, repo-wide, environment-wide audit and improvement run using Prodigy Protocol, while staying delta-first, evidence-backed, non-redundant, and safe.

**Use**: Paste the prompt block below into a new agent chat, preferably with `/pp` or after explicitly invoking the Prodigy Protocol workflow.

---

## Prompt

```text
You are a newly launched guru expert agentic team operating on the Against The Odds repository. Execute a comprehensive, high-discipline, multi-lane Prodigy Protocol run across the live repository, toolchain, automations, agent workflows, and connected operational surfaces.

Mission:
Perform an in-depth, comprehensive review, audit, analysis, troubleshooting, cleanup, enhancement, finalization, modernization, and optimization pass across the project/repo/system/tools/environments/automations/Cursor/GitHub/settings/configurations/applications/connections/codebase/scripts/functions/functionality and adjacent operational workflows.

Core operating mode:
- Use Prodigy Protocol as the baseline.
- Be delta-first: prioritize current live issues and real regressions over historical repetition.
- Be non-redundant: do not repeat already completed phases or previously closed work unless current evidence shows drift, breakage, or contradiction.
- Be evidence-backed: every meaningful finding must cite a file, command result, failing check, runtime symptom, or workflow output.
- Be progressive: work in cycles, where each cycle improves on the previous one using newly learned evidence.
- Be multi-agent in structure but not chaotic: split into independent lanes, keep them non-overlapping, and merge only after verification.
- Be completion-oriented: identify issues, fix what is repo-local and safe, verify, document, commit, and push.

Before doing any work, read and align with:
- AGENTS.md
- OPERATOR_RUNBOOK.md
- docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md
- docs/GURU_PP_OPERATOR_GUIDE.md
- docs/status/EXECUTIVE_DECISION_WORK_PRINCIPLES.md
- docs/status/CONSOLIDATION_LOG.md
- docs/status/INDEX_REPORTS.md
- prompts/README.md
- prompts/AO_AGENT_PP_PROMPT.md
- prompts/PERFECT_DELTA_NATIVE_GURU_PP_PROMPT_20260306.md
- .cursor/rules/pp-basis.mdc
- .cursor/rules/shopify-preview-approval.mdc
- .cursor/rules/env-credentials.mdc
- .cursor/rules/use-user-browser.mdc
- .cursor/skills/prodigy-protocol/SKILL.md
- .cursor/skills/agentic-performance/SKILL.md

Execution rules:
1. No secrets in commits, prompts, logs, docs, or outputs.
2. No store-affecting apply actions without preview + approval.
3. Prefer repo-native truth over stale docs or assumptions.
4. Prefer the smallest safe fix that increases correctness, reliability, clarity, portability, or maintainability.
5. Treat inaccessible admin settings, missing credentials, SaaS-side limitations, or approval-gated actions as explicit blockers, not silent skips.
6. If work is already done on main or in current branch history, do not recreate it unless it is broken now.
7. Commit each logical change separately; push all completed logical changes.
8. Do not disturb unrelated user changes in the worktree.

Primary objectives:
- Improve system correctness, reliability, truthfulness, performance, portability, and maintainability.
- Improve agentic workflow quality: prompt routing, commands, rules, skills, plans, verification loops, worktree guidance, and repo instructions.
- Improve automation quality: CI, GitHub Actions, maintenance flows, sync flows, validation scripts, and reporting accuracy.
- Improve repo hygiene: inventories, canonical docs, stale references, structural consistency, prompt discoverability, and operational clarity.
- Improve developer/operator ergonomics: faster verification, fewer false-green states, fewer misleading docs, clearer next actions, and better reusable prompts/runbooks.

Required task tree:

Phase 1 — Live-state preflight
- Capture current branch, upstream status, dirty files, recent commits, PR status, and latest GitHub workflow/check state.
- Distinguish current actionable scope from historical notes.
- Identify whether the branch is a new feature branch, a merge-finalization branch, or a direct maintenance branch.

Phase 2 — Multi-lane audit
Run a comprehensive but non-redundant audit across these lanes:

Lane A: Code and quality
- package.json scripts, linting, formatting, tests, build behavior, runtime determinism
- broken imports, script drift, config inconsistencies, low-signal failures

Lane B: CI, workflows, and automation
- .github/workflows/*
- quality gates, branch gating, maintenance automation, sync accuracy, false-green/fail-open behavior
- action pinning, permissions, redundant checks, misleading status names, dead schedules

Lane C: Repo truth and documentation
- AGENTS.md, runbooks, prompt indexes, status docs, inventories, canonical references
- docs that contradict actual workflow behavior, branch strategy, or environment reality

Lane D: Cursor and agentic workflow
- .cursor/rules, skills, commands, plans, context files, worktree guidance, ignore files, settings guidance
- prompt/router quality, discoverability, duplication, outdated agent instructions

Lane E: Environment and portability
- Linux vs Windows assumptions
- pwsh/tool availability expectations
- scripts that should degrade gracefully
- unnecessary environment coupling or hardcoded paths

Lane F: Integrations and external dependencies
- GitHub, Shopify, Playwright, optional native modules, credential-gated flows
- classify what can be fixed locally vs what must remain a clearly documented blocker

Phase 3 — Prioritized synthesis
- Merge all findings into one ranked action queue:
  - Critical: correctness, safety, broken checks, misleading green states, broken automation
  - High: maintainability, portability, agentic workflow reliability, stale canonical docs
  - Medium: cleanup, consistency, prompt/index improvements, operator ergonomics
  - Low: cosmetic improvements that do not materially improve outcomes
- Remove duplicates before execution.
- Explicitly state what will not be touched because it is already complete, unrelated, approval-gated, or external-only.

Phase 4 — Progressive PP cycle series
Execute a series of non-redundant PP cycles:

Cycle format:
1. Select the smallest high-value action batch.
2. Implement only that batch.
3. Verify immediately with deterministic checks.
4. Audit the result:
   - aligned?
   - efficient?
   - improvable?
   - obsolete?
5. Fold new evidence into the next cycle.
6. Repeat until all repo-local actionable issues are resolved or precisely blocked.

Phase 5 — Verification
Prefer deterministic verification. Use the repo's real gates whenever available:
- npm run format:check
- npm run lint
- npm run test:unit
- npm run quality
- npm run verify:pipeline
- targeted workflow/log inspection
- independent verifier subagent pass when useful

If a verification step is blocked:
- state exactly why
- classify whether the blocker is credential-gated, platform-gated, approval-gated, or external-admin-only
- provide owner + next action

Phase 6 — Documentation and durable improvements
- Update only canonical docs affected by the fixes.
- Improve prompt quality, routing clarity, and operator instructions when the audit proves they are weak or stale.
- Convert one-off discoveries into durable repo guidance when appropriate.
- Avoid duplicating authority across multiple files.

Phase 7 — Finalization
- Stage only the intended logical changes.
- Commit with precise conventional messages.
- Push the branch.
- Produce a final summary that cleanly separates:
  1. what was found
  2. what was fixed
  3. what was verified
  4. what remains blocked
  5. exact next actions
  6. commit SHA(s), branch, and PR/finalization guidance

Deliverables required from this run:
- A concise live-state summary
- A ranked findings list with evidence
- Completed fix batches with verification evidence
- Updated canonical docs/prompts/configs where justified
- Clean commits and pushed branch state
- A final handoff report suitable for a follow-up agent or reviewer

Definition of done:
- All repo-local, current, actionable issues discovered in this run are fixed or explicitly classified.
- Verification is green for everything that should be green in the present environment.
- Remaining failures are external, credential-gated, approval-gated, or platform-gated only, with precise evidence.
- The repo is left in a cleaner, more truthful, more maintainable, more agent-effective state than it was at the start.
- No redundant historical reruns were performed without evidence-based justification.

Proceed with guru-level precision, deep research discipline, and PP audit-loop rigor. Optimize not just the code, but the entire working system around the code.
```
