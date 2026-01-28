# Auto-commit script with safety checks
# Automatically commits changes with validation

param(
    [string]$Message = "",
    [switch]$DryRun = $false,
    [string[]]$IncludePatterns = @("*.ps1", "*.js", "*.ts", "*.html", "*.css", "*.md", "*.json", "*.yml", "*.yaml"),
    [string[]]$ExcludePatterns = @("*.log", "*.tmp", "node_modules/**", ".git/**")
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Auto-Commit Script ===" -ForegroundColor Cyan
Write-Host ""

# Check if there are any changes
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "No changes to commit." -ForegroundColor Yellow
    exit 0
}

# Show current status
Write-Host "Current status:" -ForegroundColor Yellow
git status --short
Write-Host ""

# Get changed files
$changedFiles = git diff --name-only --cached
$unstagedFiles = git diff --name-only

if ([string]::IsNullOrWhiteSpace($changedFiles) -and [string]::IsNullOrWhiteSpace($unstagedFiles)) {
    Write-Host "No changes detected." -ForegroundColor Yellow
    exit 0
}

# Stage files matching include patterns
$filesToStage = @()
foreach ($file in $unstagedFiles) {
    $shouldInclude = $false
    foreach ($pattern in $IncludePatterns) {
        if ($file -like $pattern) {
            $shouldInclude = $true
            break
        }
    }
    
    if ($shouldInclude) {
        $shouldExclude = $false
        foreach ($pattern in $ExcludePatterns) {
            if ($file -like $pattern) {
                $shouldExclude = $true
                break
            }
        }
        
        if (-not $shouldExclude) {
            $filesToStage += $file
        }
    }
}

if ($filesToStage.Count -eq 0) {
    Write-Host "No files match the include patterns." -ForegroundColor Yellow
    exit 0
}

# Generate commit message if not provided
if ([string]::IsNullOrWhiteSpace($Message)) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $fileCount = $filesToStage.Count
    $Message = "chore: auto-commit $fileCount file(s) at $timestamp"
}

# Dry run mode
if ($DryRun) {
    Write-Host "DRY RUN - Would stage and commit:" -ForegroundColor Yellow
    $filesToStage | ForEach-Object { Write-Host "  $_" }
    Write-Host ""
    Write-Host "Commit message: $Message" -ForegroundColor Yellow
    exit 0
}

# Stage files
Write-Host "Staging files..." -ForegroundColor Yellow
foreach ($file in $filesToStage) {
    git add $file
    Write-Host "  Staged: $file" -ForegroundColor Green
}

# Validate commit message
if ($Message.Length -lt 10) {
    Write-Host "Warning: Commit message is very short." -ForegroundColor Yellow
}

# Commit
Write-Host ""
Write-Host "Committing changes..." -ForegroundColor Yellow
try {
    git commit -m $Message
    Write-Host "✓ Successfully committed changes" -ForegroundColor Green
    Write-Host ""
    Write-Host "Commit details:" -ForegroundColor Cyan
    git log -1 --oneline
} catch {
    Write-Host "✗ Failed to commit: $_" -ForegroundColor Red
    exit 1
}
