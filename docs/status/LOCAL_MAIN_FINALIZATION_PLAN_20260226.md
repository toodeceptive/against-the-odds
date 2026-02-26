# Local Main-Branch Finalization Plan (2026-02-26)

**Purpose**: Single authoritative plan reflecting work completed in this chat and remaining blocker closure. Delta-first; no redundancy with WORK_QUEUE or CONSOLIDATION_LOG.

---

## Completed (this run)

| Item                     | Evidence                                                       |
| ------------------------ | -------------------------------------------------------------- |
| Branch: main only        | `git branch --show-current` → main                             |
| Rebase onto origin/main  | Conflicts resolved in WORK_QUEUE, PP_AUDIT_MARKER              |
| Infra file locks cleared | Orphaned ssh-keygen/cmd stopped; rebase unblocked              |
| CI green                 | Commits aae243a, cae690b — CI #176/#177, CodeQL #110/#111 pass |
| Format normalization     | Prettier drift fixed (commit aae243a)                          |
| GitHub CLI installed     | `gh` on PATH                                                   |
| Browser admin checks     | Branches, rules, security_analysis visited                     |
| Codacy MCP/CLI           | Installed; codacy_cli_analyze works for edited files           |
| Docs updated             | WORK_QUEUE, PP_AUDIT_MARKER, CONSOLIDATION_LOG, INDEX_REPORTS  |

---

## Remaining Blockers (owner + next action)

| #   | Blocker                                             | Owner          | Next action                                                                                   |
| --- | --------------------------------------------------- | -------------- | --------------------------------------------------------------------------------------------- |
| 1   | GitHub CLI not authenticated                        | Local operator | `gh auth login` interactively, then `gh auth refresh -h github.com -s repo,workflow,read:org` |
| 2   | Strict runbook fails (SHOPIFY_ACCESS_TOKEN missing) | Local operator | Add creds to `.env.local`; rerun `scripts/run-runbook.ps1 -StrictSecrets`                     |
| 3   | Branch protection/rulesets not configured           | GitHub admin   | Configure per `.github/settings.optimization.md`                                              |
| 4   | Structural signature verify (optional)              | Local operator | Run `scripts/infra/sign-structural-state.ps1` if needed; commit STRUCTURAL\_\*                |
| 5   | Codacy MCP in cloud session                         | Cursor/Codacy  | Reset MCP; verify Copilot MCP settings in GitHub                                              |

---

## Verification Matrix (baseline)

| Command                                                     | Expected (with creds)               |
| ----------------------------------------------------------- | ----------------------------------- |
| `npm run quality`                                           | PASS                                |
| `scripts/verify-pipeline.ps1`                               | PASS (SkipRunbook if no .env.local) |
| `scripts/run-runbook.ps1 -StrictSecrets`                    | PASS (requires .env.local)          |
| `scripts/github/verify-auth.ps1`                            | PASS                                |
| `scripts/github/verify-secrets.ps1 -FailOnPermissionDenied` | PASS (requires gh auth)             |
| `ssh-keygen -Y verify` (structural)                         | PASS (requires valid signature)     |

---

## Required Context (read order)

1. `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`
2. `docs/status/WORK_QUEUE.md`
3. `docs/status/PP_AUDIT_MARKER.md`
4. `docs/status/CONSOLIDATION_LOG.md` (latest-first)
5. `docs/status/INDEX_REPORTS.md`
6. `docs/AGENT_PROMPT_DECISION_TREE.md`
7. `OPERATOR_RUNBOOK.md`

---

## Non-negotiable Rules

- Use main branch only
- Never commit secrets
- Keep credentials in `.env.local` only
- Use user's Chrome for browser-gated admin checks
- Preview-before-apply for store-affecting actions
- Delta-first: do not redo completed work unless regression evidence exists
