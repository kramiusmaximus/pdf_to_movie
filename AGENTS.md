# PDF to Movie

## Project overview

This project is an app that converts text-based documents into dynamic, lecture-like movies.

The app transforms the complete source text into engaging spoken audio, supported by relevant and visually interesting imagery. Its purpose is to make books and other documents more enjoyable and accessible to consume without summarizing, omitting, or otherwise losing any of the original content.

## Start here

- Read `docs/product-specs/product-vision.md` for the product goal and boundaries.
- Read `ARCHITECTURE.md` for the current system map and pipeline.
- Read `docs/design-docs/core-beliefs.md` before making architectural or workflow decisions.
- Use `docs/exec-plans/` for work that spans multiple components or needs durable decision tracking.
- Read `orchestration/README.md` before changing or running Symphony.

## Working contract

- Treat the repository as the source of truth. Record durable decisions here rather than relying on chat history.
- Keep this file short and navigational. Put detailed knowledge in the linked documents.
- Preserve the complete meaning and information content of every source document.
- Make source-to-output transformations traceable so omissions and distortions can be detected.
- Reproduce or inspect the current behavior before changing it.
- Define how a change will be verified before implementing it.
- Keep orchestration runs isolated and make their proof of work directly inspectable.
- Prefer explicit boundaries, typed or validated data contracts, and deterministic intermediate artifacts.
- Update relevant documentation when behavior, architecture, commands, or product decisions change.
- Never commit credentials, API keys, access tokens, generated media, local Symphony workspaces, or local runtime installations.

## Planning

- Small, local changes may use an ephemeral plan.
- Complex or cross-cutting work must have a checked-in execution plan under `docs/exec-plans/active/`.
- Move completed execution plans to `docs/exec-plans/completed/`; retain decisions and verification evidence.

## Core goals

- Preserve the full meaning and content of the source document.
- Convert the text into natural, engaging speech.
- Support the narration with relevant visual material.
- Produce a coherent, dynamic movie or lecture-like experience.
- Make long-form written material easier and more enjoyable to ingest.

## Guiding principle

Entertainment and presentation may improve how the material is experienced, but must not compromise the completeness or accuracy of the source content.

## Current commands

- Start Symphony: `powershell -ExecutionPolicy Bypass -File scripts/start-symphony.ps1`
- Symphony dashboard: `http://localhost:4000`
- Product build and test commands: not established yet; add them here when the application stack is selected.
