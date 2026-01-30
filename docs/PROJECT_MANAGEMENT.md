# Project Management System

## Overview

This repository uses **GitHub Issues + GitHub Projects** as the source of truth for work planning, execution, and reporting. Local scripts in `scripts/pm/` optionally automate common operations when `gh` (GitHub CLI) is installed and authenticated.

## Issue types (templates)

Templates live in `.github/ISSUE_TEMPLATE/`:

- `task.md`: operational/dev tasks
- `bug.md`: defect tracking
- `feature.md`: enhancements / new functionality

## Labels (recommended baseline)

- **Priority**: `critical`, `high`, `medium`, `low`
- **Type**: `task`, `bug`, `enhancement`, `documentation`
- **Status**: `todo`, `in-progress`, `review`, `done`
- **Area**: `github`, `shopify`, `theme`, `products`, `manufacturing`, `automation`, `docs`

## Workflow (minimum viable)

1. **Create issue** using the right template.
2. **Label** it with priority/type/area/status.
3. **Branch** from `develop` for work: `feature/<issue>-short-slug`.
4. **Commit** with conventional-ish prefixes (`feat:`, `fix:`, `docs:`, `chore:`).
5. **Open PR** into `develop`; PR must pass CI and quality checks.
6. **Merge**; issue auto-closes when referenced via `Closes #123`.
7. **Release** to `main` when ready (merge or PR from `develop`).

## Project board

Create a GitHub Project (recommended name: **AO - Execution Board**) with these columns:

- Backlog
- To Do
- In Progress
- Review
- Done

Automation suggestions:

- Move to **In Progress** when a PR is opened.
- Move to **Done** when the issue is closed.

## Local automation (optional)

Scripts:

- `scripts/pm/create-task.ps1`: creates an issue (requires `gh`)
- `scripts/pm/update-status.ps1`: updates issue labels (requires `gh`)

If `gh` isn’t installed/authenticated, the scripts print the manual URL and instructions instead.
