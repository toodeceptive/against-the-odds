# Script to create GitHub repository via API
# This will create the private repository "against-the-odds" on GitHub

param(
    [string]$Token = $null
)

$repoName = "against-the-odds"
$owner = "toodeceptive"
$isPrivate = $true

# GitHub API endpoint
$apiUrl = "https://api.github.com/user/repos"

# If no token provided, try to get from credential manager or prompt
if (-not $Token) {
    Write-Host "GitHub Personal Access Token required to create repository."
    Write-Host ""
    Write-Host "To create a token:"
    Write-Host "1. Go to: https://github.com/settings/tokens"
    Write-Host "2. Click 'Generate new token' -> 'Generate new token (classic)'"
    Write-Host "3. Name it (e.g., 'Repository Creation')"
    Write-Host "4. Select scope: 'repo' (full control of private repositories)"
    Write-Host "5. Click 'Generate token'"
    Write-Host "6. Copy the token and run this script with: .\create-repo.ps1 -Token 'your-token-here'"
    Write-Host ""

    $Token = Read-Host "Enter your GitHub Personal Access Token (or press Enter to exit)" -AsSecureString
    if ($Token.Length -eq 0) {
        Write-Host "Exiting. Repository not created."
        exit 1
    }
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Token)
    $Token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}

# Prepare the request body
$body = @{
    name        = $repoName
    description = "Against The Odds - Private Repository"
    private     = $isPrivate
    auto_init   = $false  # Don't initialize with README since we have local content
} | ConvertTo-Json

# Headers
$headers = @{
    "Authorization" = "token $Token"
    "Accept"        = "application/vnd.github.v3+json"
    "User-Agent"    = "PowerShell"
}

try {
    Write-Host "Creating repository '$repoName' on GitHub..."
    Write-Host "Owner: $owner"
    Write-Host "Private: $isPrivate"
    Write-Host ""

    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $body -ContentType "application/json"

    Write-Host "✅ Repository created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repository URL: $($response.html_url)"
    Write-Host "Clone URL (HTTPS): $($response.clone_url)"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "1. Push your local code (from repo root):"
    Write-Host "   cd <your-repo-root>"
    Write-Host "   git push -u origin main"
    Write-Host ""
    Write-Host "2. Or if you need to set the remote:"
    Write-Host "   git remote set-url origin $($response.clone_url)"
    Write-Host "   git push -u origin main"

    return $response
} catch {
    Write-Host "❌ Error creating repository:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response: $responseBody" -ForegroundColor Red
    }

    exit 1
}
