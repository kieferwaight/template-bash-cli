# North Star: Progressive Bash CLI Framework

## Purpose

Evolve `kieferwaight/template-bash-cli` from a repository template containing its own build machinery into an opinionated Bash CLI framework and tooling ecosystem.

This is an evolutionary program, not a rewrite. The present repository is the first implementation and its commit history is evidence. Preserve useful lineage while discovering which behavior belongs to the application, framework/runtime, development tooling, distribution adapters, or generated artifacts.

This document describes durable direction and decision gates. It does not freeze the final package layout, manifest schema, capability vocabulary, or implementation details before they are demonstrated by real use.

## North Star

An application should be able to declare its intent and dependencies, compose only the framework layers it needs, and produce one deterministic standalone Bash executable. The executable must run without Node, npm, `node_modules`, argc, or bash-cli at runtime unless the application itself explicitly declares one of those as a runtime dependency.

The desired user experience is progressively disclosed:

```text
minimal application
  -> command modules when needed
  -> application libraries when needed
  -> tests and customization when needed
  -> distribution overrides when defaults are insufficient
```

Framework sophistication belongs behind tooling; ordinary application repositories should contain primarily application code, tests, documentation, and explicit project choices.

## Non-Negotiable Invariants

- Preserve the four grammars: argc annotations for CLI interfaces, Bash modules for APIs, `#%` directives for structural assembly, and `dist/` for release artifacts.
- Keep parser state at the boundary: `argc_*` state flows through a command adapter into ordinary Bash values; libraries must not read parser state directly.
- Keep requested data on stdout and diagnostics, logging, progress, and errors on stderr.
- Build one canonical executable, `dist/bin/<application>`. Distribution adapters transport that artifact rather than independently compiling the application.
- Make framework/build dependencies framework-owned. Make application runtime dependencies visible project data.
- Never silently install host packages, overwrite application-owned code, or hide consequential runtime/security/distribution requirements.
- Make generated outputs reproducible and normally untracked: build state, binaries, completions, manpages, package staging, archives, and checksums.
- Prefer explicit managed/default/overridden/ejected ownership states over ambiguous partial ownership.

## Architectural Boundaries

| Layer | Owns | Must not own |
| --- | --- | --- |
| Application | Domain behavior, commands, runtime dependencies caused by that behavior, app tests and documentation | Generic build/runtime machinery |
| Framework/runtime | Reusable Bash modules, lifecycle primitives, platform abstractions, output/error contracts | Parser state or application policy |
| Tooling | Assembly, validation, toolchain resolution, scaffolding, capability resolution, generic CI/package generation | Application business logic |
| Distribution adapter | Transport of the canonical artifact and translation of declared runtime dependencies | A second application build path |
| Generated artifact | Disposable derived output | Source-of-truth configuration or hand-authored behavior |

Use this ownership test: if an application would still need a dependency without bash-cli, it is normally application-owned. If it exists only because the project uses bash-cli, framework/tooling owns it.

## Stable Contract Candidates

These are candidates for versioned compatibility guarantees; internal implementation remains free to evolve behind them.

- Project manifest and manifest migration behavior.
- Module metadata and semantic framework import syntax.
- Public Bash API namespace: `app::module::function`.
- Private implementation namespace: `app::module::_function`.
- CLI, stdout/stderr, exit-status, and artifact contracts.
- Distribution-adapter inputs and declared application runtime dependencies.

No stable contract is final merely because it appears in source today. Each becomes stable only after dogfooding and a recorded decision.

## Current Baseline and Known Migration Debt

The current template already proves modular source, explicit assembly, argc compilation, generated completion/manpage outputs, and standalone execution. It is the compatibility baseline.

Before it can become a reusable framework, resolve these explicitly:

- Replace the current post-build Perl rewrite of argc-generated internals with a supported parser/error-dispatch mechanism.
- Consolidate lifecycle initialization so command adapters do not manually repeat color, logging, format, dry-run, confirmation, cleanup, and signal setup.
- Remove standalone-runtime assumptions derived from a source or repository root; distinguish executable, config, cache, state, runtime, and data directories.
- Migrate transitional `_app::…` private symbols to `app::module::_function` without exposing either form as a downstream stable API.
- Do not claim a general JSON serializer until safe structured encoding is implemented or its supported data model is deliberately constrained.
- Treat current Homebrew, Debian, npm, and installer material as adapter prototypes until clean consumer installation paths have been executed and verified.

