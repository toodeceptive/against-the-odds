# Prompts — Index

**Purpose**: Index of agent and guru prompts. Use canonical prompts first; legacy/one-off prompts are kept for reference.

**Last updated**: 2026-02-27.

---

## Canonical (use first)

| Prompt                                           | Purpose                                                                             |
| ------------------------------------------------ | ----------------------------------------------------------------------------------- |
| **AO_AGENT_PP_PROMPT.md**                        | AO agent in Prodigy Protocol mode. Invoke via `/pp` or `-pp`. Primary PP+AO prompt. |
| **PP_USER_PROMPT.md**                            | **Your go-to /pp prompt** — paste with /pp; empty = full project cycle.             |
| **PP_EXECUTE_PROJECT_PROMPT.md**                 | Full project PP cycle (delta audit, fixes, verify, log). Use with `/pp`.            |
| **MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT.md**  | Lead-agent perfection prompt; worktree-coordinated; loop until complete.            |
| **GURU_EXPERT_AUDIT_AND_FIX_PROMPT.md**          | Self-execute guru audit: audit → fix → verify → document; PP phases.                |
| **NEW_AGENT_FULL_SCALE_GURU_PP_INSTRUCTIONS.md** | Instructions for new agent; paste prompt for new instance.                          |

---

## Guru finalization (V3–V7)

| Prompt                                                             | Purpose                                                                     |
| ------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| **LOCAL_MAIN_GURU_FINALIZATION_PROMPT_V7_DELTA_ONLY_EXTERNALS.md** | Delta-only for unresolved external/manual blockers. Latest in V3–V7 series. |
| LOCAL_MAIN_GURU_FINALIZATION_PROMPT_V6_OPTIMAL_INTEGRATIONS.md     | V6: strict lanes, integration cost/value policy.                            |
| LOCAL_MAIN_GURU_FINALIZATION_PROMPT_V5.md                          | V5: non-redundant closure, team roles.                                      |
| LOCAL_MAIN_GURU_FINALIZATION_PROMPT_V4_CLOSURE_ONLY.md             | V4: delta-only closure pass.                                                |
| LOCAL_MAIN_GURU_FINALIZATION_PROMPT_V3.md                          | V3: local main-branch closure.                                              |

Use V7 for delta-only externals; V6 for integration-aware closure. Older Vx kept for reference.

---

## Master / full-scale (alternatives)

| Prompt                                                | Purpose                                                      |
| ----------------------------------------------------- | ------------------------------------------------------------ |
| **MASTER_FULL_SCALE_GURU_PP_PROMPT.md**               | Perfected master approval; full-scale guru PP; 100-step ref. |
| MASTER_FULL_SYSTEM_OVERHAUL_UNIFIED_GURU_PP_PROMPT.md | Full-system overhaul; Phase 0 audit; 100-step PP.            |
| MASTER_10_EXPERT_SYSTEM.md                            | 10-expert system.                                            |

---

## Expert and finalization specialists

| Pattern                  | Purpose                                                                                                                                                                                     |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **expert-\*.md** (01–10) | Domain experts: security, performance, code-quality, testing, docs, CI/CD, integrations, frontend, database, dev experience.                                                                |
| **finalization-\*.md**   | Specialist finalization prompts (shopify, analytics, finance, GTM, support, release, content, workflow, business-plan, ops, tech-release, chief-of-staff, legal-risk, security-compliance). |

Use when assigning work to a specific guru/expert domain.

---

## Legacy / one-off

| Prompt                                     | Note                     |
| ------------------------------------------ | ------------------------ |
| FULL_SYSTEM_TEST_AND_IMPROVEMENT_PROMPT.md | Full system test run.    |
| PROCEED_UNFINISHED_WORKS_GURU_PROMPT.md    | Proceed unfinished work. |
| AGENT_SELF_IMPROVEMENT_EXECUTION_PROMPT.md | Self-improvement.        |
| PERFECT_EXECUTION_PROMPT.md                | Perfect execution.       |
| head-guru-orchestrator.md                  | Orchestrator role.       |

---

## Decision tree

See `docs/AGENT_PROMPT_DECISION_TREE.md` for "which prompt when" guidance.
