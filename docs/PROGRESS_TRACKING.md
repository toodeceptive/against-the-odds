# Progress Tracking System

## Goals

- **Single source of truth**: GitHub Issues/Projects for tasks; this repo for implementation.
- **Always up-to-date**: lightweight, automatable status output for fast situational awareness.
- **Auditability**: changes traceable via git history + CI logs + (optional) Shopify backups.

## What we track

### Engineering

- **Build health**: GitHub Actions pass/fail
- **Quality**: lint/format checks
- **Security**: dependency audit + filesystem scan outputs
- **Testing**: unit + e2e pass rate, coverage when available

### Operations

- **Open/closed issues** (when `gh` is available)
- **Recent commits / active branch**
- **Release cadence**: merges into `main`

### Agent system health

- **MCP availability**: GitHub MCP reachable status and drift notes
- **Command/task parity**: slash commands and Cursor tasks match docs and current workflows
- **Worktree routing**: live `git worktree list` agrees with documented guidance
- **Ignore/indexing hygiene**: `.cursorignore` / `.cursorindexingignore` still match desired search scope
- **Agent roster**: deployed `.cursor/agents/` ownership remains aligned with docs

### Commerce (Shopify)

- **Theme changes**: theme pull/push frequency
- **Catalog changes**: product JSON in `data/products/` + sync runs
- **Backups**: output from `scripts/shopify/fetch-store-data.ps1`

## Automated report(s)

- `docs/status/WORK_QUEUE.md`: canonical active execution queue.
- `docs/status/CONSOLIDATION_LOG.md`: append-only history of what changed and when.
- `docs/status/`: date-stamped or milestone snapshots when a dedicated report is useful.
- `PROJECT_STATUS.md`: optional generated dashboard artifact if regenerated; historical copies may live in `archive/`.

Generate with:

```powershell
.\scripts\reporting\generate-status.ps1
.\scripts\reporting\generate-status.ps1 -Detailed
```

## Conventions

- Prefer **issues** for all work; commits/PRs should reference issue numbers.
- Keep large decisions in `docs/decisions/` (ADR-style).
- Keep operational notes in `docs/status/` (append-only snapshots).
