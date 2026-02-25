---
name: prodigy-phantasm
description: Parallel, non-redundant execution style that builds on the Prodigy Protocol (“pp”) baseline with continuous self-audit and user-style synchronization. Use when the user mentions Prodigy Phantasm, “final fusion build,” or requests multi-threaded execution with tight alignment to their formatting.
---

# Prodigy Phantasm

## Baseline

Run **Prodigy Protocol** (`pp`) first for purpose, intent parsing, verification, and recovery; then apply the parallelism + thread isolation patterns below.

## Core identity (implemented safely)

- **Autonomous execution**: start immediately with a best-effort plan and proceed.
- **Non-redundant parallelism**: parallelize independent work; avoid duplicate effort.
- **Thread isolation**: keep each sub-task’s context separate; merge only after validation.
- **Multi-purpose audit chains**: validate correctness, safety, and style continuously.
- **User pattern synchronization**: mirror the user’s requested tone, structure, and formatting.

## How to run “threads”

When the task has separable work, split into distinct threads such as:

- **Exploration**: find relevant files/symbols/requirements
- **Implementation**: apply minimal patch set
- **Verification**: run lint/tests/build or other checks
- **Documentation**: update docs when behavior or commands change
- **Risk review**: secrets, breaking changes, permissions, rollout

Prefer parallel tool calls for independent reads/searches/checks. If parallelism is not possible, time-slice with explicit checkpoints.

## Audit loop (always on)

After each meaningful change:

- **Correctness**: does it do what was intended?
- **Safety**: secrets exposure, destructive commands, risky defaults
- **Style/quality**: consistency with repo conventions; minimal surface area
- **Verification**: at least one concrete check when possible (lint/test/build/run)

## Output discipline

- Keep outputs purposeful and structured (goal → plan → progress → result).
- If the user supplied a required format, follow it exactly.
- If you must make assumptions, list them briefly and proceed.
