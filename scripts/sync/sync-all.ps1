# Master synchronization script for all platforms

param(
    [switch]$DryRun = $false,
    [switch]$SkipGit = $false,
    [switch]$SkipShopify = $false
)

$ErrorActionPreference = "Stop"
# Load shared helpers used by this script (Write-Success / Write-Warning).
. (Join-Path $PSScriptRoot "..\shared\utilities.ps1")
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Master Synchronization ===" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN MODE - No changes will be made]" -ForegroundColor Yellow
    Write-Host ""
}

# 1. Git Synchronization
if (-not $SkipGit) {
    Write-Host "1. Synchronizing Git repository..." -ForegroundColor Yellow
    if ($DryRun) {
        Write-Host "  [DRY RUN] Would sync Git repository" -ForegroundColor Cyan
    } else {
        try {
            git fetch origin 2>&1 | Out-Null
            $status = git status --porcelain
            if ($status) {
                Write-Warning "Uncommitted changes detected. Commit or stash first."
            } else {
                git pull origin main 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "Git repository synchronized"
                } else {
                    Write-Warning "Git pull had issues"
                }
            }
        } catch {
            Write-Warning "Git sync failed: $_"
        }
    }
    Write-Host ""
}

# 2. Shopify Product Synchronization
if (-not $SkipShopify) {
    Write-Host "2. Synchronizing Shopify products..." -ForegroundColor Yellow
    if ($DryRun) {
        Write-Host "  [DRY RUN] Would sync products" -ForegroundColor Cyan
    } else {
        if (Test-Path "scripts\products\sync.ps1") {
            try {
                & "scripts\products\sync.ps1" -Direction both
                Write-Success "Products synchronized"
            } catch {
                Write-Warning "Product sync failed: $_"
            }
        } else {
            Write-Warning "Product sync script not found"
        }
    }
    Write-Host ""
}

# 3. Verify synchronization
Write-Host "3. Verifying synchronization..." -ForegroundColor Yellow
if (-not $DryRun) {
    & "scripts\sync\verify-all.ps1"
}

Write-Host ""
Write-Success "Synchronization complete!"
