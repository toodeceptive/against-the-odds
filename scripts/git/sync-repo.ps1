# Complete repository synchronization script
# Syncs local and remote repositories with conflict resolution

param(
    [string]$Branch = "main",
    [switch]$AutoResolve = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Repository Sync Script ===" -ForegroundColor Cyan
Write-Host ""

# Clear proxy for this session
$env:HTTP_PROXY = $null
$env:HTTPS_PROXY = $null
$env:http_proxy = $null
$env:https_proxy = $null

# Check current branch
$currentBranch = git branch --show-current
Write-Host "Current branch: $currentBranch" -ForegroundColor Yellow
Write-Host "Target branch: $Branch" -ForegroundColor Yellow
Write-Host ""

# Fetch latest changes
Write-Host "Fetching from remote..." -ForegroundColor Yellow
try {
    git -c http.proxy= -c https.proxy= fetch origin $Branch
    Write-Host "[OK] Fetched latest changes" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Failed to fetch: $_" -ForegroundColor Red
    exit 1
}

# Check local status
$status = git status --porcelain
if (-not [string]::IsNullOrWhiteSpace($status)) {
    Write-Host ""
    Write-Host "Uncommitted changes detected:" -ForegroundColor Yellow
    git status --short
    Write-Host ""
    
    if (-not $AutoResolve) {
        $response = Read-Host "Commit changes before syncing? (y/n)"
        if ($response -eq "y") {
            & "$PSScriptRoot\auto-commit.ps1"
        }
    } else {
        & "$PSScriptRoot\auto-commit.ps1"
    }
}

# Check if branches have diverged
$localCommit = git rev-parse HEAD
$remoteCommit = git rev-parse "origin/$Branch" 2>$null

if (-not $remoteCommit) {
    Write-Host "Remote branch '$Branch' does not exist." -ForegroundColor Yellow
    Write-Host "Creating and pushing local branch..." -ForegroundColor Yellow
    git -c http.proxy= -c https.proxy= push -u origin $Branch
    Write-Host "[OK] Created remote branch" -ForegroundColor Green
    exit 0
}

Write-Host ""
Write-Host "Local commit:  $localCommit" -ForegroundColor Cyan
Write-Host "Remote commit: $remoteCommit" -ForegroundColor Cyan
Write-Host ""

if ($localCommit -eq $remoteCommit) {
    Write-Host "[OK] Branches are in sync" -ForegroundColor Green
    exit 0
}

# Check if we're ahead, behind, or diverged
$commitsAhead = (git rev-list --count "origin/$Branch..HEAD" 2>$null) -as [int]
$commitsBehind = (git rev-list --count "HEAD..origin/$Branch" 2>$null) -as [int]

if ($commitsAhead -gt 0 -and $commitsBehind -gt 0) {
    Write-Host "[WARN] Branches have diverged!" -ForegroundColor Yellow
    Write-Host "Local is $commitsAhead commit(s) ahead, $commitsBehind commit(s) behind" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "Attempting to merge..." -ForegroundColor Yellow
    try {
        git merge "origin/$Branch" --no-edit
        Write-Host "[OK] Successfully merged" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] Merge conflict!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Conflicted files:" -ForegroundColor Yellow
        git diff --name-only --diff-filter=U
        Write-Host ""
        Write-Host "Please resolve conflicts manually:" -ForegroundColor Yellow
        Write-Host "1. Edit conflicted files" -ForegroundColor White
        Write-Host "2. Run: git add <file>" -ForegroundColor White
        Write-Host "3. Run: git commit" -ForegroundColor White
        Write-Host "4. Run this script again" -ForegroundColor White
        exit 1
    }
} elseif ($commitsBehind -gt 0) {
    Write-Host "Local branch is $commitsBehind commit(s) behind remote" -ForegroundColor Yellow
    Write-Host "Pulling changes..." -ForegroundColor Yellow
    try {
        git pull origin $Branch --no-edit
        Write-Host "[OK] Successfully pulled changes" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] Pull failed: $_" -ForegroundColor Red
        exit 1
    }
} elseif ($commitsAhead -gt 0) {
    Write-Host "Local branch is $commitsAhead commit(s) ahead of remote" -ForegroundColor Yellow
    Write-Host "Pushing changes..." -ForegroundColor Yellow
    try {
        git -c http.proxy= -c https.proxy= push origin $Branch
        Write-Host "[OK] Successfully pushed changes" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] Push failed: $_" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "[OK] Repository synchronized successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Current status:" -ForegroundColor Cyan
git status --short
