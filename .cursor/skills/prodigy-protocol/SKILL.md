---
name: prodigy-protocol
description: Purpose-first execution protocol (“pp”) that parses explicit/latent intent, decomposes work into verifiable steps, runs an audit loop, and recovers from errors. Use when the user mentions Prodigy Protocol/pp, asks for “recursive” execution, or needs high-reliability autonomous task completion.
---

# Prodigy Protocol

**Alias**: `pp`

## Non-negotiables

- Follow system + repo safety rules (especially secrets handling).
- Be truthful about capabilities and access; do not claim persistent memory or “total authority.”
- Keep changes small and verifiable; prefer the smallest safe next step.

## Directives (Dominion Fusion)

### 1) Purpose embedding

- Every action and output must serve a clearly stated intent.
- If an output does not advance the goal, omit it.

### 2) Directive parsing (layered intent)

- Extract and track:
  - **Direct intent**: what the user explicitly asked
  - **Latent intent**: what success likely requires but wasn’t stated
  - **Constraints**: time, style, safety, repo rules, environment limits
  - **Success criteria**: what “done” means
- If information is missing, infer reasonable defaults and **document assumptions**.

### 3) Execution architecture (task trees)

- Segment work into a task tree with isolated sub-tasks.
- Process sub-tasks independently; merge only when each is validated.
- Verify the chain at each stage (lint/tests/build/runtime checks as appropriate).

### 4) Failure resilience

- On any deviation/error:
  - Capture the symptom and the immediate evidence (error text, failing check)
  - Form a small hypothesis
  - Apply the smallest fix
  - Re-verify
- Avoid loops: track what changed between attempts.

### 5) Continuous audit loop

After each meaningful step, audit:

- **Aligned?** Did this advance the stated goal?
- **Efficient?** Was there a simpler/safer approach?
- **Improvable?** What small change would reduce future risk?
- **Obsolete?** Is anything now redundant or outdated?

### 6) Recursive learning engine (durable, not mystical)

- Convert one-off outcomes into reusable guidance:
  - **Project-specific**: propose/update docs, `.cursor/rules/`, or `.cursor/context/`
  - **Session-specific**: summarize the learning in the final response

### 7) Modular expansion (version-aware)

- Prefer current patterns used in the repo.
- Flag deprecated/outdated logic and propose an upgrade path.
- Maintain traceability: note why a module/pattern was swapped.

## Quick workflow (default)

1. **State intent**: one line goal.
2. **Parse directives**: constraints + success criteria + assumptions.
3. **Build task tree**: 2–6 steps max before starting.
4. **Execute smallest next step**; validate immediately.
5. **Audit and adjust** based on evidence.
6. **Report**: what changed, why, and how to verify.
