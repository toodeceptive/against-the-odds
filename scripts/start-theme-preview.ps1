# Start theme preview and open approval file + browser (unified flow).
# Delegates to open-preview-popup.ps1 so the user gets: pending-approval in Cursor, static AO preview in browser,
# and theme dev in a new window when the current desktop environment supports it.
# Run from repo root. For theme changes, agents should run this after writing docs/status/pending-approval.md.

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    (Get-Location).Path
}

$popupScript = Join-Path $repoPath "scripts/open-preview-popup.ps1"
if (-not (Test-Path $popupScript)) {
    Write-Host "Preview popup script not found: $popupScript" -ForegroundColor Red
    exit 1
}

& $popupScript
exit $LASTEXITCODE
