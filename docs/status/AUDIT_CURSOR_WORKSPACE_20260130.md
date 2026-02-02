# Audit: Cursor & Workspace (A3) — 2026-01-30

- **Rules**: shopify-preview-approval.mdc references pending-approval, open-pending-approval.ps1, start-theme-preview.ps1. ao-guru.rules.md points to docs/status/ and INDEX_REPORTS. Aligned.
- **Tasks**: Open pending approval ✓. Shopify: Theme Dev (preview before commit) ✓. **Missing**: "Start theme preview (new window)" → scripts/start-theme-preview.ps1. Add in B2.
- **Context**: shopify.md has workflow doc, theme path, product data; add one line for preview-before-apply and open-pending-approval/start-theme-preview (B3).
- **Plans**: Canonical plan is FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md; prior plan content consolidated there. See .cursor/plans/README.md.
- **Run from repo root**: Tasks use Get-Location / relative paths; document in runbook/guides (already present). No KEYBINDING doc on disk — create B6.
