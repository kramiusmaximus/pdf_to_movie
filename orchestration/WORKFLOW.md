---
tracker:
  kind: linear
  provider:
    project_slug: "pdt-to-movie-d3a84b3706a5"
    api_key: $LINEAR_API_KEY
  required_labels:
    - symphony
  active_states:
    - Todo
    - In Progress
  terminal_states:
    - Closed
    - Cancelled
    - Canceled
    - Duplicate
    - Done
polling:
  interval_ms: 5000
workspace:
  root: $SYMPHONY_WORKSPACE_ROOT
hooks:
  after_create: |
    git -c credential.helper= -c credential.helper='!f() { printf "%s\n" "username=x-access-token" "password=$GITHUB_TOKEN"; }; f' clone "$SOURCE_REPO_URL" .
    git config credential.helper '!f() { printf "%s\n" "username=x-access-token" "password=$GITHUB_TOKEN"; }; f'
agent:
  max_concurrent_agents: 1
  max_turns: 20
codex:
  command: /home/f5/.local/bin/codex --config shell_environment_policy.inherit=all --config 'model="gpt-5.6-sol"' --config 'model_reasoning_effort="high"' app-server
  approval_policy: never
  thread_sandbox: workspace-write
  turn_sandbox_policy:
    type: workspaceWrite
    networkAccess: true
---

You are working autonomously on Linear issue `{{ issue.identifier }}`.

Issue context:

- Title: {{ issue.title }}
- State: {{ issue.state }}
- Labels: {{ issue.labels }}
- URL: {{ issue.url }}

Description:

{% if issue.description %}
{{ issue.description }}
{% else %}
No description was provided.
{% endif %}

Work only inside the isolated repository clone supplied for this issue.

## Operating contract

1. Read `AGENTS.md` and follow its repository map before changing files.
2. Inspect the current repository state and reproduce or establish the requested behavior.
3. Define explicit acceptance criteria and verification evidence.
4. For complex work, create or update a checked-in execution plan under `docs/exec-plans/active/`.
5. Implement the smallest coherent change that satisfies the issue.
6. Run the relevant tests, checks, and downstream validation.
7. Review the complete diff for correctness, security, maintainability, documentation drift, and accidental files.
8. Commit the work on a `codex/` branch and push it.
9. Use the provided `linear_graphql` tool to maintain one concise `## Codex Workpad` comment containing the plan, progress, and verification evidence.
10. Move a `Todo` issue to `In Progress` before implementation and move it to `Done` only after its acceptance criteria and verification are complete.
11. If blocked by missing external authority, credentials, or a required decision, report the exact blocker in the workpad and remove the `symphony` label so the issue is not immediately dispatched again. Do not invent access or broaden scope.

Do not commit credentials, local runtime files, generated output, or temporary diagnostics.

The final response must contain completed work, verification evidence, and true blockers only.
