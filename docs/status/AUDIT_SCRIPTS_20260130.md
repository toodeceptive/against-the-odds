# Audit: Scripts & Automation (A5) — 2026-01-30

- **Shopify**: theme-dev.ps1, sync-products.ps1, update-theme.ps1, test-connection.ps1 present. open-pending-approval.ps1 and start-theme-preview.ps1 at scripts/ root — present and used by workflow/rules.
- **Tasks**: theme-dev.ps1 invoked by "Shopify: Theme Dev"; open-pending-approval via inline PowerShell in tasks.json. start-theme-preview.ps1 not in tasks — add task in B2.
- **Portability**: Open-pending-approval uses Get-Location (repo root). theme-dev and start-theme-preview called from repo root per docs. No orphan scripts deleted; C2/C7 document root scripts as legacy if kept.
