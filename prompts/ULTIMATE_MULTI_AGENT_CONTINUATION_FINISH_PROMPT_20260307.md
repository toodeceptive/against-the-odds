# Ultimate Multi-Agent Continuation / Finish-All-Work Prompt (2026-03-07)

**Purpose**: Continue and finish the Against The Odds repo using a **delta-only, multi-agent, guru-expert Prodigy Protocol cycle** grounded in the **current live branch/worktree state**, not historical assumptions.

**Use**: `/pp` + paste this prompt, or reference it by name in a new PP run.

---

## Why this prompt exists

This prompt is for the phase **after** the large 2026-03-06 / 2026-03-07 hardening sequence. It assumes the repo has already completed a substantial closure run and must now:

- continue from the **remaining real delta only**
- avoid redoing closed work
- preserve unrelated dirty files
- verify every meaningful change
- commit and push each logical improvement

---

## Recently closed work (do not redo unless current evidence shows regression)

Recent branch commits already closed these categories:

- `824cfd5` — local validation workflow hardening
- `defe638` — structural/shopify workflow integrity
- `03c90e1` — required local E2E smoke gate
- `22cad54` — product sync by stable Shopify handle
- `a4dc0dd` — Shopify admin test coverage path cleanup
- `e2a0ed8` — product sync apply failures now fail loudly
- `1d996aa` — user-browser-first auth flow by default
- `93a7aca` — canonical Shopify deploy workflow docs
- `b1fbe19` — theme branch export verification
- `b298d9b` — branch protection governance verifier
- `852c84d` — local/live verification lane clarification
- `68c55f6` — manufacturer schema-version parity
- `fe18970` — stronger strict/local verification
- `b387163` — attached browser verification hardening
- `aae455d` — Shopify setup/import terminology cleanup

Treat those as **closed baselines** unless live repo evidence proves drift or breakage.

---

## Prompt

```text
Run a delta-first, multi-agent Prodigy Protocol cycle on the current repository state and continue until the remaining real work is finished or reduced to explicit external blockers.

Before changing anything, read and align with:
- AGENTS.md
- OPERATOR_RUNBOOK.md
- docs/GURU_PP_OPERATOR_GUIDE.md
- docs/status/EXECUTIVE_DECISION_WORK_PRINCIPLES.md
- docs/status/WORK_QUEUE.md
- docs/status/CONSOLIDATION_LOG.md
- docs/status/INDEX_REPORTS.md
- prompts/README.md
- .github/workflows/README.md
- .github/settings.optimization.md
- .cursor/context/github.md
- .cursor/context/shopify.md

Then inspect the live repo state:
- git status
- latest git log
- current dirty files
- active workflows
- active prompt inventory
- current verification surfaces

Non-negotiable operating rules:
- Do not repeat already-closed 2026-03-06 / 2026-03-07 work unless current evidence proves regression.
- Preserve unrelated dirty files; do not absorb, overwrite, or revert pre-existing user/local changes unless they are part of the exact required delta.
- No store-affecting change without preview + explicit approval.
- No secrets in commits, logs, prompts, or docs.
- Prefer repo-native verification over assumptions or summaries.
- Commit and push each logical change set separately.
- If an admin token, Shopify credential, or external settings access is missing, classify it precisely instead of pretending the system is closed.

Primary objective:
Finish the remaining real work across code, CI, governance verification, tasks/commands, test surfaces, docs, prompts, and operational truth until only external/admin/credential blockers remain.

Execution model:

1) Preflight
- Capture:
  - branch
  - dirty files
  - latest commits
  - active verification commands
  - active workflow files
- Distinguish:
  - repo-contained actionable deltas
  - external/admin blockers
  - historical notes that should not be re-executed

2) Delta audit
- Audit only active remaining issues in:
  - governance/ruleset truth
  - CI/workflow fidelity
  - command/task/test coverage truth
  - Shopify operational safety
  - docs/prompt/router truth
  - environment portability
- Ignore archive/history unless it still misroutes active work.

3) Multi-agent lane split
- Lane A: governance / CI / branch-gating truth
- Lane B: tests / verifier / command / task coverage
- Lane C: Shopify operational safety and workflow truth
- Lane D: docs / prompts / router truth
- Run lanes in parallel where safe, but merge only after each lane is validated.

4) Remediation order
- Fix highest-value, lowest-risk repo-contained deltas first.
- Prefer turning assumptions into executable verification.
- Prefer narrowing claims over overstating guarantees.
- Eliminate current-facing contradictions before touching historical/reference material.

5) Verification
- Always run:
  - npm run quality
- Run focused verification based on touched files:
  - npm test
  - npm run test:e2e
  - npm run test:e2e:live
  - npm run test:shopify
  - npm run test:desktop:vitest
  - npm run verify:theme-branch
  - node scripts/infra/verify-data-schema-version.mjs
  - node scripts/infra/verify-structural-state.mjs
  - npm run verify:governance (only when GITHUB_ADMIN_TOKEN/admin access is available)
  - npm run verify:pipeline or npm run verify:pipeline:strict when appropriate
- If PowerShell-backed commands cannot run in the current environment, record the exact environment blocker and use the strongest repo-native checks that still apply.

6) Commit / push discipline
- One logical change per commit.
- Do not batch unrelated fixes into one commit.
- Push after each logical commit.
- Never include unrelated dirty files in staged changes.

7) Final closure standard
- Only declare “finished” when:
  - active repo-contained issues are fixed,
  - active docs/tasks/prompts match real behavior,
  - verification passes for the touched surfaces,
  - remaining blockers are external/admin/credential only and clearly assigned.

8) Final report format
- What was fixed
- What was verified
- What remains blocked
- Exact owner / next action for each blocker
- Commit SHA(s)
- Pushed branch

Definition of done:
- No known active repo-side contradictions remain in the current execution lane.
- Native CI/test/task/doc surfaces are aligned with real behavior.
- Governance, Shopify, and verification claims are either executable or explicitly marked as external/manual.
- The branch contains only intentional, verified deltas.
```

---

## Recommended use cases

Use this prompt when you want:

- a **continue from here** guru pass
- a **finish remaining work** pass
- a **do not redo history** pass
- a **multi-agent delta closure** pass

Prefer this over older broad full-system prompts when the repo has already had several recent hardening cycles and you only want the next real delta.
