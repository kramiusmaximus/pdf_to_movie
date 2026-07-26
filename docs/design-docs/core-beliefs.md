# Core beliefs

## Product

- Completeness and fidelity outrank brevity.
- Engaging delivery is compatible with accuracy when transformations remain traceable.
- Visuals support comprehension and attention; they do not excuse missing narration.
- Long-running generation needs progress, recovery, review, and correction as first-class product features.

## Agent-first engineering

- Humans steer outcomes and constraints; agents execute and provide evidence.
- Repository-local, versioned knowledge is the system of record.
- `AGENTS.md` is a map, not an encyclopedia.
- Agents need direct access to the same application state, logs, metrics, screenshots, and artifacts used to judge correctness.
- Architecture should enforce important boundaries mechanically while allowing local implementation freedom.
- A task is complete only when its downstream behavior is proven.
- Failures reveal missing tools, contracts, documentation, or feedback loops; improve the harness instead of merely retrying.
- Small continuous cleanup prevents agent-replicated inconsistencies from compounding.

## Engineering

- Prefer explicit, stable, inspectable intermediate representations.
- Validate data at external boundaries.
- Favor reproducible tools and boring, well-understood abstractions.
- Capture recurring review feedback as documentation, tests, lint rules, or automation.
- Keep changes narrow, reviewable, and independently verifiable.
