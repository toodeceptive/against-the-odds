# Read Shopify Admin API token from paste file and save to .env.local.
# 1. Create scripts/shopify/.token-paste.txt (gitignored)
# 2. Paste your token (shpat_...) on line 1; optionally SHOPIFY_THEME_ID on line 2
# 3. Run: .\scripts\shopify\browser\save-token-from-file.ps1
# 4. File is deleted after success.

param()

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoPath

$pastePath = Join-Path $repoPath "scripts\shopify\.token-paste.txt"
if (-not (Test-Path $pastePath)) {
    $content = @"
# Paste your Admin API token here (one per line). Line 1 = token, Line 2 = optional theme ID.
# Or paste Client ID (32 hex) + Client secret (long hex) to obtain token via OAuth.
# Get from: Shopify Admin > Apps > Development > Your app > API credentials > Reveal
# Example line 1: shpat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# Example line 2: 123456789012

"@
    New-Item -ItemType Directory -Path (Split-Path $pastePath) -Force | Out-Null
    $content | Out-File -FilePath $pastePath -Encoding UTF8
    Write-Host "Created $pastePath" -ForegroundColor Cyan
    Write-Host "Paste your token (shpat_...) on line 1, save, then run this script again." -ForegroundColor Yellow
    exit 0
}

$raw = Get-Content $pastePath -Raw
$lines = Get-Content $pastePath | Where-Object { $_ -notmatch '^\s*#' -and $_.Trim().Length -gt 0 }
$Token = $null
$ThemeId = $null
$hex32 = @()
$hexLong = @()
$allTokens = @()
$allTokens += $raw -split '[\r\n\s]+' | Where-Object { $_.Trim().Length -gt 0 }
$allTokens += $lines | ForEach-Object { $_.Trim() }
$allTokens = $allTokens | Select-Object -Unique
foreach ($t in $allTokens) {
    $t = ($t -replace '^["\x27]|["\x27]$', '').Trim()
    if ($t -match '^shpat_[a-zA-Z0-9]{32,}$') { $Token = $t }
    elseif ($t -match '(shpat_[a-zA-Z0-9]{32,})') { $Token = $matches[1] }
    elseif ($t -match '^[a-fA-F0-9]{32}$') { $hex32 += $t }
    elseif ($t -match '^[a-zA-Z0-9_-]{33,}$' -and $t.Length -ne 32) { $hexLong += $t }
    elseif ($t -match '^\d{10,}$') { $ThemeId = $t }
}
$ApiKey = if ($hex32.Count -gt 0) { $hex32[0] } else { $null }
$ApiSecret = if ($hexLong.Count -gt 0) { $hexLong[0] } elseif ($hex32.Count -gt 1) { $hex32[1] } else { $null }

if (-not $Token -and $ApiKey -and $ApiSecret) {
    $envPath = Join-Path $repoPath ".env.local"
    if (-not (Test-Path $envPath) -and (Test-Path (Join-Path $repoPath ".env.example"))) {
        Copy-Item (Join-Path $repoPath ".env.example") $envPath
    }
    $content = if (Test-Path $envPath) { Get-Content $envPath } else { @() }
    $newContent = @()
    $doneKey = $false; $doneSecret = $false; $doneStore = $false
    foreach ($line in $content) {
        if ($line -match '^SHOPIFY_API_KEY=') { $newContent += "SHOPIFY_API_KEY=$ApiKey"; $doneKey = $true }
        elseif ($line -match '^SHOPIFY_API_SECRET=') { $newContent += "SHOPIFY_API_SECRET=$ApiSecret"; $doneSecret = $true }
        elseif ($line -match '^SHOPIFY_STORE_DOMAIN=') { $newContent += "SHOPIFY_STORE_DOMAIN=aodrop.com"; $doneStore = $true }
        else { $newContent += $line }
    }
    if (-not $doneKey) { $newContent += "SHOPIFY_API_KEY=$ApiKey" }
    if (-not $doneSecret) { $newContent += "SHOPIFY_API_SECRET=$ApiSecret" }
    if (-not $doneStore) { $newContent += "SHOPIFY_STORE_DOMAIN=aodrop.com" }
    $newContent | Out-File -FilePath $envPath -Encoding UTF8
    Remove-Item $pastePath -Force
    Write-Host "[OK] Client credentials saved. Obtaining access token..." -ForegroundColor Green
    & (Join-Path $repoPath "scripts\shopify\browser\get-token-client-credentials.ps1")
    exit $LASTEXITCODE
}

if (-not $Token) {
    Write-Host "Error: No valid token found in $pastePath" -ForegroundColor Red
    Write-Host "Expected: shpat_... OR Client ID (32 hex) + Client secret (long hex)." -ForegroundColor Yellow
    exit 1
}

$envPath = Join-Path $repoPath ".env.local"
if (-not (Test-Path $envPath) -and (Test-Path (Join-Path $repoPath ".env.example"))) {
    Copy-Item (Join-Path $repoPath ".env.example") $envPath
    Write-Host "Created .env.local from .env.example" -ForegroundColor Green
}
if (-not (Test-Path $envPath)) {
    @(
        "SHOPIFY_STORE_DOMAIN=aodrop.com",
        "SHOPIFY_ACCESS_TOKEN=$Token",
        "SHOPIFY_CLI_THEME_TOKEN=$Token"
    ) | Out-File -FilePath $envPath -Encoding UTF8
} else {
    $content = Get-Content $envPath
    $newContent = @()
    $doneAccess = $false
    $doneCli = $false
    $doneStore = $false
    $doneTheme = $false
    foreach ($line in $content) {
        if ($line -match '^SHOPIFY_ACCESS_TOKEN=') {
            $newContent += "SHOPIFY_ACCESS_TOKEN=$Token"
            $doneAccess = $true
        } elseif ($line -match '^SHOPIFY_CLI_THEME_TOKEN=') {
            $newContent += "SHOPIFY_CLI_THEME_TOKEN=$Token"
            $doneCli = $true
        } elseif ($line -match '^SHOPIFY_STORE_DOMAIN=') {
            $newContent += "SHOPIFY_STORE_DOMAIN=aodrop.com"
            $doneStore = $true
        } elseif ($line -match '^SHOPIFY_THEME_ID=' -and $ThemeId) {
            $newContent += "SHOPIFY_THEME_ID=$ThemeId"
            $doneTheme = $true
        } else {
            $newContent += $line
        }
    }
    if (-not $doneAccess) { $newContent += "SHOPIFY_ACCESS_TOKEN=$Token" }
    if (-not $doneCli) { $newContent += "SHOPIFY_CLI_THEME_TOKEN=$Token" }
    if (-not $doneStore) { $newContent += "SHOPIFY_STORE_DOMAIN=aodrop.com" }
    if (-not $doneTheme -and $ThemeId) { $newContent += "SHOPIFY_THEME_ID=$ThemeId" }
    $newContent | Out-File -FilePath $envPath -Encoding UTF8
}

Remove-Item $pastePath -Force
Write-Host "[OK] Token saved to .env.local; paste file removed." -ForegroundColor Green
Write-Host "Verify with: .\scripts\run-runbook.ps1" -ForegroundColor Cyan
