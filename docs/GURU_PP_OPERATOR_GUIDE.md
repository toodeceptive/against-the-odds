# Guru / PP Operator Guide

**Purpose**: Single place for agents and operators on **how to execute like the guru team** and **what to run when**. This guide ties the Prodigy Protocol (PP) baseline, agentic-performance practices, and daily gates into one reference.

---

## Execution baseline: Prodigy Protocol (PP)

The repo uses the **Prodigy Protocol** as the execution baseline. Reference: [.cursor/skills/prodigy-protocol/SKILL.md](../.cursor/skills/prodigy-protocol/SKILL.md).

- **Purpose embedding**: Every action serves a clearly stated intent.
- **Task trees**: Segment work into verifiable sub-tasks; verify at each stage.
- **Audit loop**: After each step, check aligned / efficient / improvable / obsolete.
- **Failure resilience**: On error — capture symptom, small hypothesis, smallest fix, re-verify.

Use PP when you need **high-reliability autonomous task completion**, "recursive" execution, or user mentions Prodigy Protocol / pp.

---

## Plan-first and worktrees: Agentic Performance

For **optimization, worktrees, or best-in-class agent performance**, use: [.cursor/skills/agentic-performance/SKILL.md](../.cursor/skills/agentic-performance/SKILL.md).

- **Plan before coding**: Research → clarify → plan → approve → build; save plans to `.cursor/plans/`.
- **Verifiable goals**: Tests as acceptance criteria; typed languages and linters.
- **Context discipline**: Let the agent find context; use @Past Chats / @Branch when useful.
- **Worktrees**: Parallel agents in isolated worktrees; apply when done.

Use agentic-performance when optimizing agent workflows, configuring Cursor, or using worktrees/subagents.

---

## When to use which skill

| Situation                                                                         | Use                                                                   |
| --------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| High-reliability tasks, recursive execution, user says "pp" or "Prodigy Protocol" | **Prodigy Protocol** (pp)                                             |
| Optimization, worktrees, plan-first, Cursor/agent configuration                   | **Agentic Performance**                                               |
| User demands exact structure/tone, "godmode", decisive decomposition              | **Universal Godmode** (see .cursor/skills/universal-godmode/SKILL.md) |
| Multi-threaded execution, final fusion build, Prodigy Phantasm                    | **Prodigy Phantasm** (see .cursor/skills/prodigy-phantasm/SKILL.md)   |

---

## Multi-cycle research approach

For **deep-research backed setups** and **systems-wide improvements**:

1. **Research**: Use expert-backed research, best practices, and up-to-date patterns before implementing.
2. **Multiple PP cycles**: Apply PP for research, best practices, and systems decisions; then implement, optimize, and perfect.
3. **Trusted decisions**: Deliver logical, trusted, and perfected setups; wire improvements into runbooks and workflows (e.g. OPERATOR_RUNBOOK.md, verify-pipeline, run-runbook).

---

## Daily gates (what to run when)

- **Daily**: `npm run quality` (format, format:check, lint, test:unit). See [OPERATOR_RUNBOOK.md](../OPERATOR_RUNBOOK.md).
- **Before push**: `.\scripts\verify-pipeline.ps1` (or `-SkipRunbook` if no `.env.local`). See [.github/workflows/README.md](../.github/workflows/README.md).
- **Integration (credential-gated)**: `.\scripts\run-runbook.ps1` (Shopify + GitHub checks). Run after credentials are set.

---

## Sample real-world command (full pipeline)

**Command**: From repo root, run:

```powershell
.\scripts\verify-pipeline.ps1
```

**What it does**: (1) Parses all 74 PowerShell scripts, (2) Verifies workflow files, (3) Product sync dry-run if Shopify creds in `.env.local`, (4) ESLint, (5) Runbook (Shopify connection + GitHub auth).

**Expected outcomes**:

- **Without Shopify token**: Steps 1–4 pass; runbook reports `SHOPIFY_ACCESS_TOKEN not set` and GitHub repo access OK → verification finishes with 1 failure (add token to complete).
- **With credentials**: All steps pass when `SHOPIFY_ACCESS_TOKEN` (and optionally `GITHUB_TOKEN`) are set in `.env.local`.

**Quick quality-only**: `npm run quality` then `.\scripts\verify-pipeline.ps1 -SkipRunbook`.

---

## References

- **Rules**: [.cursor/rules/pp-basis.mdc](../.cursor/rules/pp-basis.mdc), [OPERATOR_RUNBOOK.md](../OPERATOR_RUNBOOK.md), [AGENTS.md](../AGENTS.md).
- **Credentials**: [docs/CREDENTIALS_SETUP.md](CREDENTIALS_SETUP.md), [docs/BROWSER_CREDENTIAL_FLOW.md](BROWSER_CREDENTIAL_FLOW.md).
- **Full setup**: `.\scripts\setup\full-setup.ps1` (or auto-configure-env.ps1); then run-runbook.ps1.
