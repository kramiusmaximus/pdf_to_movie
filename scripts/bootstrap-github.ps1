$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$envPath = Join-Path $projectRoot ".env"

function Import-ProjectEnvironment {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    foreach ($rawLine in Get-Content -LiteralPath $Path) {
        $line = $rawLine.Trim()

        if (-not $line -or $line.StartsWith("#")) {
            continue
        }

        $parts = $line.Split("=", 2)
        if ($parts.Count -ne 2) {
            throw "Invalid .env entry."
        }

        $name = $parts[0].Trim()
        $value = $parts[1].Trim()

        if ($name -notmatch "^[A-Za-z_][A-Za-z0-9_]*$") {
            throw "Invalid .env variable name: $name"
        }

        if (
            $value.Length -ge 2 -and
            (
                ($value.StartsWith('"') -and $value.EndsWith('"')) -or
                ($value.StartsWith("'") -and $value.EndsWith("'"))
            )
        ) {
            $value = $value.Substring(1, $value.Length - 2)
        }

        if ($null -eq [Environment]::GetEnvironmentVariable($name, "Process")) {
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }
}

if (Test-Path -LiteralPath $envPath) {
    Import-ProjectEnvironment -Path $envPath
}

if (-not $env:GITHUB_TOKEN -and $env:GITHUB_API_KEY) {
    $env:GITHUB_TOKEN = $env:GITHUB_API_KEY
}

if (-not $env:SOURCE_REPO_URL) {
    throw "Set SOURCE_REPO_URL in .env or in the PowerShell session."
}

if (-not $env:GITHUB_TOKEN) {
    throw "Set GITHUB_TOKEN or GITHUB_API_KEY before bootstrapping GitHub."
}

Set-Location -LiteralPath $projectRoot

$remotes = @(git remote)
if ($remotes -contains "origin") {
    git remote set-url origin $env:SOURCE_REPO_URL
}
else {
    git remote add origin $env:SOURCE_REPO_URL
}

git branch -M main
git add --all

git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m "Initialize PDF to Movie project"
}

$credentialHelper = '!f() { printf "%s\n" "username=x-access-token" "password=$GITHUB_TOKEN"; }; f'
git config credential.helper $credentialHelper
git push --set-upstream origin main

Write-Host "Published the initial project state to origin/main."
