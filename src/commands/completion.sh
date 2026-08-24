#!/usr/bin/env bash
# @cmd Generate shell completion output.
completion() { :; }

# @cmd Generate Bash completion.
function completion::bash {
  app::runtime::init
  app::runtime::require argc || return 4
  argc --argc-completions bash "$APP_NAME"
}

# @cmd Generate Zsh completion.
function completion::zsh {
  app::runtime::init
  app::runtime::require argc || return 4
  argc --argc-completions zsh "$APP_NAME"
}

# @cmd Generate Fish completion.
function completion::fish {
  app::runtime::init
  app::runtime::require argc || return 4
  argc --argc-completions fish "$APP_NAME"
}
