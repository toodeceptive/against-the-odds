# New Guru Expert Team System Optimization PP Prompt (2026-03-06)

**Purpose**: Execute a non-redundant, evidence-backed, guru-level PP cycle against the current live state of the repo, with emphasis on the **remaining active optimization surface only**. Do not repeat completed historical phases or already-closed 2026-03-06/2026-03-07 deltas unless live evidence shows drift.

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
- prompts/README.md
- .cursor/plans/README.md
- .cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md
- .github/workflows/README.md
- .github/settings.optimization.md

Hard rules:
- No redundancy: do not re-run historical Phase 0 / Tracks A-G / old audit cycles unless current evidence proves drift.
- Preserve unrelated dirty worktree files; do not revert or absorb pre-existing local changes unless live evidence shows they are part of the required delta.
- Native CI is authoritative: prefer repo-owned GitHub Actions checks over external paid/app checks.
- No store-affecting changes without preview + approval.
- No secrets in commits/logs.
- Treat inaccessible admin writes, credentials, or external SaaS settings as explicit blockers with owner + next action.
- If `pwsh`/`powershell` is missing in the current environment, either bootstrap a session-local PowerShell only as needed for verification or classify the environment blocker precisely with evidence.
- Prefer the smallest safe fix first; verify after every meaningful change.

Primary objective:
Identify and fix only the real remaining issues across code, CI, workflow docs, agent commands/tasks, prompt/router truth, branch/PR gating, and environment portability; optimize agentic workflow and execution reliability; then verify, log, commit, and push the completed delta work.

Execution sequence:

1) Preflight
- Capture live git status, branch, PR state, latest CI/check status, and dirty files.
- Distinguish current actionable scope from historical notes and from pre-existing unrelated worktree changes.

2) Delta audit
- Audit only remaining actionable issues in:
  - CI/workflows and merge gating
  - command/task/runtime determinism
  - docs vs live behavior
  - prompt inventory / router truth
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
- If this prompt is now the canonical delta prompt, align the prompt inventory/router docs that are directly affected.

5) Verification
- Run repo-native verification:
  - npm run quality
  - npm run verify:pipeline
- Use `npm run verify:pipeline:strict` only when Shopify credentials are expected locally and the full runbook gate should be enforced.
- If verification is blocked by missing credentials or inaccessible admin permissions, classify the blocker precisely instead of masking it.

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
- Prompt inventory/router truth is aligned with the active delta prompt in use.
- Remaining failures are external or credential-gated only, with explicit evidence.
- Changes are committed, pushed, and documented without redundant reruns.
```
