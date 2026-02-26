# Verify Cursor-GitHub-Shopify pipeline: scripts parse, workflows present, optional dry-run and runbook.
# Run from repo root: .\scripts\verify-pipeline.ps1

param(
    [switch]$SkipRunbook = $false,
    [switch]$SkipParse = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoPath

$failed = 0

Write-Host "=== Pipeline verification ===" -ForegroundColor Cyan
Write-Host ""

# 1. Parse PowerShell scripts
if (-not $SkipParse) {
    Write-Host "[1/5] Parsing PowerShell scripts..." -ForegroundColor Yellow
    $parseScript = Join-Path $repoPath (Join-Path "scripts" (Join-Path "debug" "parse-all-ps1.ps1"))
    if (Test-Path $parseScript) {
        & $parseScript
        if ($LASTEXITCODE -ne 0) { $failed++ }
    } else {
        Write-Host "  (parse-all-ps1.ps1 not found, skip)" -ForegroundColor Gray
    }
    Write-Host ""
}

# 2. Workflow files exist
Write-Host "[2/5] Checking workflow files..." -ForegroundColor Yellow
$workflows = @(
    ".github/workflows/ci.yml",
    ".github/workflows/codeql.yml",
    ".github/workflows/shopify-sync.yml",
    ".github/workflows/sync-theme-branch.yml",
    ".github/workflows/sync.yml",
    ".github/workflows/maintenance.yml"
)
foreach ($w in $workflows) {
    $fullPath = Join-Path $repoPath $w
    if (Test-Path $fullPath) {
        Write-Host "  OK $w" -ForegroundColor Green
    } else {
        Write-Host "  MISSING $w" -ForegroundColor Red
        $failed++
    }
}
Write-Host ""

# 3. Product sync dry-run (if env has Shopify creds)
Write-Host "[3/5] Product sync dry-run (if .env.local has Shopify creds)..." -ForegroundColor Yellow
$envPath = Join-Path $repoPath ".env.local"
if (Test-Path $envPath) {
    Get-Content $envPath | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line -match "^([^=]+)=(.*)$") {
            [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim(), "Process")
        }
    }
}
$store = [Environment]::GetEnvironmentVariable("SHOPIFY_STORE_DOMAIN", "Process")
$token = [Environment]::GetEnvironmentVariable("SHOPIFY_ACCESS_TOKEN", "Process")
if ($store -and $token) {
    $syncScript = Join-Path $repoPath (Join-Path "scripts" (Join-Path "shopify" "sync-products.ps1"))
    if (Test-Path $syncScript) {
        & $syncScript -DryRun
        if ($LASTEXITCODE -ne 0) { $failed++ }
    } else {
        Write-Host "  MISSING scripts/shopify/sync-products.ps1" -ForegroundColor Red
        $failed++
    }
} else {
    Write-Host "  (SHOPIFY_STORE_DOMAIN or SHOPIFY_ACCESS_TOKEN not set, skip dry-run)" -ForegroundColor Gray
}
Write-Host ""

# 4. Lint
Write-Host "[4/5] Lint (ESLint)..." -ForegroundColor Yellow
if (Test-Path (Join-Path $repoPath "package.json")) {
    npm run lint 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Lint reported issues." -ForegroundColor Red
        $failed++
    } else {
        Write-Host "  OK" -ForegroundColor Green
    }
} else {
    Write-Host "  (no package.json, skip)" -ForegroundColor Gray
}
Write-Host ""

# 5. Runbook (Shopify + GitHub checks)
if (-not $SkipRunbook) {
    Write-Host "[5/5] Runbook (Shopify + GitHub verification)..." -ForegroundColor Yellow
    $runbook = Join-Path $repoPath (Join-Path "scripts" "run-runbook.ps1")
    if (Test-Path $runbook) {
        & $runbook
        if ($LASTEXITCODE -ne 0) { $failed++ }
    } else {
        Write-Host "  (run-runbook.ps1 not found, skip)" -ForegroundColor Gray
    }
} else {
    Write-Host "[5/5] Runbook skipped (use -SkipRunbook to skip)." -ForegroundColor Gray
}

Write-Host ""
if ($failed -gt 0) {
    Write-Host "Verification finished with $failed failure(s)." -ForegroundColor Red
    exit 1
}
Write-Host "Verification passed." -ForegroundColor Green
exit 0
