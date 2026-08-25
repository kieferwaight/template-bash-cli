# 0002: Separate Template Conformance, Lifecycle Orchestration, and Public Distribution

- **Status:** Accepted
- **Date:** 2026-08-25

## Problem and Observed Pressure

The existing Bash template has build, validation, packaging, and release prototypes. The recovered devkit project already has project creation and release/tap orchestration, but it is tightly coupled to Swift and Gitea. The public Homebrew tap contains formulae that transport unavailable private infrastructure.

Without a boundary, a future `bash-cli` and devkit would both own `init`, build, release, and publish behavior. That would duplicate lifecycle logic, make templates dictate provider policy, and obscure which component owns public supply-chain guarantees.

## Options Considered

1. Keep all project lifecycle and distribution behavior inside every template.
2. Move all compilation and project semantics into devkit.
3. Keep template-specific conformance/compilation in the template toolchain, place template-neutral lifecycle orchestration in devkit, and keep Homebrew metadata in the tap.

## Decision and Ownership Layer

Choose option 3.

- `template-bash-cli` owns the Bash project contract, deterministic composition, and canonical standalone artifact.
- A future `bash-cli` tool owns Bash-specific project conformance and compilation. It is a working name, not a stable public CLI yet.
- `devkit` owns template selection, cross-template lifecycle dispatch, and provider/release orchestration. It invokes a declared template contract rather than rebuilding a Bash project itself.
- `homebrew-tap` owns only Formula metadata for publicly retrievable, verified artifacts.

GitHub is the public source and distribution boundary. Private Gitea is an explicit optional development/legacy provider and must not be required for public installation.

## Compatibility and Reversibility

This decision changes no runtime dependency and requires no repository split. Existing template `argc` tasks and devkit Swift commands remain working baselines during the transition.

Future commands may be renamed or consolidated only after a tested template lifecycle contract exists. A public `bash-cli init`, `bash-cli release`, or `bash-cli publish` is deferred to avoid overlap with devkit.

The decision is reversible: if dogfooding shows that devkit cannot remain template-neutral or that the Bash toolchain needs an independent lifecycle API, record a superseding decision with consumer evidence.

## Evidence and Revisit Trigger

Revisit the command and package boundary after all of the following succeed:

- devkit consumes a documented Bash build/test/artifact contract without direct source-tree coupling.
- A Swift project and a Bash project complete equivalent lifecycle stages through devkit.
- The canonical artifact is transported through at least one real public channel without a second build path.
- The ownership and failure modes of version, release metadata, and provider credentials are inspectable.

Until then, public source verification is a prerequisite for tap changes: immutable artifact first, formula checksum second, consumer install third.
