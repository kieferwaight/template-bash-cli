# CLI Reference

- @describe Compiled, composable Bash CLI application.
- @version 0.1.0
- @flag -v --verbose* Increase diagnostic verbosity.
- @flag -q --quiet* Suppress non-essential diagnostics.
- @flag --no-color Disable ANSI colors.
- @flag -n --dry-run Describe changes without applying them.
- @flag -y --yes Skip interactive confirmation.
- @option --format Output format: text or json.
- @cmd Manage configuration.
- @cmd Read a configuration value.
- @arg key! Configuration key.
- @cmd Set a writable configuration value.
- @arg key! Configuration key.
- @arg value! New value.
- @cmd Generate shell completion output.
- @cmd Generate Bash completion.
- @cmd Generate Zsh completion.
- @cmd Generate Fish completion.
- @cmd Run a demonstration application action.
- @arg message Message to print.

Generated from source annotations.
