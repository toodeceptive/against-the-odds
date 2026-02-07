# Generate comprehensive health report

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Generating Health Report ===" -ForegroundColor Cyan
Write-Host ""

# Ensure reports directory exists
$reportsDir = "docs\status"
if (-not (Test-Path $reportsDir)) {
    New-Item -ItemType Directory -Force -Path $reportsDir | Out-Null
}

# Run all checks and collect data
$report = @{
    timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    checks = @()
}

# Health check
Write-Host "Running health check..." -ForegroundColor Yellow
& "scripts\sync\health-check.ps1" | Out-Null
if (Test-Path "$reportsDir\health-report.json") {
    $healthData = Get-Content "$reportsDir\health-report.json" | ConvertFrom-Json
    $report.checks += @{ type = "system_health"; data = $healthData }
}

# Performance check
Write-Host "Running performance check..." -ForegroundColor Yellow
& "scripts\monitoring\performance-check.ps1" | Out-Null
if (Test-Path "$reportsDir\performance-report.json") {
    $perfData = Get-Content "$reportsDir\performance-report.json" | ConvertFrom-Json
    $report.checks += @{ type = "performance"; data = $perfData }
}

# Credential verification
Write-Host "Verifying credentials..." -ForegroundColor Yellow
$credResults = & "scripts\setup\verify-credentials.ps1" -Quiet
$report.checks += @{ type = "credentials"; data = $credResults }

# Synchronization check
Write-Host "Checking synchronization..." -ForegroundColor Yellow
$syncResults = & "scripts\sync\verify-all.ps1" 2>&1
$report.checks += @{ type = "synchronization"; status = if ($LASTEXITCODE -eq 0) { "ok" } else { "issues" } }

# Generate report
$reportFile = "$reportsDir\comprehensive-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
$report | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host ""
Write-Success "Comprehensive report generated: $reportFile"
