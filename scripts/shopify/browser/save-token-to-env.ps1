# Save Shopify Admin API access token to .env.local (no commit).
# Use after copying the token from Shopify Admin > Apps > Development > API credentials.
# Prefer: copy token to clipboard, then run with no args (reads clipboard). Or pass -Token.

param(
    [string]$Token = $null
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
} else {
    "C:\Users\LegiT\against-the-odds"
}
Set-Location $repoPath

if ([string]::IsNullOrWhiteSpace($Token)) {
    try {
        $Token = Get-Clipboard -Raw
    } catch {}
    if ([string]::IsNullOrWhiteSpace($Token)) {
        Write-Host "Usage: Copy the Admin API access token (shpat_...) to clipboard, then run:" -ForegroundColor Yellow
        Write-Host "  .\scripts\shopify\browser\save-token-to-env.ps1" -ForegroundColor Cyan
        Write-Host "Or: .\scripts\shopify\browser\save-token-to-env.ps1 -Token 'shpat_...'" -ForegroundColor Cyan
        exit 1
    }
}

$Token = $Token.Trim()
if ($Token -notmatch '^shpat_[a-zA-Z0-9]+$') {
    Write-Host "Error: Token should start with shpat_ and contain only letters/numbers." -ForegroundColor Red
    exit 1
}

$envPath = Join-Path $repoPath ".env.local"
if (-not (Test-Path $envPath)) {
    if (Test-Path (Join-Path $repoPath ".env.example")) {
        Copy-Item (Join-Path $repoPath ".env.example") $envPath
        Write-Host "Created .env.local from .env.example" -ForegroundColor Green
    } else {
        Write-Host "Error: .env.local not found and no .env.example to copy." -ForegroundColor Red
        exit 1
    }
}

$content = Get-Content $envPath
$updatedAccess = $false
$updatedCli = $false
$newContent = @()
foreach ($line in $content) {
    if ($line -match '^SHOPIFY_ACCESS_TOKEN=(.*)$') {
        $newContent += "SHOPIFY_ACCESS_TOKEN=$Token"
        $updatedAccess = $true
    } elseif ($line -match '^SHOPIFY_CLI_THEME_TOKEN=(.*)$') {
        $newContent += "SHOPIFY_CLI_THEME_TOKEN=$Token"
        $updatedCli = $true
    } else {
        $newContent += $line
    }
}
if (-not $updatedAccess) { $newContent += "SHOPIFY_ACCESS_TOKEN=$Token" }
if (-not $updatedCli) { $newContent += "SHOPIFY_CLI_THEME_TOKEN=$Token" }
$newContent | Out-File -FilePath $envPath -Encoding UTF8

Write-Host "[OK] SHOPIFY_ACCESS_TOKEN and SHOPIFY_CLI_THEME_TOKEN saved to .env.local (never commit this file)." -ForegroundColor Green
Write-Host "Theme pull/dev will use token. Verify with: .\scripts\run-runbook.ps1" -ForegroundColor Cyan
