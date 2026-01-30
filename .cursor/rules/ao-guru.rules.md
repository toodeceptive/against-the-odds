---
name: AO Guru Execution Rules
description: Consistent agent behavior for audits, fixes, and reporting.
---

## Execution Principles

- Keep changes small and verifiable.
- Prefer deterministic tests over watch mode.
- Log all significant decisions with rationale.

## Safety & Retention

- Never remove historical reports or savepoints unless redundant and superseded.
- If unsure about deletion, archive to `archive/YYYY-MM-DD/` with an `ARCHIVE_NOTE.md`.
- Never commit secrets; never print secrets in logs or reports.

## Quality Gates

- ESLint: 0 errors, 0 warnings
- Prettier: clean
- Tests: unit/integration/e2e pass or explicitly skipped with reason
- Coverage: meet thresholds or create a tracked remediation plan

## Documentation

- Update docs when behavior or commands change.
- Keep Windows-first instructions accurate.

## Reporting

- Maintain `MASTER_EXECUTION_REPORT.md` with findings, decisions, fixes, and verification.
