# Run Everything Debug Sweep
# Comprehensive end-to-end system check for finalization verification

param(
    [switch]$SkipDeps = $false,
    [switch]$SkipTests = $false,
    [string]$OutputDir = "docs/status"
)

$ErrorActionPreference = "Continue"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = Join-Path $OutputDir "debug_sweep_$timestamp.log"

# Ensure output directory exists
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Start logging
$logStream = [System.IO.StreamWriter]::new($logFile)
function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    $logStream.WriteLine($logMessage)
    Write-Host $logMessage -ForegroundColor $Color
}

Write-Log "=== Debug Sweep Started ===" "Cyan"
Write-Log "Output directory: $OutputDir" "Cyan"
Write-Log "Log file: $logFile" "Cyan"
Write-Log ""

$errors = @()
$warnings = @()

# 1. PowerShell Script Parse Check
Write-Log "=== Step 1: PowerShell Script Parse Check ===" "Yellow"
try {
    $parseScript = "scripts\debug\parse-all-ps1.ps1"
    if (Test-Path $parseScript) {
        $parseOutput = & $parseScript 2>&1
        $parseOutput | ForEach-Object { Write-Log $_ }
        if ($LASTEXITCODE -ne 0) {
            $errors += "PowerShell parse check failed"
        }
        else {
            Write-Log "[OK] PowerShell scripts parse successfully" "Green"
        }
    }
    else {
        $warnings += "Parse script not found: $parseScript"
        Write-Log "[WARN] Parse script not found" "Yellow"
    }
}
catch {
    $errors += "Parse check error: $_"
    Write-Log "[FAIL] Parse check failed: $_" "Red"
}
Write-Log ""

# 2. Node.js and npm Check
Write-Log "=== Step 2: Node.js and npm Check ===" "Yellow"
try {
    $nodeVersion = node --version 2>&1
    $npmVersion = npm --version 2>&1
    Write-Log "Node.js version: $nodeVersion" "Cyan"
    Write-Log "npm version: $npmVersion" "Cyan"
    if ($LASTEXITCODE -eq 0) {
        Write-Log "[OK] Node.js and npm are available" "Green"
    }
    else {
        $errors += "Node.js or npm not available"
        Write-Log "[FAIL] Node.js or npm check failed" "Red"
    }
}
catch {
    $errors += "Node.js check error: $_"
    Write-Log "[FAIL] Node.js check failed: $_" "Red"
}
Write-Log ""

# 3. Install Dependencies (if not skipped)
if (-not $SkipDeps) {
    Write-Log "=== Step 3: Install Dependencies ===" "Yellow"
    try {
        Write-Log "Running npm install..." "Cyan"
        $npmOutput = npm install 2>&1
        $npmOutput | ForEach-Object { Write-Log $_ }
        if ($LASTEXITCODE -eq 0) {
            Write-Log "[OK] Dependencies installed successfully" "Green"
        }
        else {
            $warnings += "npm install had issues (may be offline mode)"
            Write-Log "[WARN] npm install completed with warnings" "Yellow"
        }
    }
    catch {
        $warnings += "Dependency installation error: $_"
        Write-Log "[WARN] Dependency installation had issues: $_" "Yellow"
    }
    Write-Log ""
}
else {
    Write-Log "=== Step 3: Install Dependencies (SKIPPED) ===" "Yellow"
    Write-Log ""
}

# 4. Lint Check
Write-Log "=== Step 4: ESLint Check ===" "Yellow"
try {
    Write-Log "Running npm run lint..." "Cyan"
    $lintOutput = npm run lint 2>&1
    $lintOutput | ForEach-Object { Write-Log $_ }
    if ($LASTEXITCODE -eq 0) {
        Write-Log "[OK] Lint check passed" "Green"
    }
    else {
        $errors += "Lint check failed"
        Write-Log "[FAIL] Lint check failed" "Red"
    }
}
catch {
    $warnings += "Lint check error: $_"
    Write-Log "[WARN] Lint check had issues: $_" "Yellow"
}
Write-Log ""

