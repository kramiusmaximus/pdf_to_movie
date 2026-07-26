$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$runtimePath = Join-Path $projectRoot ".tools\symphony\elixir\bin\symphony"
$workflowPath = Join-Path $projectRoot "orchestration\WORKFLOW.md"
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
            throw "Invalid .env entry: $rawLine"
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

if (-not (Test-Path -LiteralPath $runtimePath)) {
    throw "Symphony is not installed at $runtimePath"
}

if (-not (Test-Path -LiteralPath $workflowPath)) {
    throw "Symphony workflow is missing at $workflowPath"
}

if (-not $env:SOURCE_REPO_URL) {
    throw "Set SOURCE_REPO_URL in .env or in the PowerShell session."
}

if (-not $env:SYMPHONY_WORKSPACE_ROOT) {
    throw "Set SYMPHONY_WORKSPACE_ROOT in .env or in the PowerShell session."
}

if (-not $env:LINEAR_API_KEY) {
    throw "Set LINEAR_API_KEY before starting Symphony."
}

if (-not $env:GITHUB_TOKEN) {
    throw "Set GITHUB_TOKEN or GITHUB_API_KEY before starting Symphony."
}

$port = 0
if (
    -not [int]::TryParse($env:SYMPHONY_PORT, [ref]$port) -or
    $port -lt 1 -or
    $port -gt 65535
) {
    throw "SYMPHONY_PORT must be an integer between 1 and 65535."
}

Write-Host "Starting Symphony at http://localhost:$port"

$previousWslEnv = $env:WSLENV
$sharedNames = @(
    "SOURCE_REPO_URL",
    "LINEAR_API_KEY",
    "GITHUB_TOKEN",
    "SYMPHONY_WORKSPACE_ROOT"
)
$wslEnvEntries = @($env:WSLENV -split ":" | Where-Object { $_ })

foreach ($name in $sharedNames) {
    if ($wslEnvEntries -notcontains $name) {
        $wslEnvEntries += $name
    }
}

$env:WSLENV = $wslEnvEntries -join ":"

try {
    & wsl.exe --cd $projectRoot --exec bash -lc "cd .tools/symphony/elixir && /home/f5/.local/bin/mise exec -- ./bin/symphony --i-understand-that-this-will-be-running-without-the-usual-guardrails --logs-root ../../../.symphony/logs --port $port ../../../orchestration/WORKFLOW.md"
}
finally {
    $env:WSLENV = $previousWslEnv
}

if ($LASTEXITCODE -ne 0) {
    throw "Symphony exited with code $LASTEXITCODE"
}
