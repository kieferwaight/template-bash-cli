# Architecture

The template separates four grammars:

1. argc annotations define the CLI interface.
2. Bash modules define implementation APIs.
3. `#%include` directives define deterministic assembly.
4. `dist/` defines the installed and release artifact contract.

Commands in `src/commands/` translate argc state into calls to `app::` libraries. Libraries never depend on argc variables. The assembled script is compiled with argc so the installed executable does not need argc or the source repository.

