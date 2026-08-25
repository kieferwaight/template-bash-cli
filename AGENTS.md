# Agent Guide

## Read First

Before changing architecture, packaging, lifecycle commands, or project layout, read:

1. [North Star](docs/north-star.md)
2. [Ecosystem map](docs/ecosystem.md)
3. [Architectural decisions](docs/decisions/README.md)
4. The relevant implementation plan under `docs/superpowers/plans/`

The repository is an evolutionary reference implementation, not a greenfield scaffold. Preserve lineage and keep `main` usable. Substantial framework experiments belong on the long-lived `next` branch after it is created; do not split repositories or copy equivalent code into a new project without a recorded decision.

## Repository Contract

- Preserve the parser boundary: command adapters may translate `argc_*` state; libraries consume ordinary Bash values only.
- Preserve the four grammars: argc annotations, Bash module APIs, `#%` assembly directives, and `dist/` release artifacts.
- Keep requested data on stdout and diagnostics on stderr.
- Treat `dist/bin/<application>` as the canonical artifact. Packaging must transport it rather than compile a second variant.
- Do not make Node, npm, `node_modules`, argc, or bash-cli runtime requirements of a compiled application unless the application explicitly declares them.

## Cross-Repository Boundary

- `template-bash-cli` owns the Bash project contract and reference implementation.
- `devkit` is the prospective template-neutral lifecycle orchestrator; it may dispatch a template-defined build/test/validation hook, but must not duplicate Bash compilation.
- `homebrew-tap` owns only public, verified Homebrew formula metadata.
- Public consumers must not depend on private Gitea. GitHub is the current public source and distribution boundary.

Do not repair a formula with an unverified URL or checksum. Do not publish, tag, release, modify a tap, or change another repository unless the current task explicitly authorizes that external side effect.

## Current Focus

The cross-repository coordination plan is [here](docs/superpowers/plans/2026-08-25-ecosystem-coordination.md). It records the required order: public immutable artifact first, verified distribution metadata second, and lifecycle abstraction only after those consumer paths work.

## Verification

For changes in this repository, run the narrowest relevant check and then the project baseline when the change affects source or generated contracts:

```bash
argc lint
argc test
argc build
git diff --check
```

For documentation-only changes, validate links and whitespace with `rg`/`git diff --check`; do not claim a distribution channel works unless its real consumer installation path has been exercised.
