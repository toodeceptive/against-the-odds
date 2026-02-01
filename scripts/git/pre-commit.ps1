# Pre-commit validation hook
# Runs Prettier (format) automatically, then validation checks before allowing commit.
# Repo root from git rev-parse first (reliable under Git CLI); fallback to script location then CWD.

$ErrorActionPreference = "Continue"

# Prefer repo root from Git (works when hook runs from any CWD or worktree)
$repoPath = $null
try {
    $repoPath = (git rev-parse --show-toplevel 2>$null)
} catch {}
if (-not $repoPath -or -not (Test-Path $repoPath)) {
    try {
        if ($PSScriptRoot) {
            $parent = Join-Path $PSScriptRoot ".."
            $grandParent = Join-Path $parent ".."
            $resolved = Resolve-Path -LiteralPath $grandParent -ErrorAction Stop
            $repoPath = $resolved.Path
        } else {
            $repoPath = (Get-Location).Path
        }
    } catch {
        $repoPath = (Get-Location).Path
    }
}

try {
    Set-Location $repoPath
} catch {
    Write-Host "[WARN] Could not change to repo path; continuing from current directory." -ForegroundColor Yellow
}

# Skip checks if not in a git repo
$gitRoot = $null
try {
    $gitRoot = git rev-parse --show-toplevel 2>$null
} catch {}
if (-not $gitRoot) {
    Write-Host "[OK] Not a git repo or git unavailable; skipping pre-commit checks." -ForegroundColor Green
    exit 0
}

Write-Host "Running pre-commit checks..." -ForegroundColor Cyan

$errors = @()
$warnings = @()

# 1. Run Prettier automatically so next commit has formatted code (non-blocking)
if (Get-Command npm -ErrorAction SilentlyContinue) {
    if (Test-Path "package.json") {
        try {
            $packageJson = Get-Content "package.json" -Raw -ErrorAction Stop | ConvertFrom-Json
            if ($packageJson.scripts.format) {
                Write-Host "Running Prettier (format)..." -ForegroundColor Yellow
                try {
                    npm run format 2>&1 | Out-Null
                    if ($LASTEXITCODE -eq 0) {
                        $formatted = git status --short 2>$null
                        if ($formatted) {
                            Write-Host "Prettier formatted files; re-staging for commit." -ForegroundColor Green
                            git add -u 2>&1 | Out-Null
                        }
                    }
                } catch {
                    # Format not critical; continue
                }
            }
        } catch {
            # package.json read/parse failed; skip format
        }
    }
}

# 2. Check for large files
$stagedFiles = @()
try {
    $stagedFiles = @(git diff --cached --name-only 2>$null)
} catch {}

$largeFiles = @()
foreach ($f in $stagedFiles) {
    if (-not $f) { continue }
    try {
        $item = Get-Item $f -ErrorAction SilentlyContinue
        if ($item -and $item.Length -gt 100MB) {
            $largeFiles += $f
        }
    } catch {}
}

if ($largeFiles.Count -gt 0) {
    $errors += "Large files detected (>100MB): $($largeFiles -join ', ')"
}

# 3. Check for merge conflict markers (skip binary/large files)
foreach ($file in $stagedFiles) {
    if (-not $file -or -not (Test-Path $file)) { continue }
    try {
        $item = Get-Item $file -ErrorAction SilentlyContinue
        if ($item -and $item.Length -gt 1MB) { continue }
        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if ($content -and $content -match '(?m)^(<{7}|={7}|>{7})') {
            $errors += "Merge conflict markers found in: $file"
        }
    } catch {}
}

# 4. Check for debug statements (JS/TS only; skip large files)
$jsFiles = $stagedFiles | Where-Object { $_ -match '\.(js|ts|jsx|tsx)$' }
foreach ($file in $jsFiles) {
    if (-not (Test-Path $file)) { continue }
    try {
        $item = Get-Item $file -ErrorAction SilentlyContinue
        if ($item -and $item.Length -gt 1MB) { continue }
        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if ($content -and $content -match 'console\.(log|debug|warn|error)') {
            $warnings += "Debug statements found in: $file"
        }
    } catch {}
}

# 5. Check commit message format (if commit message file exists)
$commitMsgFile = $env:GIT_PARAMS
if ($commitMsgFile -and (Test-Path $commitMsgFile)) {
    try {
        $commitMsg = Get-Content $commitMsgFile -Raw -ErrorAction SilentlyContinue
        if ($commitMsg) {
            if ($commitMsg.Length -lt 10) {
                $warnings += "Commit message is very short (minimum 10 characters recommended)"
            }
            if ($commitMsg -notmatch '^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?:') {
                $warnings += "Commit message doesn't follow conventional commit format"
            }
        }
    } catch {}
}

# 6. Run linter if available (non-blocking)
if (Get-Command npm -ErrorAction SilentlyContinue) {
    if (Test-Path "package.json") {
        try {
            $packageJson = Get-Content "package.json" -Raw -ErrorAction Stop | ConvertFrom-Json
            if ($packageJson.scripts.lint) {
                Write-Host "Running linter..." -ForegroundColor Yellow
                try {
                    npm run lint 2>&1 | Out-Null
                    if ($LASTEXITCODE -ne 0) {
                        $warnings += "Linter found issues (non-blocking)"
                    }
                } catch {}
            }
        } catch {}
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
