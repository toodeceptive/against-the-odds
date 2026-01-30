# Start Shopify theme dev server in a new window so the preview URL opens in the browser automatically.
# Use when the agent has made theme/page changes and wants to show the live preview before approval.
# Run from repo root.

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    (Get-Location).Path
}

$scriptPath = Join-Path $repoPath "scripts/shopify/theme-dev.ps1"
if (-not (Test-Path $scriptPath)) {
    Write-Host "Theme dev script not found: $scriptPath" -ForegroundColor Red
    exit 1
}

Start-Process powershell -ArgumentList @(
    "-NoProfile",
    "-ExecutionPolicy", "Bypass",
    "-File", $scriptPath
) -WorkingDirectory $repoPath

Write-Host "Theme dev server starting in a new window. The preview URL will open in your browser in a few seconds." -ForegroundColor Cyan
