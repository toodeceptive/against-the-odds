# Comprehensive GitHub Authentication Verification

param(
    [switch]$TestPush = $false,
    [switch]$TestPull = $false,
    [switch]$CheckSecrets = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== GitHub Authentication Verification ===" -ForegroundColor Cyan
Write-Host ""

# Check Git configuration
Write-Host "Checking Git configuration..." -ForegroundColor Yellow
$gitUser = git config user.name
$gitEmail = git config user.email
$remoteUrl = git remote get-url origin

Write-Host "  Git User: $gitUser" -ForegroundColor Cyan
Write-Host "  Git Email: $gitEmail" -ForegroundColor Cyan
Write-Host "  Remote URL: $remoteUrl" -ForegroundColor Cyan
Write-Host ""

# Check authentication method
Write-Host "Checking authentication method..." -ForegroundColor Yellow

# Test 1: GitHub API access
$githubToken = $env:GITHUB_TOKEN
if ([string]::IsNullOrWhiteSpace($githubToken)) {
    # Try to get from .env.local
    if (Test-Path ".env.local") {
        $envContent = Get-Content ".env.local"
        foreach ($line in $envContent) {
            if ($line -match '^GITHUB_TOKEN=(.+)$' -and -not $line.StartsWith('#')) {
                $githubToken = $matches[1].Trim()
                break
            }
        }
    }
}

if (-not [string]::IsNullOrWhiteSpace($githubToken) -and $githubToken -notmatch 'your_.*_here') {
    Write-Host "  Testing GitHub API access..." -ForegroundColor Cyan
    try {
        $headers = @{
            "Authorization" = "token $githubToken"
            "Accept"        = "application/vnd.github.v3+json"
        }

        $response = Invoke-RestMethod -Uri "https://api.github.com/user" `
            -Headers $headers -Method Get -TimeoutSec 10

        Write-Host "  [OK] GitHub API access successful" -ForegroundColor Green
        Write-Host "    Authenticated as: $($response.login)" -ForegroundColor Cyan
        Write-Host "    User ID: $($response.id)" -ForegroundColor Cyan
    } catch {
        Write-Host "  [X] GitHub API access failed: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  [!] GITHUB_TOKEN not configured" -ForegroundColor Yellow
}

# Test 2: Repository access
Write-Host ""
Write-Host "Testing repository access..." -ForegroundColor Yellow
try {
    $repoInfo = git ls-remote --heads origin 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Repository access successful" -ForegroundColor Green
        $branches = ($repoInfo | Select-String 'refs/heads/').Count
        Write-Host "    Found $branches branch(es)" -ForegroundColor Cyan
    } else {
        Write-Host "  [X] Repository access failed" -ForegroundColor Red
        Write-Host "    Error: $repoInfo" -ForegroundColor Red
    }
} catch {
    Write-Host "  [X] Repository access test failed: $_" -ForegroundColor Red
}

# Test 3: Push capability (if requested)
if ($TestPush) {
    Write-Host ""
    Write-Host "Testing push capability..." -ForegroundColor Yellow
    Write-Host "  (Creating test commit)" -ForegroundColor Cyan

    # Create a test file
    $testFile = ".github-test-$(Get-Date -Format 'yyyyMMddHHmmss')"
    "test" | Out-File -FilePath $testFile

    try {
        git add $testFile
        git commit -m "test: GitHub auth verification" --no-verify 2>&1 | Out-Null

        $pushResult = git push origin HEAD 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] Push successful" -ForegroundColor Green

            # Cleanup
            git reset HEAD~1 --soft 2>&1 | Out-Null
            git restore --staged $testFile 2>&1 | Out-Null
            Remove-Item $testFile -Force
        } else {
            Write-Host "  [X] Push failed: $pushResult" -ForegroundColor Red
            git reset HEAD~1 --soft 2>&1 | Out-Null
            Remove-Item $testFile -Force
        }
    } catch {
        Write-Host "  [X] Push test failed: $_" -ForegroundColor Red
        if (Test-Path $testFile) {
            Remove-Item $testFile -Force
        }
    }
}

# Test 4: Pull capability (if requested)
if ($TestPull) {
    Write-Host ""
    Write-Host "Testing pull capability..." -ForegroundColor Yellow
    try {
        $pullResult = git pull origin main 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] Pull successful" -ForegroundColor Green
        } else {
            Write-Host "  [!] Pull result: $pullResult" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [X] Pull test failed: $_" -ForegroundColor Red
    }
}

# Test 5: GitHub Actions secrets (if requested and GitHub CLI available)
if ($CheckSecrets) {
    Write-Host ""
    Write-Host "Checking GitHub Actions secrets..." -ForegroundColor Yellow

    if (Get-Command gh -ErrorAction SilentlyContinue) {
        try {
            $secrets = gh secret list 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  [OK] GitHub CLI access successful" -ForegroundColor Green
                Write-Host "  Secrets configured:" -ForegroundColor Cyan
                $secrets | ForEach-Object { Write-Host "    $_" -ForegroundColor White }
            } else {
                Write-Host "  [!] Could not list secrets: $secrets" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "  [!] GitHub CLI error: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [!] GitHub CLI (gh) not installed" -ForegroundColor Yellow
        Write-Host "    Install: winget install GitHub.cli" -ForegroundColor Cyan
        Write-Host "    Or check manually: https://github.com/toodeceptive/against-the-odds/settings/secrets/actions" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "=== Verification Summary ===" -ForegroundColor Cyan
Write-Host "Run with -TestPush to test push capability" -ForegroundColor White
Write-Host "Run with -TestPull to test pull capability" -ForegroundColor White
Write-Host "Run with -CheckSecrets to check GitHub Actions secrets" -ForegroundColor White
Write-Host ""
