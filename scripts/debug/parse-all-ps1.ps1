# Parse All PowerShell Scripts
# Validates that all .ps1 files in the repository parse correctly

param(
    [string]$RepoPath = $null
)

# Set repository location
if ([string]::IsNullOrWhiteSpace($RepoPath)) {
    $RepoPath = Resolve-Path (Join-Path $PSScriptRoot "..\..") | Select-Object -ExpandProperty Path
}

if (-not (Test-Path $RepoPath)) {
    Write-Host "ERROR: Repository path not found: $RepoPath" -ForegroundColor Red
    exit 1
}

Set-Location $RepoPath

Write-Host "INFO: Parsing all PowerShell scripts in: $RepoPath" -ForegroundColor Cyan
Write-Host ""

$scriptFiles = Get-ChildItem -Path $RepoPath -Filter "*.ps1" -Recurse | Where-Object {
    $_.FullName -notmatch "\\node_modules\\" -and
    $_.FullName -notmatch "\\.git\\"
}

$totalScripts = $scriptFiles.Count
$parsedSuccessfully = 0
$parseErrors = @()

Write-Host "Found $totalScripts PowerShell scripts to validate" -ForegroundColor Cyan
Write-Host ""

foreach ($script in $scriptFiles) {
    $relativePath = $script.FullName.Replace($RepoPath, "").TrimStart("\")
    Write-Host "Checking: $relativePath" -NoNewline

    # Try to parse the script
    $errors = $null
    $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $script.FullName -Raw), [ref]$errors)

    if ($errors.Count -eq 0) {
        Write-Host " - OK" -ForegroundColor Green
        $parsedSuccessfully++
    }
    else {
        Write-Host " - FAILED" -ForegroundColor Red
        foreach ($err in $errors) {
            Write-Host "  ERROR: Line $($err.Token.StartLine): $($err.Message)" -ForegroundColor Red
            $parseErrors += [PSCustomObject]@{
                File    = $relativePath
                Line    = $err.Token.StartLine
                Message = $err.Message
            }
        }
    }
}

Write-Host ""
Write-Host "=" * 60
Write-Host "Parse Check Summary" -ForegroundColor Cyan
Write-Host "=" * 60
Write-Host "Total scripts: $totalScripts"
Write-Host "Parsed successfully: $parsedSuccessfully" -ForegroundColor Green
Write-Host "Parse errors: $($parseErrors.Count)" -ForegroundColor $(if ($parseErrors.Count -eq 0) { "Green" } else { "Red" })

if ($parseErrors.Count -gt 0) {
    Write-Host ""
    Write-Host "Files with parse errors:" -ForegroundColor Red
    foreach ($err in $parseErrors) {
        Write-Host "  - $($err.File): Line $($err.Line) - $($err.Message)" -ForegroundColor Red
    }
    exit 1
}
else {
    Write-Host ""
    Write-Host "SUCCESS: All PowerShell scripts parse correctly!" -ForegroundColor Green
    exit 0
}
