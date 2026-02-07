# Create GitHub issue/task automatically

param(
    [Parameter(Mandatory=$true)]
    [string]$Title,
    
    [string]$Type = "task",
    [string]$Priority = "medium",
    [string]$Body = "",
    [string]$Labels = ""
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Create GitHub Task ===" -ForegroundColor Cyan
Write-Host ""

# Check if GitHub CLI is installed
if (Get-Command gh -ErrorAction SilentlyContinue) {
    Write-Host "Using GitHub CLI to create issue..." -ForegroundColor Yellow
    
    $labelList = @($Type, $Priority)
    if (-not [string]::IsNullOrWhiteSpace($Labels)) {
        $labelList += $Labels -split ','
    }
    
    $labelArgs = $labelList | ForEach-Object { "-l $_" }
    $labelString = $labelArgs -join ' '
    
    $issueBody = if ([string]::IsNullOrWhiteSpace($Body)) {
        "Created via automation script"
    } else {
        $Body
    }
    
    $command = "gh issue create --title `"$Title`" --body `"$issueBody`" $labelString"
    Invoke-Expression $command
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Issue created successfully!" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Failed to create issue" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "GitHub CLI not found. Manual creation required." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Go to: https://github.com/toodeceptive/against-the-odds/issues/new" -ForegroundColor Cyan
    Write-Host "Title: $Title" -ForegroundColor White
    Write-Host "Type: $Type" -ForegroundColor White
    Write-Host "Priority: $Priority" -ForegroundColor White
    Write-Host ""
    Write-Host "Or install GitHub CLI: https://cli.github.com/" -ForegroundColor Yellow
}
