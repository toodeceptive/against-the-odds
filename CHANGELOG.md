# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **2026-01-31** — Guru expert analysis: cross-comparative + limit-test (lint, format, unit/integration tests, npm audit, runbook, verify-pipeline); fixes: Prettier ROOT_FILES_INVENTORY, SECURITY_COMPLIANCE_REPORT main-only wording, workflows README main-only + optional implement notes, verify-pipeline.ps1 all 7 workflows; GURU_EXPERT_ANALYSIS_20260131.md; INDEX_REPORTS and VERSION_UPDATE_TABLE updated. Pipeline fully operational; approval requested for commit.
- **2026-01-31** — Proceed: COVERAGE_REMEDIATION_PLAN snapshot (20% stmts, 31% funcs, 44% branches); OPERATOR_RUNBOOK desktop automation optional deps note (robotjs, node-window-manager, native build).
- **2026-01-31** — LICENSE file (UNLICENSED) at repo root; ROOT_FILES_INVENTORY and CONSOLIDATION_LOG updated; format pass on 2 files. Plan issue #5 closed.
- **2026-01-31** — Next steps execution: NEXT_BEST_STEPS_20260131.md (guru analysis, Tier 1–4); NEXT_STEPS.md and INDEX_REPORTS/VERSION_UPDATE_TABLE updated; redundant Tier 1 item 3 removed; Tier 1 runbook (lint, format, test pass; runbook: GitHub OK, Shopify credential-gated); BRANCH_INVENTORY branch-hygiene note; Prettier format pass.
- **2026-01-31** — Post-push review: CONSOLIDATION_LOG Track C/D entries; CURSOR_GITHUB_AUDIT plan table updated to FINAL_REPO_ORGANIZATION_AND_AUDIT; BRANCH_INVENTORY and WORKTREE_INVENTORY current state; ENVIRONMENTS doc encoding fix; historical audit refs (consolidated plan) noted.
- **2026-01-31** — Tracks E, F, G and Synthesis: scripts/README.md (scripts by domain, npm map), config/README.md, data/README.md; root .png moved to assets/brand; docs/screenshots/README.md and ROOT_FILES_INVENTORY.md; CODEBASE_AUDIT_20260131.md; CONSOLIDATION_LOG completed (Phase 0 + A, B, E, F, G + Synthesis); VERSION_UPDATE_TABLE.md, archive/ARCHIVE_LOG.md; INDEX_REPORTS and PLAN_AGENT_ENTRY updated; workflows README main-only; handoff and README point to CONSOLIDATION_LOG and INDEX_REPORTS.
- **2026-01-31** — Cursor + GitHub audit; browser-agent clarification; plan finalization (per .cursor/plans cursor_github_audit_and_finalization).
- **2026-01-31** — 100 Questions Guru Expert Self-Audit: CURSOR_GITHUB_AUDIT_20260131.md Section 8 (100 Q&A by research and analysis); “Is it ready?” summary at top; PLAN_AGENT_ENTRY now links to AGENTS.md (Related Context and Quick Reference); plan finalized in all aspects.
- **2026-01-31** — Guru expert audit and plan perfection: docs/README.md Agent and handoff table now includes AGENTS.md (repo root); CURSOR_GITHUB_AUDIT_20260131.md Section 7 “Guru expert perfection criteria” (what “perfect plan” means); PLAN_AUDIT_20260131.md execution status and cross-reference to full audit; final checklist updated.
- **2026-01-31** — Cursor + GitHub full audit: AGENTS.md “When agents use your browser” (browser–agent system); docs/status/CURSOR_GITHUB_AUDIT_20260131.md (conversation/plan history, Cursor vs GitHub, pipeline, perfected prompt); .cursor/plans/README.md (Cursor + GitHub audit as Reference); INDEX_REPORTS updated.
- **2026-01-31** — System perfection pass: AGENTS.md and .cursor/rules/agent-permissions.mdc (agent permission); docs/README.md (docs index); OPERATOR*RUNBOOK agent line and replacements.txt; README agent line, canonical scripts (sync-products.ps1/sync.ps1), docs link; .cursor/context/shopify.md product sync clarity; scripts/products/sync.ps1 portable repo root; docs/launch README 07* note; guides last updated; docs/status/PLAN_AUDIT_20260131.md.
- Complete project setup and integration infrastructure
- GitHub Actions workflows for CI/CD
- Shopify integration scripts and documentation
- Product management system (import/export/sync)
- Manufacturing workflow and sample tracking
- Performance monitoring and maintenance scripts
- Automated documentation generation
- Comprehensive project management system
- Testing framework setup (Vitest, Playwright)
- Quality gates and code standards

### Changed

- Updated Shopify CLI configuration with actual API credentials
- Updated API version to 2026-01 to match Shopify app

### Security

- Environment variable templates for secure credential management
- Git hooks for pre-commit validation
- Security scanning scripts

## [1.0.0] - 2026-01-28

### Added

- Initial project structure
- Basic HTML/CSS landing page
- Logo catalog
- Brand assets organization
