# Load .env.local and run key runbook checks (Shopify + GitHub verification).
# Run from repo root: .\scripts\run-runbook.ps1

param(
    [switch]$StrictSecrets
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if (Test-Path ".env.local") {
    Get-Content ".env.local" | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line -match "^([^=]+)=(.*)$") {
            $key = $matches[1].Trim()
            $val = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($key, $val, "Process")
        }
    }
}
# Default store for runbook so Shopify step reports token/API state, not "store not set"
if ([string]::IsNullOrWhiteSpace($env:SHOPIFY_STORE_DOMAIN)) {
    $env:SHOPIFY_STORE_DOMAIN = "aodrop.com"
}

Write-Host "=== Runbook: Shopify + GitHub ===" -ForegroundColor Cyan
& "$repoRoot\scripts\shopify\test-connection.ps1"
$shopifyExit = $LASTEXITCODE
& "$repoRoot\scripts\github\verify-auth.ps1"
$githubExit = $LASTEXITCODE
$secretsExit = 0
if ($StrictSecrets) {
    Write-Host ""
    & "$repoRoot\scripts\github\verify-secrets.ps1" -FailOnPermissionDenied
    $secretsExit = $LASTEXITCODE
}
if ($shopifyExit -ne 0 -or $githubExit -ne 0 -or $secretsExit -ne 0) { exit 1 }
exit 0
