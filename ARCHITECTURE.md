# Architecture

Status: initial system map; implementation technology is not yet selected.

## Intended pipeline

1. Ingest a source document and retain an immutable copy plus metadata.
2. Extract and normalize text without silently discarding content.
3. Identify document structure and divide it into traceable narration units.
4. Produce an expressive narration plan while preserving source meaning.
5. Synthesize speech and retain timing information for every narration unit.
6. Plan or source visuals that support the narration without contradicting it.
7. Compose narration, visuals, typography, and transitions onto a timeline.
8. Render the movie and generate machine-readable provenance.
9. Run automated and human-facing quality checks before accepting the output.

## Architectural invariants

- Every output unit must map back to a source location.
- Content preservation must be measurable; no stage may silently omit source material.
- Intermediate artifacts must be inspectable and resumable.
- Expensive stages must be cacheable and idempotent where practical.
- External model and media boundaries must validate returned data rather than guess its shape.
- Pipeline stages should communicate through explicit versioned contracts.
- Logs, errors, progress, costs, and generated artifacts must be legible to agents.
- Rendering must not be the first point where narration/visual synchronization can be inspected.

## Initial component boundaries

- `ingestion`: source loading, format detection, extraction, and normalization.
- `document-model`: stable source structure and provenance identifiers.
- `narration`: segmentation, delivery planning, and speech synthesis.
- `visuals`: visual intent, asset acquisition/generation, and attribution.
- `timeline`: synchronization and edit-decision representation.
- `rendering`: preview and final media production.
- `quality`: completeness, accuracy, timing, media, and regression checks.
- `app`: user workflow, progress, review, correction, and export.

These are domain boundaries, not yet package names. Update this document when the implementation stack and concrete modules are selected.
