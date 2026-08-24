# Architectural Decision Log

This directory records decisions that shape the bash-cli framework's public contracts, ownership boundaries, or migration path.

Each decision must state:

- **Problem and observed pressure** — what real use or evidence requires a decision.
- **Options considered** — including a no-change option when meaningful.
- **Decision and ownership layer** — application, framework/runtime, tooling, distribution adapter, or generated artifact.
- **Compatibility and reversibility** — who can be affected and how migration/ejection works.
- **Evidence and revisit trigger** — tests, dogfooding, consumer behavior, or a condition that reopens the decision.

Decisions are append-only records. A later decision supersedes an earlier one; it does not rewrite history.

| ID | Decision | Status |
| --- | --- | --- |
| [0001](0001-lineage-and-extraction.md) | Preserve lineage before repository extraction | Accepted |
