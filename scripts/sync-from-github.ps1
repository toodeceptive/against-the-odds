# Sync Repository from GitHub
# This script safely pulls code from GitHub and merges with local changes

Write-Host "=== Repository Synchronization Script ===" -ForegroundColor Cyan
Write-Host ""

# Clear proxy for this session
$env:HTTP_PROXY = $null
$env:HTTPS_PROXY = $null
$env:http_proxy = $null
$env:https_proxy = $null

$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "Repository: $repoPath" -ForegroundColor Yellow
Write-Host ""

# Check current status
Write-Host "Current local status:" -ForegroundColor Cyan
git status --short
Write-Host ""

# Check if there are uncommitted changes
$uncommitted = git diff --quiet
if (-not $uncommitted) {
    Write-Host "[WARN]  Warning: You have uncommitted changes!" -ForegroundColor Yellow
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "1. Commit changes first (recommended)" -ForegroundColor White
    Write-Host "2. Stash changes" -ForegroundColor White
    Write-Host "3. Cancel and handle manually" -ForegroundColor White
    Write-Host ""
    $choice = Read-Host "Enter choice (1-3)"
    
    if ($choice -eq "1") {
        Write-Host "Committing changes..." -ForegroundColor Yellow
        git add -A
        $message = Read-Host "Enter commit message"
        git commit -m $message
    } elseif ($choice -eq "2") {
        Write-Host "Stashing changes..." -ForegroundColor Yellow
        git stash push -m "Stashed before sync $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    } else {
        Write-Host "Cancelled. Please handle uncommitted changes manually." -ForegroundColor Red
        exit 1
    }
}

# Attempt to fetch from remote
Write-Host "Fetching from GitHub..." -ForegroundColor Yellow
$fetchResult = git -c http.proxy= -c https.proxy= fetch origin 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Successfully fetched from GitHub!" -ForegroundColor Green
    Write-Host ""
    
    # Check if remote has different commits
    $localCommit = git rev-parse HEAD
    $remoteCommit = git rev-parse origin/main 2>$null
    
    if ($remoteCommit -and $localCommit -ne $remoteCommit) {
        Write-Host "Remote has different commits. Checking differences..." -ForegroundColor Yellow
        Write-Host ""
        
        # Show what would be merged
        Write-Host "Files that would be updated:" -ForegroundColor Cyan
        git diff --name-only HEAD origin/main
        Write-Host ""
        
        $confirm = Read-Host "Merge remote changes? (y/n)"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            Write-Host "Merging remote changes..." -ForegroundColor Yellow
            git merge origin/main --no-edit
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] Successfully merged remote changes!" -ForegroundColor Green
            } else {
                Write-Host "[WARN]  Merge conflicts detected!" -ForegroundColor Red
                Write-Host "Please resolve conflicts manually:" -ForegroundColor Yellow
                Write-Host "1. Review conflicts: git status" -ForegroundColor White
                Write-Host "2. Resolve conflicts in files" -ForegroundColor White
                Write-Host "3. Stage resolved files: git add <file>" -ForegroundColor White
                Write-Host "4. Complete merge: git commit" -ForegroundColor White
            }
        } else {
            Write-Host "Merge cancelled." -ForegroundColor Yellow
        }
    } else {
        Write-Host "[OK] Local and remote are in sync!" -ForegroundColor Green
    }
} else {
    Write-Host "[WARN]  Fetch failed. Possible reasons:" -ForegroundColor Yellow
    Write-Host "1. Authentication required" -ForegroundColor White
    Write-Host "2. Network issues" -ForegroundColor White
    Write-Host "3. Repository access issues" -ForegroundColor White
    Write-Host ""
    Write-Host "Solutions:" -ForegroundColor Cyan
    Write-Host "1. Use GitHub Desktop for authentication" -ForegroundColor White
    Write-Host "2. Create Personal Access Token and use it" -ForegroundColor White
    Write-Host "3. Use: git -c http.proxy= -c https.proxy= push -u origin main" -ForegroundColor White
    Write-Host "   (Windows will prompt for credentials)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Final status:" -ForegroundColor Cyan
git status