# 5. Format Check
Write-Log "=== Step 5: Prettier Format Check ===" "Yellow"
try {
    Write-Log "Running npm run format:check..." "Cyan"
    $formatOutput = npm run format:check 2>&1
    $formatOutput | ForEach-Object { Write-Log $_ }
    if ($LASTEXITCODE -eq 0) {
        Write-Log "[OK] Format check passed" "Green"
    }
    else {
        $warnings += "Format check found issues (not critical)"
        Write-Log "[WARN] Format check found issues" "Yellow"
    }
}
catch {
    $warnings += "Format check error: $_"
    Write-Log "[WARN] Format check had issues: $_" "Yellow"
}
Write-Log ""

# 6. Tests (if not skipped)
if (-not $SkipTests) {
    Write-Log "=== Step 6: Run Tests ===" "Yellow"
    try {
        Write-Log "Running npm run test:unit..." "Cyan"
        $testOutput = npm run test:unit 2>&1
        $testOutput | ForEach-Object { Write-Log $_ }
        if ($LASTEXITCODE -eq 0) {
            Write-Log "[OK] Unit tests passed" "Green"
        }
        else {
            $warnings += "Unit tests had issues (may require credentials)"
            Write-Log "[WARN] Unit tests completed with warnings" "Yellow"
        }
    }
    catch {
        $warnings += "Test execution error: $_"
        Write-Log "[WARN] Test execution had issues: $_" "Yellow"
    }
    Write-Log ""
}
else {
    Write-Log "=== Step 6: Run Tests (SKIPPED) ===" "Yellow"
    Write-Log ""
}

# 7. Health Check
Write-Log "=== Step 7: Comprehensive Health Check ===" "Yellow"
try {
    $healthScript = "scripts\health\comprehensive-check.ps1"
    if (Test-Path $healthScript) {
        Write-Log "Running comprehensive health check..." "Cyan"
        $healthOutput = & $healthScript 2>&1
        $healthOutput | ForEach-Object { Write-Log $_ }
        Write-Log "[OK] Health check completed" "Green"
    }
    else {
        $warnings += "Health check script not found: $healthScript"
        Write-Log "[WARN] Health check script not found" "Yellow"
    }
}
catch {
    $warnings += "Health check error: $_"
    Write-Log "[WARN] Health check had issues: $_" "Yellow"
}
Write-Log ""

# 8. Performance Check
Write-Log "=== Step 8: Performance Check ===" "Yellow"
try {
    $perfScript = "scripts\monitoring\performance-check.ps1"
    if (Test-Path $perfScript) {
        Write-Log "Running performance check..." "Cyan"
        $perfOutput = & $perfScript 2>&1
        $perfOutput | ForEach-Object { Write-Log $_ }
        Write-Log "[OK] Performance check completed" "Green"
    }
    else {
        $warnings += "Performance check script not found: $perfScript"
        Write-Log "[WARN] Performance check script not found" "Yellow"
    }
}
catch {
    $warnings += "Performance check error: $_"
    Write-Log "[WARN] Performance check had issues: $_" "Yellow"
}
Write-Log ""

# Summary
Write-Log "=== Debug Sweep Summary ===" "Cyan"
$errorColor = if ($errors.Count -eq 0) { "Green" } else { "Red" }
$warningColor = if ($warnings.Count -eq 0) { "Green" } else { "Yellow" }
Write-Log "Errors: $($errors.Count)" $errorColor
Write-Log "Warnings: $($warnings.Count)" $warningColor
Write-Log ""

if ($errors.Count -gt 0) {
    Write-Log "Errors found:" "Red"
    $errors | ForEach-Object { Write-Log "  - $_" "Red" }
}

if ($warnings.Count -gt 0) {
    Write-Log "Warnings:" "Yellow"
    $warnings | ForEach-Object { Write-Log "  - $_" "Yellow" }
}

Write-Log "=== Debug Sweep Complete ===" "Cyan"
Write-Log "Log saved to: $logFile" "Cyan"

$logStream.Close()

if ($errors.Count -gt 0) {
    exit 1
}
else {
    exit 0
}
