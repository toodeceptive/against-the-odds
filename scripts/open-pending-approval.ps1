# Open docs/status/pending-approval.md in Cursor (reuse window) so the user sees the preview automatically.
# Run from repo root. The agent should run this immediately after writing to pending-approval.md.

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    (Get-Location).Path
}
$file = Join-Path $repoPath "docs/status/pending-approval.md"

if (-not (Test-Path $file)) {
    Write-Host "Pending approval file not found: $file" -ForegroundColor Yellow
    exit 0
}

if (Get-Command cursor -ErrorAction SilentlyContinue) {
    cursor -r $file
} elseif (Get-Command code -ErrorAction SilentlyContinue) {
    code -r $file
} else {
    Invoke-Item $file
}
