# Alert system for issues

param(
    [string]$AlertMethod = "console"
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Issue Alert System ===" -ForegroundColor Cyan
Write-Host ""

# Run verification
$issues = @()
$warnings = @()

# Check health
& "scripts\sync\health-check.ps1" | Out-Null
$healthFile = "docs\status\health-report.json"
if (Test-Path $healthFile) {
    $health = Get-Content $healthFile | ConvertFrom-Json
    if ($health.overall -ne "healthy") {
        $issues += "System health: $($health.overall)"
    }
}

# Check credentials
$credResults = & "scripts\setup\verify-credentials.ps1" -Quiet
if ($credResults.github.status -ne "valid" -and $credResults.github.status -ne "missing") {
    $issues += "GitHub credentials invalid"
}
if ($credResults.shopify.status -ne "valid" -and $credResults.shopify.status -ne "missing") {
    $issues += "Shopify credentials invalid"
}

# Check synchronization
$syncOutput = & "scripts\sync\verify-all.ps1" 2>&1
if ($LASTEXITCODE -ne 0) {
    $issues += "Synchronization issues detected"
}

# Generate alerts
if ($issues.Count -gt 0) {
    Write-Host "ALERT: Issues detected!" -ForegroundColor Red
    Write-Host ""
    foreach ($issue in $issues) {
        Write-Host "  [FAIL] $issue" -ForegroundColor Red
    }
    
    # Save alert log
    $alertLog = "docs\status\alerts-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
    $alertDir = Split-Path $alertLog -Parent
    if (-not (Test-Path $alertDir)) {
        New-Item -ItemType Directory -Force -Path $alertDir | Out-Null
    }
    
    $alertContent = @"
Alert Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

Issues:
$($issues -join "`n")

Warnings:
$($warnings -join "`n")
"@
    
    $alertContent | Out-File -FilePath $alertLog -Encoding UTF8
    Write-Host ""
    Write-Host "Alert log saved to: $alertLog" -ForegroundColor Cyan
    
    exit 1
} else {
    Write-Success "No critical issues detected"
    exit 0
}
