# AO Guru Audit Findings

**Date**: 2026-01-29  
**Scope**: Repo inventory + specialist audits (code, tests, workflows, docs/tooling)

## Summary

This audit consolidates findings from parallel specialist reviews. Each item includes severity and recommended next steps.

## Code Quality & Architecture

**Severity: High**

- **OS-specific fragility**: Windows-only fallbacks in desktop automation modules (PowerShell + user32.dll).  
  _Affected_: `src/desktop-automation/*` (mouse/keyboard/window manager).  
  _Next_: Add platform detection + documented fallbacks.
- **Error handling gaps**: Silent catch blocks and non-propagated errors.  
  _Affected_: `src/browser-automation/helpers.js`, `src/browser-automation/shopify-admin.js`, `src/desktop-automation/window-manager.js`.  
  _Next_: Standardize structured error returns + logging.

**Severity: Medium**

- **Code duplication**: repeated PowerShell execution, retry logic, error pattern matching.  
  _Affected_: multiple desktop-automation modules.  
  _Next_: Extract shared utilities.
- **Input validation + magic numbers**: public APIs accept unchecked inputs; timeouts scattered.  
  _Next_: Centralize constants and add validation.

**Severity: Low**

- **Path handling bug**: `file-explorer.js` uses `lastIndexOf` logic that fails when no separator found.  
  _Next_: use `path.dirname`.

## Testing & QA

**Severity: High**

- **Silent skips** in credential-gated tests mask missing config.  
  _Affected_: `tests/integration/github-api.test.js`, `tests/integration/shopify-api.test.js`.  
  _Next_: Use `test.skip()` or conditional skip with explicit reason.
- **Browser context reuse** creates nondeterminism.  
  _Affected_: `tests/e2e/shopify-admin.spec.js`, `tests/shopify-admin/extract-credentials.spec.js`.  
  _Next_: Use fresh contexts + setup/teardown hooks.

**Severity: Medium**

- **Timeout inconsistency** across Vitest + Playwright.  
  _Next_: Set global timeout defaults, limit per-test overrides.
- **Desktop automation tests** contain weak assertions.  
  _Next_: Validate actual outcomes or skip when dependencies are absent.

## CI/CD & Workflows

**Severity: High**

- **Missing `permissions` blocks** across workflows.  
  _Next_: Add least-privilege permissions.
- **Unpinned actions** (e.g., `@master` for Trivy).  
  _Next_: Pin to versioned tags.
- **Failure masking** (`|| true` on lint/test/audit).  
  _Next_: Remove or explicitly gate failures with rationale.

**Severity: Medium**

- **Caching gaps** in workflow jobs.  
  _Next_: Add npm cache for performance.
- **Timeouts missing**.  
  _Next_: Add job timeouts and retries for network steps.

## Documentation & Tooling

**Severity: High**

- **Shopify API version mismatch** in docs (2024-01 vs 2026-01).  
  _Next_: Align docs with 2026-01.
- **Testing framework mismatch** (Jest vs Vitest).  
  _Next_: Update `docs/CODING_STANDARDS.md`.
- **Script path mismatches** in Shopify docs.  
  _Next_: Correct references to `scripts/products/*.ps1`.

**Severity: Medium**

- **Missing extension recommendations** (`dotenv`, `markdownlint`, `yaml`, `python`).  
  _Next_: Add to `.cursor/extensions.json`.
- **Python requirement** for Playwright webServer not documented.  
  _Next_: Update `docs/ENVIRONMENT_SETUP.md`.

**Severity: Low**

- **Doc overlap**: `QUICK_START.md` vs `docs/guides/quick-start.md`.  
  _Next_: consolidate or cross-link.
