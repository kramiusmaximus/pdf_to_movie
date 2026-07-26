# Symphony orchestration

Symphony is installed as a project-local, ignored tool under `.tools/symphony/`.

The launcher includes Symphony's required preview acknowledgement flag. This confirms only that the operator understands Symphony runs unattended without the usual interactive guardrails; it does not make the preview safe for untrusted repositories, issues, credentials, or networks.

Installed upstream revision:

`f8e8b8a670c799f6e0ade7a8c25c4bf4a4a56ec7`

## Local runtime

- WSL 2: Ubuntu 26.04
- mise: installed in the WSL user account
- Erlang/OTP: 28.5
- Elixir: 1.19.5 compiled for OTP 28
- Codex CLI: installed in the WSL user account from the Codex Desktop Linux bundle
- Symphony: Elixir reference implementation built from source

OTP was built headlessly with SSL support. GUI/wx, Java interop, and ODBC were intentionally omitted because Symphony does not require them.

The current upstream dependency lock reports multiple security advisories in HTTP client/server packages. Keep the dashboard bound to localhost, use only trusted issue content and repositories, and treat this installation as evaluation tooling rather than a hardened production service. Recheck upstream and dependency advisories before exposing it to any network.

## Before the first orchestration run

The repository currently has no commit and no Git remote. Complete these prerequisites:

1. Create the initial commit and publish the repository to GitHub.
2. Keep the non-secret repository and runtime values current in the ignored project-root `.env`.
3. Set `LINEAR_API_KEY` and `GITHUB_TOKEN` (or `GITHUB_API_KEY`) in the launching PowerShell session or the ignored project-root `.env`.
4. Bootstrap the initial commit and push with `scripts/bootstrap-github.ps1`.
5. Add the `symphony` label to only the issues Symphony may dispatch.

Keep all credentials in environment variables or the ignored project-root `.env`; never commit the file or write literal tokens into tracked files. Use a fine-grained, repository-scoped GitHub token with Contents and Pull requests read/write access.

The launcher reads `.env` before validating the configuration. Values already present in the PowerShell process take precedence. `GITHUB_API_KEY` is accepted as an alias for the conventional `GITHUB_TOKEN` name.

The configured tracker is the Linear project `PDT to Movie` (`pdt-to-movie-d3a84b3706a5`). It uses the project's existing `Todo`, `In Progress`, and terminal statuses; no Linear workflow statuses need to be added or renamed.

## Start

From PowerShell at the project root:

```powershell
$linearToken = Read-Host "Linear API key" -AsSecureString
$env:LINEAR_API_KEY = [System.Net.NetworkCredential]::new("", $linearToken).Password
Remove-Variable linearToken
$githubToken = Read-Host "GitHub token" -AsSecureString
$env:GITHUB_TOKEN = [System.Net.NetworkCredential]::new("", $githubToken).Password
Remove-Variable githubToken
powershell -ExecutionPolicy Bypass -File scripts/start-symphony.ps1
```

The dashboard and state API are available at `http://localhost:4000`.

Stop the foreground process with `Ctrl+C`.

## Safety posture

- Initial concurrency is limited to one agent.
- Dispatch requires the `symphony` issue label.
- A completed run moves its Linear issue to `Done`. An externally blocked run removes the `symphony` label so the issue is not immediately dispatched again; reapply it deliberately for rework.
- Each issue receives an isolated clone under the WSL user workspace root.
- Codex is restricted to workspace-write access with network access enabled for project dependencies and tracker operations.
- The Git credential helper stores only an environment-variable reference in each isolated clone; the token value is not written to Git configuration.
- Symphony is preview software intended for trusted environments; inspect its dashboard, issue activity, branches, and pull requests during early use.
- Never dispatch issues containing untrusted prompt content or run this configuration against an untrusted repository.

## Updating Symphony

Do not edit `.tools/symphony` as project code. To update, fetch the upstream repository deliberately, rebuild, verify the executable and workflow compatibility, then update the recorded revision above.
