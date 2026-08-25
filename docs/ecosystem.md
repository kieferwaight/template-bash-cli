# Ecosystem Coordination

## Public Repositories

| Repository | Role | Public boundary |
| --- | --- | --- |
| [template-bash-cli](https://github.com/kieferwaight/template-bash-cli) | Bash project contract and reference implementation | Deterministic standalone Bash artifact |
| [devkit](https://github.com/kieferwaight/devkit) | Prospective template-neutral lifecycle orchestrator | Template selection, lifecycle dispatch, release/publish adapters |
| [homebrew-tap](https://github.com/kieferwaight/homebrew-tap) | Homebrew formula metadata | Formulae for verified public artifacts only |

The relationship is deliberately directional:

```text
template contract / project metadata
             |
             v
        devkit lifecycle
             |
             v
canonical standalone artifact
             |
             +--> GitHub release / installer / npm
             +--> homebrew-tap formula
```

The artifact must not require devkit, npm, Node, `node_modules`, argc, or framework tooling at runtime unless the application independently declares that dependency.

## Command Boundary

`bash-cli` is a working name for the future Bash-template-specific compiler and conformance surface. Its prospective responsibility is Bash-specific work such as module resolution, build, validation, test, doctor, and capability management.

`devkit` is the prospective cross-template lifecycle tool. Its primary public creation surface is `devkit init <template> <project>`. It may offer lifecycle conveniences such as `devkit build` or `devkit publish`, but those commands must dispatch to a template-defined contract or provider adapter rather than duplicate an application's build implementation.

Until the contract is proven, neither command surface is a stable public API. In particular, defer a public `bash-cli init`, `bash-cli release`, or `bash-cli publish` command: those overlap with the template-neutral role proposed for devkit.

## Public Supply-Chain Rule

GitHub is the current public source, release, and distribution boundary. Private Gitea may remain a development or legacy provider only when it is explicit and never required by public consumers.

Public distribution follows this order:

1. Publish an immutable public tag or release artifact.
2. Retrieve it anonymously and verify its checksum and executable/build behavior.
3. Publish transport metadata such as a Homebrew formula.
4. Exercise installation from a clean consumer context.

No formula, installer, npm package, or release document may substitute an unverified source URL merely to make the repository look complete.

## Coordination Baseline — 2026-08-25

- `template-bash-cli` has a tested canonical-artifact model but no public release tag yet; its current packaging files remain prototypes.
- `devkit` has a local `v0.1.0` tag that is not yet public on GitHub and no GitHub release. Its current scripts are Gitea/`tea`- and Swift-convention-coupled.
- `homebrew-tap` formulas for `devkit` and `keyagent` currently reference unavailable Gitea archives. `keyagent` has no verified public source artifact in this ecosystem.

The immediate order is therefore: establish the public devkit artifact, repair and test only the devkit formula, then make a separate explicit decision about keyagent's public distribution.

## Handoff Plans

- [Template coordination plan](superpowers/plans/2026-08-25-ecosystem-coordination.md)
- [Devkit coordination plan](https://github.com/kieferwaight/devkit/blob/main/docs/superpowers/plans/2026-08-25-public-distribution-and-bash-cli-coordination.md)
- [Homebrew tap recovery plan](https://github.com/kieferwaight/homebrew-tap/blob/main/docs/superpowers/plans/2026-08-25-public-tap-recovery.md)

These plans are intentionally independent. They share the artifact and public-source contracts above, not source-tree implementation details.
