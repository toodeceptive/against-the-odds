# Agentic setup audit and cross-comparison

<!-- markdownlint-disable MD060 -->

**Purpose**: In-depth audit of the repo’s agentic performance setup (rules, skills, subagents, settings, worktrees), cross-comparison to avoid redundancy, gap analysis, and a permanent improvement checklist.

**Last substantive review**: 2026-02-06.

---

## 1. Inventory of artifacts

| Artifact            | Path                                          | Type     | Scope                    |
| ------------------- | --------------------------------------------- | -------- | ------------------------ |
| PP baseline         | `.cursor/rules/pp-basis.mdc`                  | Rule     | Always                   |
| Agent permissions   | `.cursor/rules/agent-permissions.mdc`         | Rule     | Always                   |
| Env credentials     | `.cursor/rules/env-credentials.mdc`           | Rule     | Always                   |
| Shopify preview     | `.cursor/rules/shopify-preview-approval.mdc`  | Rule     | Always                   |
| User browser        | `.cursor/rules/use-user-browser.mdc`          | Rule     | Always                   |
| AO Guru             | `.cursor/rules/ao-guru.rules.md`              | Rule     | Agent-decided (no globs) |
| Prodigy Protocol    | `.cursor/skills/prodigy-protocol/SKILL.md`    | Skill    | Agent-decided            |
| Prodigy Phantasm    | `.cursor/skills/prodigy-phantasm/SKILL.md`    | Skill    | Agent-decided            |
| Universal Godmode   | `.cursor/skills/universal-godmode/SKILL.md`   | Skill    | Agent-decided            |
| Agentic Performance | `.cursor/skills/agentic-performance/SKILL.md` | Skill    | Agent-decided            |
| Verifier            | `.cursor/agents/verifier.md`                  | Subagent | Delegated                |
| Worktrees config    | `.cursor/worktrees.json`                      | Config   | Worktrees                |
| Cursor settings     | `.cursor/settings.json`                       | Config   | IDE + worktree opts      |

---

## 2. Cross-comparison matrix (who covers what)

| Concern                      | pp-basis  | prodigy-protocol | prodigy-phantasm | universal-godmode   | agentic-performance       | ao-guru            | Verifier       |
| ---------------------------- | --------- | ---------------- | ---------------- | ------------------- | ------------------------- | ------------------ | -------------- |
| Purpose-first / no filler    | ✅        | ✅               | ✅ (via pp)      | ✅ (via pp)         | —                         | —                  | —              |
| Intent parsing / constraints | ✅        | ✅               | —                | ✅ (upgrade inputs) | —                         | —                  | —              |
| Task trees / parallelism     | ✅        | ✅               | ✅ (threads)     | —                   | ✅ (worktrees, subagents) | —                  | —              |
| Verification / lint/test     | ✅        | ✅               | ✅               | —                   | ✅ (TDD, hooks)           | ✅ (quality gates) | ✅ (runs them) |
| Failure resilience           | ✅        | ✅               | —                | —                   | —                         | —                  | —              |
| Continuous audit             | ✅        | ✅               | ✅               | —                   | —                         | —                  | —              |
| User style mirroring         | ✅        | —                | ✅               | ✅                  | —                         | —                  | —              |
| Plan before code             | —         | —                | —                | —                   | ✅                        | —                  | —              |
| Context discipline           | —         | —                | —                | —                   | ✅                        | —                  | —              |
| Rules vs skills vs subagents | —         | —                | —                | —                   | ✅                        | —                  | —              |
| Worktrees / Best-of-N        | —         | —                | —                | —                   | ✅                        | —                  | —              |
| Commands / hooks             | —         | —                | —                | —                   | ✅                        | —                  | —              |
| Safety (secrets, approval)   | ✅ (refs) | ✅               | —                | ✅                  | —                         | ✅ (secrets)       | —              |
| Reporting / docs             | —         | ✅ (learning)    | —                | —                   | —                         | ✅                 | ✅ (report)    |

**Conclusion**: No harmful duplication. pp-basis is the minimal always-on core; prodigy-\* and universal-godmode deepen execution style; agentic-performance is the single place for workflow/tooling (plan, context, worktrees, commands, hooks). ao-guru and Verifier are project-specific (quality gates, verification pass).

---

## 3. Redundancy and overlap

- **pp-basis vs prodigy-protocol**: pp-basis is a short always-on rule; prodigy-protocol is the full skill. Correct: rule ensures baseline; skill adds detail when “pp” is invoked or relevant.
- **Verification**: pp-basis and prodigy-protocol say “verify”; ao-guru defines quality gates; Verifier subagent runs the checks. No conflict—different layers (principle vs project gates vs delegated run).
- **Safety**: pp-basis references env-credentials, shopify-preview, use-user-browser; universal-godmode and prodigy-protocol state “don’t override safety.” Consistent.

---

## 4. Gap analysis

| Gap                               | Severity | Recommendation                                                                                   |
| --------------------------------- | -------- | ------------------------------------------------------------------------------------------------ |
| No `.cursorignore`                | Medium   | Add for performance/security; Cursor indexes beyond .gitignore.                                  |
| No example `.cursor/commands/`    | Low      | Add at least one (e.g. `/review`) so “commands” in agentic-performance is implementable.         |
| Rule globs/priority               | Low      | ao-guru could use `globs: ["src/**/*.ts", "**/*.test.*"]` for file-scoped application; optional. |
| Debug Mode not mentioned          | Low      | Add to agentic-performance + SOURCES for “tricky bugs” path.                                     |
| Cloud Agents not mentioned        | Low      | Add to agentic-performance + SOURCES for async/PR workflow.                                      |
| @-mentions (@Branch, @Past Chats) | Low      | Already in agentic-performance (Past Chats); add @Branch to context discipline.                  |
| AGENTS.md vs rules                | Info     | Document in SOURCES: AGENTS.md = simple root instructions; rules = scoped/always.                |
| hooks.json / long-running loop    | Info     | Referenced in skill; no repo template—optional add.                                              |

---

## 5. Implementation checklist (permanent improvements)

- [x] PP baseline rule (pp-basis.mdc) always on.
- [x] Skills: prodigy-protocol, prodigy-phantasm, universal-godmode, agentic-performance.
- [x] Verifier subagent; worktrees.json (setup-worktree + Windows); settings (worktree count, cleanup, show in SCM).
- [ ] **.cursorignore**: one-time — copy [docs/status/CURSORIGNORE_TEMPLATE.txt](CURSORIGNORE_TEMPLATE.txt) to repo root as `.cursorignore`. See [Ignore files](https://cursor.com/docs/context/ignore-files).

- [x] **agentic-performance**: add .cursorignore, Debug Mode, Cloud Agents, @Branch; SOURCES updated.
- [x] **Optional**: `.cursor/commands/review/COMMAND.md` for “run linter + tests, summarize issues” (implemented).
- [x] **Optional**: `globs` on ao-guru for TS/test files (implemented: `src/**/*.ts`, `**/*.test.*`, etc.).
- [ ] **Ongoing**: When adding rules, prefer one concern per rule; reference files; keep &lt;500 lines.

---

## 6. How to use this audit

- **Before adding a new rule/skill**: Check §2 so it doesn’t duplicate an existing artifact; use §4 for gaps.
- **After changing .cursor/rules or .cursor/skills**: Re-run cross-comparison (§2) and gap list (§4); update checklist (§5).
- **Quarterly**: Re-verify Cursor docs (rules, skills, subagents, worktrees, ignore files) for new options; update SOURCES and this audit.
