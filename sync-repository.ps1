# Sync Against The Odds Repository
# This script syncs local and remote repositories

Write-Host "=== Against The Odds Repository Sync ===" -ForegroundColor Cyan
Write-Host ""

# Clear proxy for this session
$env:HTTP_PROXY = $null
$env:HTTPS_PROXY = $null
$env:http_proxy = $null
$env:https_proxy = $null

$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "Repository: $repoPath" -ForegroundColor Yellow
Write-Host "Remote: https://github.com/toodeceptive/against-the-odds.git" -ForegroundColor Yellow
Write-Host "Status: PUBLIC" -ForegroundColor Green
Write-Host ""

# Check current status
Write-Host "Current local commits:" -ForegroundColor Cyan
git log --oneline -5
Write-Host ""

# Try to fetch (may require authentication)
Write-Host "Attempting to fetch from remote..." -ForegroundColor Yellow
$fetchResult = git -c http.proxy= -c https.proxy= fetch origin 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Successfully fetched from remote!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Remote branches:" -ForegroundColor Cyan
    git branch -r
    Write-Host ""
    
    # Check if we need to merge
    $localCommit = git rev-parse HEAD
    $remoteCommit = git rev-parse origin/main 2>$null
    
    if ($remoteCommit -and $localCommit -ne $remoteCommit) {
        Write-Host "Remote has different commits. Merging..." -ForegroundColor Yellow
        git merge origin/main --no-edit
        Write-Host "✓ Merge complete!" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Pushing local commits..." -ForegroundColor Yellow
    git -c http.proxy= -c https.proxy= push -u origin main 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Successfully pushed to GitHub!" -ForegroundColor Green
    } else {
        Write-Host "Push requires authentication." -ForegroundColor Yellow
        Write-Host "Please authenticate when prompted, or use GitHub Desktop." -ForegroundColor Yellow
    }
} else {
    Write-Host "Fetch requires authentication or repository access." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "1. Use GitHub Desktop to sync" -ForegroundColor White
    Write-Host "2. Run: git -c http.proxy= -c https.proxy= push -u origin main" -ForegroundColor White
    Write-Host "   (Windows will prompt for GitHub credentials)" -ForegroundColor Gray
    Write-Host "3. Create a Personal Access Token and use it for authentication" -ForegroundColor White
}

Write-Host ""
Write-Host "Repository Status:" -ForegroundColor Cyan
git status
