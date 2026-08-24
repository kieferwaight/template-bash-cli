#!/usr/bin/env bash
# @module core
# @brief Shared framework state and shell helpers.
# @public app::core::is_tty
# @public app::core::die

APP_NAME=${APP_NAME:-app}
APP_VERSION=${APP_VERSION:-0.1.0}
APP_ROOT=${APP_ROOT:-}
APP_CONFIG_DIR=${APP_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/$APP_NAME}
APP_CACHE_DIR=${APP_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/$APP_NAME}
APP_STATE_DIR=${APP_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/$APP_NAME}
APP_RUNTIME_DIR=${APP_RUNTIME_DIR:-${TMPDIR:-/tmp}/$APP_NAME}
APP_COLOR=${APP_COLOR:-auto}
APP_LOG_LEVEL=${APP_LOG_LEVEL:-info}
APP_FORMAT=${APP_FORMAT:-text}
APP_DRY_RUN=${APP_DRY_RUN:-0}
APP_YES=${APP_YES:-0}
_APP_TMP_PATHS=()
_APP_EXIT_STATUS=0

function app::core::is_tty {
  [[ -t 1 ]]
}

function app::core::die {
  local message=$1
  local status=${2:-1}
  printf '%s\n' "$message" >&2
  return "$status"
}
