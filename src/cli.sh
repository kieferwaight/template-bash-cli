#!/usr/bin/env bash
# @describe Compiled, composable Bash CLI application.
# @version 0.1.0
# @flag -v --verbose* Increase diagnostic verbosity.
# @flag -q --quiet* Suppress non-essential diagnostics.
# @flag --no-color Disable ANSI colors.
# @flag -n --dry-run Describe changes without applying them.
# @flag -y --yes Skip interactive confirmation.
# @option --format Output format: text or json.
#%include lib/core.sh
#%include lib/error.sh
#%include lib/runtime.sh
#%include lib/log.sh
#%include lib/output.sh
#%include lib/path.sh
#%include lib/config.sh
#%include lib/temp.sh
#%include commands/config.sh
#%include commands/completion.sh
#%include commands/run.sh

eval "$(argc --argc-eval "$0" "$@")"
