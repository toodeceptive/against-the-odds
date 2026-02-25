# Script to create and push to against-the-odds repository
# This script handles proxy issues and repository creation

# Clear proxy environment variables for this session
$env:HTTP_PROXY = $null
$env:HTTPS_PROXY = $null
$env:http_proxy = $null
$env:https_proxy = $null

Write-Host "=== Against The Odds Repository Setup ===" -ForegroundColor Cyan
Write-Host ""

# Navigate to repository
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

# Check if repository exists on GitHub
Write-Host "Checking if repository exists on GitHub..." -ForegroundColor Yellow
$checkRepo = git -c http.proxy= -c https.proxy= ls-remote origin 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Repository exists on GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Pushing local commits..." -ForegroundColor Yellow
    git -c http.proxy= -c https.proxy= push -u origin main
} else {
    Write-Host "Repository doesn't exist yet or authentication needed." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To create the repository:" -ForegroundColor Cyan
    Write-Host "1. Go to: https://github.com/new" -ForegroundColor White
    Write-Host "2. Repository name: against-the-odds" -ForegroundColor White
    Write-Host "3. Set to PRIVATE" -ForegroundColor White
    Write-Host "4. DO NOT initialize with README/gitignore/license" -ForegroundColor White
    Write-Host "5. Click 'Create repository'" -ForegroundColor White
    Write-Host ""
    Write-Host "Then run this script again to push your code." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Or use GitHub CLI (if installed):" -ForegroundColor Cyan
    Write-Host "  gh repo create against-the-odds --private --source=. --remote=origin --push" -ForegroundColor White
}

Write-Host ""
Write-Host "Current repository status:" -ForegroundColor Cyan
git status
Write-Host ""
Write-Host "Recent commits ready to push:" -ForegroundColor Cyan
git log --oneline -5
