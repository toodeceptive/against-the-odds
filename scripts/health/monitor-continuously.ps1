# Continuous monitoring script

param(
    [int]$IntervalSeconds = 300,
    [int]$MaxIterations = 0
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Continuous Monitoring ===" -ForegroundColor Cyan
Write-Host "Monitoring interval: $IntervalSeconds seconds" -ForegroundColor Yellow
if ($MaxIterations -gt 0) {
    Write-Host "Max iterations: $MaxIterations" -ForegroundColor Yellow
} else {
    Write-Host "Running indefinitely (Ctrl+C to stop)" -ForegroundColor Yellow
}
Write-Host ""

$iteration = 0

while ($true) {
    $iteration++
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    Write-Host "[$timestamp] Health Check #$iteration" -ForegroundColor Cyan
    Write-Host ""
    
    & "scripts\health\comprehensive-check.ps1"
    
    if ($MaxIterations -gt 0 -and $iteration -ge $MaxIterations) {
        Write-Host ""
        Write-Host "Reached max iterations. Stopping." -ForegroundColor Yellow
        break
    }
    
    Write-Host ""
    Write-Host "Waiting $IntervalSeconds seconds until next check..." -ForegroundColor Gray
    Start-Sleep -Seconds $IntervalSeconds
    Write-Host ""
}
