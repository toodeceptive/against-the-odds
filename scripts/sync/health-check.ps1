# Comprehensive health check for all systems

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Comprehensive Health Check ===" -ForegroundColor Cyan
Write-Host ""

$health = @{
    timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    systems = @{}
    overall = "unknown"
}

# Load shared utilities if available
$utilitiesPath = "scripts\shared\utilities.ps1"
if (Test-Path $utilitiesPath) {
    . $utilitiesPath
}

# Check Git
Write-Host "Checking Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    $health.systems.git = @{ status = "ok"; version = $gitVersion }
    Write-Success "Git: $gitVersion"
} catch {
    $health.systems.git = @{ status = "error"; error = $_.Exception.Message }
    Write-Warning "Git check failed"
}

# Check Node.js
Write-Host "Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    $health.systems.node = @{ status = "ok"; version = $nodeVersion }
    Write-Success "Node.js: $nodeVersion"
} catch {
    $health.systems.node = @{ status = "error"; error = "Node.js not found" }
    Write-Warning "Node.js not found"
}

# Check npm
Write-Host "Checking npm..." -ForegroundColor Yellow
try {
    $npmVersion = npm --version
    $health.systems.npm = @{ status = "ok"; version = $npmVersion }
    Write-Success "npm: $npmVersion"
} catch {
    $health.systems.npm = @{ status = "error"; error = "npm not found" }
    Write-Warning "npm not found"
}

# Check PowerShell
Write-Host "Checking PowerShell..." -ForegroundColor Yellow
$psVersion = $PSVersionTable.PSVersion.ToString()
$health.systems.powershell = @{ status = "ok"; version = $psVersion }
Write-Success "PowerShell: $psVersion"

# Check Shopify CLI
Write-Host "Checking Shopify CLI..." -ForegroundColor Yellow
try {
    $shopifyVersion = shopify version 2>&1
    if ($LASTEXITCODE -eq 0) {
        $health.systems.shopify_cli = @{ status = "ok"; version = $shopifyVersion }
        Write-Success "Shopify CLI: $shopifyVersion"
    } else {
        $health.systems.shopify_cli = @{ status = "warning"; message = "Shopify CLI not installed" }
        Write-Warning "Shopify CLI not installed"
    }
} catch {
    $health.systems.shopify_cli = @{ status = "warning"; message = "Shopify CLI not found" }
    Write-Warning "Shopify CLI not found"
}

# Check Playwright
Write-Host "Checking Playwright..." -ForegroundColor Yellow
try {
    if (Test-Path "node_modules\@playwright\test") {
        $health.systems.playwright = @{ status = "ok"; installed = $true }
        Write-Success "Playwright installed"
    } else {
        $health.systems.playwright = @{ status = "warning"; message = "Playwright not installed" }
        Write-Warning "Playwright not installed (run: npm install)"
    }
} catch {
    $health.systems.playwright = @{ status = "warning"; message = "Could not check Playwright" }
}

# Check environment
Write-Host "Checking environment..." -ForegroundColor Yellow
if (Test-Path ".env.local") {
    $health.systems.environment = @{ status = "ok"; configured = $true }
    Write-Success "Environment file exists"
} else {
    $health.systems.environment = @{ status = "warning"; message = ".env.local not found" }
    Write-Warning ".env.local not found"
}

# Check repository
Write-Host "Checking repository..." -ForegroundColor Yellow
try {
    $remoteUrl = git remote get-url origin
    $health.systems.repository = @{ status = "ok"; remote = $remoteUrl }
    Write-Success "Repository: $remoteUrl"
} catch {
    $health.systems.repository = @{ status = "error"; error = "Could not get remote URL" }
    Write-Warning "Repository check failed"
}

# Determine overall health
$errors = ($health.systems.Values | Where-Object { $_.status -eq "error" }).Count
$warnings = ($health.systems.Values | Where-Object { $_.status -eq "warning" }).Count

if ($errors -eq 0 -and $warnings -eq 0) {
    $health.overall = "healthy"
} elseif ($errors -eq 0) {
    $health.overall = "degraded"
} else {
    $health.overall = "unhealthy"
}

# Save health report
$healthDir = "docs\status"
if (-not (Test-Path $healthDir)) {
    New-Item -ItemType Directory -Force -Path $healthDir | Out-Null
}

$healthFile = "$healthDir\health-report.json"
$health | ConvertTo-Json -Depth 10 | Out-File -FilePath $healthFile -Encoding UTF8

Write-Host ""
Write-Host "=== Health Summary ===" -ForegroundColor Cyan
Write-Host "Overall Status: $($health.overall)" -ForegroundColor $(if ($health.overall -eq "healthy") { "Green" } elseif ($health.overall -eq "degraded") { "Yellow" } else { "Red" })
Write-Host "Errors: $errors" -ForegroundColor $(if ($errors -eq 0) { "Green" } else { "Red" })
Write-Host "Warnings: $warnings" -ForegroundColor $(if ($warnings -eq 0) { "Green" } else { "Yellow" })
Write-Host ""
Write-Host "Health report saved to: $healthFile" -ForegroundColor Cyan
