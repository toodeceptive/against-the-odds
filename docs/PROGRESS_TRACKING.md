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

### Commerce (Shopify)

- **Theme changes**: theme pull/push frequency
- **Catalog changes**: product JSON in `data/products/` + sync runs
- **Backups**: output from `scripts/shopify/fetch-store-data.ps1`

## Automated report(s)

- `PROJECT_STATUS.md`: primary dashboard file (regenerated as needed).
- `docs/status/`: optional date-stamped snapshots.

Generate with:

```powershell
.\scripts\reporting\generate-status.ps1
.\scripts\reporting\generate-status.ps1 -Detailed
```

## Conventions

- Prefer **issues** for all work; commits/PRs should reference issue numbers.
- Keep large decisions in `docs/decisions/` (ADR-style).
- Keep operational notes in `docs/status/` (append-only snapshots).

