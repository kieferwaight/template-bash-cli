# template-bash-cli

An opinionated, compiled Bash CLI application template with declarative interfaces, modular source, deterministic builds, and self-contained distribution.

## Quick start

```bash
argc build
dist/bin/app --help
dist/bin/app config get APP_NAME
argc test
```

Runtime baseline: Bash 5.1 or newer. The built executable contains the project-owned source and parser and does not require argc at runtime.

See [architecture](docs/architecture.md) and [conventions](docs/conventions.md) for the source and distribution contracts.

The [North Star](docs/north-star.md) defines the project's long-term direction, ownership boundaries, and evidence gates. Significant architectural choices are recorded in the [decision log](docs/decisions/README.md).
