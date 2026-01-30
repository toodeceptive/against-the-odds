# Auto-push script with conflict detection
# Automatically pushes commits with safety checks

param(
    [string]$Branch = "main",
    [switch]$Force = $false,
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Auto-Push Script ===" -ForegroundColor Cyan
Write-Host ""

# Check current branch
$currentBranch = git branch --show-current
if ($currentBranch -ne $Branch) {
    Write-Host "Warning: Current branch is '$currentBranch', not '$Branch'" -ForegroundColor Yellow
    $response = Read-Host "Continue anyway? (y/n)"
    if ($response -ne "y") {
        exit 0
    }
}

# Check for uncommitted changes
$status = git status --porcelain
if (-not [string]::IsNullOrWhiteSpace($status)) {
    Write-Host "Warning: You have uncommitted changes:" -ForegroundColor Yellow
    git status --short
    Write-Host ""
    $response = Read-Host "Commit changes first? (y/n)"
    if ($response -eq "y") {
        & "$PSScriptRoot\auto-commit.ps1"
    } else {
        Write-Host "Aborting push due to uncommitted changes." -ForegroundColor Red
        exit 1
    }
}

# Fetch latest changes
Write-Host "Fetching latest changes from remote..." -ForegroundColor Yellow
try {
    git fetch origin $Branch
} catch {
    Write-Host "Warning: Failed to fetch from remote: $_" -ForegroundColor Yellow
}

# Check for conflicts
$localCommit = git rev-parse HEAD
$remoteCommit = git rev-parse "origin/$Branch" 2>$null

if ($remoteCommit -and $localCommit -ne $remoteCommit) {
    Write-Host ""
    Write-Host "Remote branch has new commits." -ForegroundColor Yellow
    Write-Host "Local:  $localCommit" -ForegroundColor Cyan
    Write-Host "Remote: $remoteCommit" -ForegroundColor Cyan
    Write-Host ""
    
    # Try to merge
    Write-Host "Attempting to merge remote changes..." -ForegroundColor Yellow
    try {
        git merge "origin/$Branch" --no-edit
        Write-Host "[OK] Successfully merged remote changes" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] Merge conflict detected!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Conflicted files:" -ForegroundColor Yellow
        git diff --name-only --diff-filter=U
        Write-Host ""
        Write-Host "Please resolve conflicts manually and try again." -ForegroundColor Yellow
        exit 1
    }
}

# Check if there's anything to push
$commitsAhead = git rev-list --count "origin/$Branch..HEAD" 2>$null
if ($commitsAhead -eq 0) {
    Write-Host "No commits to push. Local branch is up to date." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Commits to push: $commitsAhead" -ForegroundColor Cyan
git log "origin/$Branch..HEAD" --oneline
Write-Host ""

# Dry run mode
if ($DryRun) {
    Write-Host "DRY RUN - Would push to origin/$Branch" -ForegroundColor Yellow
    exit 0
}

# Push
Write-Host "Pushing to origin/$Branch..." -ForegroundColor Yellow
try {
    if ($Force) {
        Write-Host "Warning: Force push enabled!" -ForegroundColor Red
        git push origin $Branch --force
    } else {
        git push origin $Branch
    }
    Write-Host "[OK] Successfully pushed to origin/$Branch" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Failed to push: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible solutions:" -ForegroundColor Yellow
    Write-Host "1. Check your authentication (see config/github-auth.md)" -ForegroundColor White
    Write-Host "2. Pull and merge remote changes first" -ForegroundColor White
    Write-Host "3. Check network connectivity" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "Push completed successfully!" -ForegroundColor Green
