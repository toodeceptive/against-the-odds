# Automatically fix synchronization issues

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Automatic Synchronization Fix ===" -ForegroundColor Cyan
Write-Host ""

$fixesApplied = 0

# Fix 1: Create .env.local if missing
if (-not (Test-Path ".env.local")) {
    Write-Host "Fixing: Creating .env.local..." -ForegroundColor Yellow
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env.local"
        Write-Success ".env.local created"
        $fixesApplied++
    }
}

# Fix 2: Sync Git repository
Write-Host "Fixing: Syncing Git repository..." -ForegroundColor Yellow
try {
    git fetch origin 2>&1 | Out-Null
    $status = git status --porcelain
    if ($status) {
        Write-Warning "Uncommitted changes detected. Commit or stash before syncing."
    } else {
        git pull origin main 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Git repository synced"
            $fixesApplied++
        }
    }
} catch {
    Write-Warning "Could not sync Git repository: $_"
}

# Fix 3: Install dependencies if package.json exists
if (Test-Path "package.json") {
    Write-Host "Fixing: Checking dependencies..." -ForegroundColor Yellow
    if (-not (Test-Path "node_modules")) {
        Write-Host "  Installing npm dependencies..." -ForegroundColor Cyan
        npm install 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Dependencies installed"
            $fixesApplied++
        }
    } else {
        Write-Success "Dependencies already installed"
    }
}

# Fix 4: Create missing directories
$requiredDirs = @("scripts\shared", "docs\status", "docs\screenshots")
foreach ($dir in $requiredDirs) {
    if (-not (Test-Path $dir)) {
        Write-Host "Fixing: Creating directory $dir..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Write-Success "Directory created: $dir"
        $fixesApplied++
    }
}

Write-Host ""
Write-Host "=== Fix Summary ===" -ForegroundColor Cyan
Write-Host "Fixes applied: $fixesApplied" -ForegroundColor Green
Write-Host ""
Write-Host "Run verification: .\scripts\sync\verify-all.ps1" -ForegroundColor Cyan
