# Pre-commit validation hook
# Runs validation checks before allowing commit

$ErrorActionPreference = "Continue"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "Running pre-commit checks..." -ForegroundColor Cyan

$errors = @()
$warnings = @()

# Check for large files
$largeFiles = git diff --cached --name-only | ForEach-Object {
    $size = (Get-Item $_ -ErrorAction SilentlyContinue).Length
    if ($size -gt 100MB) {
        $_
    }
}

if ($largeFiles) {
    $errors += "Large files detected (>100MB): $($largeFiles -join ', ')"
}

# Check for merge conflict markers
$stagedFiles = git diff --cached --name-only
foreach ($file in $stagedFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        # Detect real git conflict markers (multiline)
        if ($content -match '(?m)^(<{7}|={7}|>{7})') {
            $errors += "Merge conflict markers found in: $file"
        }
    }
}

# Check for debug statements (if JavaScript/TypeScript files)
$jsFiles = $stagedFiles | Where-Object { $_ -match '\.(js|ts|jsx|tsx)$' }
foreach ($file in $jsFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        if ($content -match 'console\.(log|debug|warn|error)') {
            $warnings += "Debug statements found in: $file"
        }
    }
}

# Check commit message format (if commit message file exists)
$commitMsgFile = $env:GIT_PARAMS
if ($commitMsgFile -and (Test-Path $commitMsgFile)) {
    $commitMsg = Get-Content $commitMsgFile -Raw
    if ($commitMsg.Length -lt 10) {
        $warnings += "Commit message is very short (minimum 10 characters recommended)"
    }
    if ($commitMsg -notmatch '^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?:') {
        $warnings += "Commit message doesn't follow conventional commit format"
    }
}

# Run linter if available
if (Get-Command npm -ErrorAction SilentlyContinue) {
    if (Test-Path "package.json") {
        $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
        if ($packageJson.scripts.lint) {
            Write-Host "Running linter..." -ForegroundColor Yellow
            try {
                npm run lint 2>&1 | Out-Null
                if ($LASTEXITCODE -ne 0) {
                    $warnings += "Linter found issues (non-blocking)"
                }
            } catch {
                # Linter not critical, continue
            }
        }
    }
}

# Report results
Write-Host ""

if ($errors.Count -gt 0) {
    Write-Host "[FAIL] Pre-commit checks failed:" -ForegroundColor Red
    foreach ($errItem in $errors) {
        Write-Host "  - $errItem" -ForegroundColor Red
    }
    exit 1
}

if ($warnings.Count -gt 0) {
    Write-Host "[WARN] Pre-commit warnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  - $warning" -ForegroundColor Yellow
    }
}

Write-Host "[OK] Pre-commit checks passed" -ForegroundColor Green
exit 0
