# Perfect Delta Native Guru PP Prompt (2026-03-06)

**Purpose**: Execute a non-redundant, evidence-backed, guru-level PP cycle against the current live state of the repo. This prompt is for **remaining deltas only**. Do not repeat completed historical phases unless live evidence shows regression.

**Use**: `/pp` + paste this prompt, or reference it by name in a new PP run.

---

## Prompt

```text
Run a delta-first Prodigy Protocol cycle on the current repository state.

Before doing any work, read and align with:
- AGENTS.md
- OPERATOR_RUNBOOK.md
- docs/GURU_PP_OPERATOR_GUIDE.md
- docs/status/EXECUTIVE_DECISION_WORK_PRINCIPLES.md
- docs/status/PLAN_AGENT_ENTRY.md
- docs/status/WORK_QUEUE.md
- docs/status/CONSOLIDATION_LOG.md
- docs/status/INDEX_REPORTS.md
- .cursor/plans/README.md
- .cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md
- .github/workflows/README.md
- .github/settings.optimization.md

Hard rules:
- No redundancy: do not re-run historical Phase 0 / Tracks A–G / old audit cycles unless current evidence proves drift.
- Native CI is authoritative: prefer repo-owned GitHub Actions checks over external paid/app checks.
- No store-affecting changes without preview + approval.
- No secrets in commits/logs.
- Treat inaccessible admin writes, credentials, or external SaaS settings as explicit blockers with owner + next action.
- Prefer smallest safe fix first; verify after every meaningful change.

Primary objective:
Identify and fix only the real remaining issues across code, CI, workflow docs, agent commands/tasks, branch/PR gating, and environment portability; optimize agentic workflow and execution reliability; then verify, log, commit, and push the completed delta work.

Execution sequence:

1) Preflight
- Capture live git status, branch, PR state, latest CI/check status, and dirty files.
- Distinguish current actionable scope from historical notes.

2) Delta audit
- Audit only remaining actionable issues in:
  - CI/workflows and merge gating
  - command/task/runtime determinism
  - docs vs live behavior
  - environment portability
  - lingering failing checks
- Ignore already-closed historical issues unless regression evidence appears.

3) Multi-lane execution
- Lane A: native CI / branch-gating truth
- Lane B: agent workflow / commands / tasks
- Lane C: docs and prompt/router truth
- Lane D: environment and verification portability
- Merge findings only after each lane is validated.

4) Remediation
- Fix highest-value, lowest-risk deltas first.
- Replace external or stale gating with repo-native checks where possible.
- Remove dead references and obsolete workflow instructions when they still affect current operation.

5) Verification
- Run repo-native verification:
  - npm run quality
  - npm run verify:pipeline
- If verification is blocked by credentials or inaccessible admin permissions, classify the blocker precisely instead of masking it.

6) Documentation and closure
- Update only the canonical docs touched by the fixes.
- Append CONSOLIDATION_LOG with exact evidence and outcomes.
- Commit and push logical changes.

7) Final report
- Return:
  - what was actually fixed
  - what was verified
  - what remains blocked
  - exact owner/next action for residual blockers
  - commit SHA(s) and pushed branch

Definition of done:
- All newly discovered actionable repo-side issues are fixed.
- Native CI / command / task / workflow docs are aligned with actual behavior.
- Remaining failures are external or credential-gated only, with explicit evidence.
- Changes are committed, pushed, and documented without redundant reruns.
```
