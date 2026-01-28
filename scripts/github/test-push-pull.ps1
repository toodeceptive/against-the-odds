# Test GitHub repository push and pull operations

param(
    [switch]$TestPush = $true,
    [switch]$TestPull = $true
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== GitHub Push/Pull Test ===" -ForegroundColor Cyan
Write-Host ""

# Get current branch
$currentBranch = git branch --show-current
Write-Host "Current branch: $currentBranch" -ForegroundColor Cyan
Write-Host ""

# Test Pull
if ($TestPull) {
    Write-Host "Testing pull operation..." -ForegroundColor Yellow
    try {
        $pullOutput = git pull origin $currentBranch 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Pull successful" -ForegroundColor Green
            if ($pullOutput -match 'Already up to date') {
                Write-Host "    Repository is up to date" -ForegroundColor Cyan
            } else {
                Write-Host "    Changes pulled successfully" -ForegroundColor Cyan
            }
        } else {
            Write-Host "  ✗ Pull failed" -ForegroundColor Red
            Write-Host "    $pullOutput" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ✗ Pull error: $_" -ForegroundColor Red
    }
    Write-Host ""
}

# Test Push
if ($TestPush) {
    Write-Host "Testing push operation..." -ForegroundColor Yellow
    
    # Check if there are uncommitted changes
    $status = git status --porcelain
    if ($status) {
        Write-Host "  ⚠ Uncommitted changes detected" -ForegroundColor Yellow
        Write-Host "    Commit changes first or use -TestPush:$false to skip" -ForegroundColor Yellow
    } else {
        # Check if there are commits to push
        $ahead = git rev-list --count origin/$currentBranch..HEAD 2>&1
        if ($ahead -gt 0) {
            Write-Host "  Found $ahead commit(s) to push" -ForegroundColor Cyan
            try {
                $pushOutput = git push origin $currentBranch 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "  ✓ Push successful" -ForegroundColor Green
                } else {
                    Write-Host "  ✗ Push failed" -ForegroundColor Red
                    Write-Host "    $pushOutput" -ForegroundColor Red
                }
            } catch {
                Write-Host "  ✗ Push error: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "  ✓ No commits to push (up to date)" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "✓ Push/Pull test complete!" -ForegroundColor Green