## Repository and Lineage Strategy

Keep this repository as the lineage root. Begin experimentation on a long-lived `next` branch once implementation work starts; keep `main` usable as the current template baseline.

Do not split the repository yet. Extraction is justified only when dogfooding demonstrates that a component has an independently versioned consumer contract, can be tested separately, and no longer benefits from co-evolving in the same history.

If extraction becomes warranted, preserve ancestry with `git mv`, subtree, or history-filtering techniques. Do not recreate equivalent files as unrelated greenfield code.

## Evidence-Led Sequence

1. **Baseline** — audit current source, artifacts, tests, workflows, packaging, and documented contracts; preserve a passing baseline.
2. **Dogfood** — turn the existing application into the working `bash-cli` tool only where real framework needs emerge.
3. **Extract** — shape reusable runtime/tooling components behind tested semantic contracts while preserving application behavior.
4. **Manifest and composition** — prove one authoritative metadata model, semantic module resolution, deterministic assembly, and standalone output.
5. **Progressive scaffolding** — implement minimal `init`; add commands, application dependencies, capabilities, and overrides only when the project earns them.
6. **Inspectable ownership** — add dependency/capability explanation and `doctor` behavior after an actual resolver exists.
7. **Distribution** — exercise canonical-artifact installation via curl, npm/npx, Homebrew, APK, and Debian where feasible; generated package files alone are not acceptance evidence.
8. **Reduction** — compare the original template with a minimal generated application and remove every application file that exists only because framework machinery leaked through.

Each phase needs a real user/application pressure, contract tests, and a decision-log entry before the next permanent abstraction is adopted.

## Manifest, Dependencies, and Capabilities

`package.json` is the preferred first manifest experiment because it supplies established metadata, semver, lockfiles, dependency resolution, and npm transport. It is not automatically the answer to every configuration problem.

Use ordinary npm fields for established package metadata. Put framework-specific state under a `bashCli` namespace only when it cannot be represented by an existing field. Name and version must have one authority and derived representations elsewhere.

Framework packages are build-time source material. Semantic imports such as `#%include @framework/runtime` are preferable to exposing `node_modules` paths, but their notation and resolver behavior must be proven before stabilization.

Capabilities should be declarative metadata with dependency edges, not template-copy commands. Enabling a capability should add the minimum project-visible state and explain the effective state. An override/eject action is explicit; tooling must never silently overwrite it.

## Toolchain and Distribution Policy

npm is a development, dependency, and distribution transport—not a runtime requirement for compiled applications. It may carry Bash source, binaries, or tooling without making the application a Node implementation.

Toolchain concealment has a boundary: framework-owned tools should be internally implemented, resolved through a versioned dependency graph, provisioned/cached by tooling, or run in an isolated environment before a host dependency is imposed. Host changes require explicit user action. `doctor` must report unmet requirements with precise remediation.

The canonical executable is the release authority. Package managers may wrap or relocate it, but must not introduce a separate compilation path without a recorded reason. Reproducibility is measured independently for assembly, executable, generated docs/completions, archives, and package contents where ecosystem metadata permits it.

## Decision Discipline

Record every consequential decision under [`docs/decisions/`](decisions/README.md): the pressure observed, options, ownership layer, compatibility impact, reversibility, and evidence. Especially record choices about manifests, modules, packaging, runtime boundaries, ejection, generated state, and argc integration.

Avoid abstraction for symmetry. Add a module, file, directory, capability, or package only when a real application/framework pressure demonstrates that it reduces irrelevant cognitive surface area.

## Definition of Success

Eventually a developer can create and evolve a CLI with a small, intelligible repository:

```text
package.json
package-lock.json
application source
application tests
application documentation
```

They can add application behavior, declared runtime dependencies, and distribution targets incrementally, inspect the effective toolchain and capabilities, and build `dist/bin/my-cli` as the exact standalone Bash program required by that application.

Success is not the amount of framework code produced. It is the amount of framework machinery absent from an ordinary application without sacrificing deterministic composition, transparent dependencies, reproducibility, or operational safety.
