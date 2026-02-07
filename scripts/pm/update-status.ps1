# Update issue/task status

param(
    [Parameter(Mandatory=$true)]
    [int]$IssueNumber,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("todo", "in-progress", "review", "done")]
    [string]$Status
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Update Issue Status ===" -ForegroundColor Cyan
Write-Host ""

# Check if GitHub CLI is installed
if (Get-Command gh -ErrorAction SilentlyContinue) {
    # Remove old status labels
    $oldLabels = @("todo", "in-progress", "review", "done")
    foreach ($label in $oldLabels) {
        if ($label -ne $Status) {
            gh issue edit $IssueNumber --remove-label $label 2>$null
        }
    }
    
    # Add new status label
    gh issue edit $IssueNumber --add-label $Status
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Issue #$IssueNumber status updated to: $Status" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Failed to update issue status" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "GitHub CLI not found. Manual update required." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Go to: https://github.com/toodeceptive/against-the-odds/issues/$IssueNumber" -ForegroundColor Cyan
    Write-Host "Update label to: $Status" -ForegroundColor White
}
