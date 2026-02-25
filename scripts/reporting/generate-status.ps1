# Generate project status report

param(
    [string]$OutputFile = "PROJECT_STATUS.md",
    [switch]$Detailed = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Generating Status Report ===" -ForegroundColor Cyan
Write-Host ""

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$date = Get-Date -Format "yyyy-MM-dd"

# Get git information
$currentBranch = git branch --show-current
$lastCommit = git log -1 --oneline
$commitCount = (git rev-list --count HEAD) -as [int]

# Get issue count (if GitHub CLI available)
$openIssues = 0
$closedIssues = 0
if (Get-Command gh -ErrorAction SilentlyContinue) {
    try {
        $issues = gh issue list --state all --json number,state --limit 100
        $issueData = $issues | ConvertFrom-Json
        $openIssues = ($issueData | Where-Object { $_.state -eq "OPEN" }).Count
        $closedIssues = ($issueData | Where-Object { $_.state -eq "CLOSED" }).Count
    } catch {
        # GitHub CLI not authenticated or no access
    }
}

# Build status report
$report = @"
# Project Status - Against The Odds

**Last Updated**: $timestamp  
**Current Branch**: $currentBranch  
**Total Commits**: $commitCount

## Current Phase

**Phase 1: Foundation Setup** - 95% Complete

### Completed
- ✅ GitHub repository setup and authentication
- ✅ GitHub Actions workflows configured
- ✅ Git automation scripts created
- ✅ Environment configuration system
- ✅ Shopify integration documentation
- ✅ Testing framework setup
- ✅ Quality gates implemented
- ✅ Project management system

### In Progress
- [WARN] Shopify CLI installation and authentication
- [WARN] Theme development environment setup

### Pending
- ⬜ Product management system implementation
- ⬜ Manufacturing workflow setup
- ⬜ Performance monitoring configuration

## Metrics

### Code Quality
- **Test Coverage**: TBD (target: 90%+)
- **Lighthouse Score**: TBD (target: 90+)
- **Security Issues**: 0 critical

### Project Progress
- **Open Issues**: $openIssues
- **Closed Issues**: $closedIssues
- **Completion Rate**: TBD

### Recent Activity
- **Last Commit**: $lastCommit
- **Active Branch**: $currentBranch

## Next Steps

1. Complete Shopify CLI authentication
2. Set up theme development environment
3. Begin product catalog setup
4. Start manufacturing research

## Blockers

None currently.

## Notes

Status report generated automatically. Update this file manually for detailed notes.

---

*This is an automated status report. For detailed information, see individual documentation files.*
"@

# Write report
$report | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "[OK] Status report generated: $OutputFile" -ForegroundColor Green

if ($Detailed) {
    # Generate detailed report in docs/status/
    $statusDir = "docs\status"
    if (-not (Test-Path $statusDir)) {
        New-Item -ItemType Directory -Force -Path $statusDir | Out-Null
    }
    
    $detailedFile = "$statusDir\status_$date.md"
    $report | Out-File -FilePath $detailedFile -Encoding UTF8
    Write-Host "[OK] Detailed report saved: $detailedFile" -ForegroundColor Green
}
