# Local Main-Branch Guru Finalization — V4 Closure-Only (2026-02-26)

**Role**: Local Main-Branch Guru Finalization Team (closure pass).

**Goal**: Execute remaining closure steps, produce final output, and commit. **Delta-only** — skip work already completed per `docs/status/LOCAL_MAIN_FINALIZATION_PLAN_20260226.md` and `docs/status/WORK_QUEUE.md`.

---

## 1. Rules (unchanged)

- Main branch only. No secrets in commits. Credentials in `.env.local`.
- Delta-first: do not redo completed work.

---

## 2. Context (read if not already)

- `docs/status/LOCAL_MAIN_FINALIZATION_PLAN_20260226.md`
- `docs/status/WORK_QUEUE.md`
- `docs/status/CONSOLIDATION_LOG.md` (latest entries)

---

## 3. Closure Steps (execute only what remains)

| Step | Action                                                                      | Skip if          |
| ---- | --------------------------------------------------------------------------- | ---------------- |
| A    | `gh auth login` + `gh auth refresh -h github.com -s repo,workflow,read:org` | gh authenticated |
| B    | Run `scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`             | Exit 0, no 403   |
| C    | Run `scripts/run-runbook.ps1 -StrictSecrets`                                | Exit 0           |
| D    | Browser: verify branch protection + code scanning at repo settings          | Already verified |
| E    | Run `npm run quality` and `scripts/verify-pipeline.ps1 -SkipRunbook`        | Both pass        |
| F    | Update WORK_QUEUE, PP_AUDIT_MARKER, CONSOLIDATION_LOG                       | Already current  |
| G    | Commit (logical batches), push main, confirm CI green                       | Done             |

---

## 4. Required Final Output

- **Executive summary**
- **Findings register** (fingerprint, severity, status)
- **Local fixes applied**
- **Verification matrix** (command/result)
- **Remaining blockers** (owner + next action)
- **Git finalization** (branch/commits/CI)
- **Rollback notes**

---

## 5. Codacy MCP

If Codacy MCP unavailable: reset MCP in extension; verify Copilot MCP in GitHub settings. Then run analysis on edited files.
