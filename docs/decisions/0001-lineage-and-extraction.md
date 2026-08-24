# 0001: Preserve Lineage Before Repository Extraction

- **Status:** Accepted
- **Date:** 2026-08-24

## Problem and Observed Pressure

`template-bash-cli` is both the first application implementation and the seed of a prospective framework/tooling ecosystem. Splitting packages immediately would duplicate or discard useful history before the boundaries have been demonstrated by a real consumer.

## Options Considered

1. Split framework, runtime, and tooling into new repositories immediately.
2. Start an unrelated greenfield tooling repository and leave this repository as a static template.
3. Preserve this repository as the lineage root, dogfood the framework here, and extract only after an independently versioned boundary is proven.

## Decision and Ownership Layer

Choose option 3. Keep `main` as the usable template baseline and perform substantial evolution on a long-lived `next` branch. The repository remains the shared application/framework/tooling experiment until a component has a demonstrable independent consumer contract.

This is a tooling and repository-governance decision; it does not make the current copied implementation a permanent downstream contract.

## Compatibility and Reversibility

The decision preserves all current history and makes later extraction reversible in practice. When extraction is justified, use history-preserving mechanisms such as `git mv`, subtree, or filtering rather than copying equivalent files into unrelated repositories.

No downstream application contract is created by this decision. Existing template behavior remains the baseline until a later compatibility decision replaces it.

## Evidence and Revisit Trigger

Revisit repository extraction when all of the following are true:

- The dogfooded `bash-cli` consumes a component through a tested semantic contract rather than direct repository coupling.
- At least one additional sample application can consume that component independently.
- The component needs its own semver/release cadence or package distribution.
- Tests can run against the component independently and verify the standalone artifact contract.

Until then, co-evolution in one repository provides more evidence and preserves more useful history than a premature split.
