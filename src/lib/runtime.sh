#!/usr/bin/env bash
# @module runtime
# @brief Application startup, dependency checks, and cleanup.
# @requires core
# @public app::runtime::init
# @public app::runtime::cleanup
# @public app::runtime::require
# @public app::runtime::die

function app::runtime::init {
  local no_color=${1:-0} verbose=${2:-0} quiet=${3:-0} format=${4:-} dry_run=${5:-0} yes=${6:-0}
  APP_ROOT=${APP_ROOT:-$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}
  if [[ $no_color == 1 ]]; then APP_COLOR=never; fi
  if [[ $verbose =~ ^[1-9] ]]; then APP_LOG_LEVEL=debug; fi
  if [[ $quiet == 1 ]]; then APP_LOG_LEVEL=error; fi
  if [[ -n $format ]]; then APP_FORMAT=$format; fi
  APP_DRY_RUN=$dry_run
  APP_YES=$yes
  export APP_COLOR APP_LOG_LEVEL APP_FORMAT APP_DRY_RUN APP_YES
  trap 'app::runtime::cleanup' EXIT HUP INT TERM
}

function app::runtime::cleanup {
  local path
  for path in "${_APP_TMP_PATHS[@]}"; do
    [[ -e $path ]] || continue
    rm -rf -- "$path"
  done
}

function app::runtime::require {
  local command_name=$1
  command -v "$command_name" >/dev/null 2>&1 || {
    app::error::dependency "$command_name"
    return 4
  }
}

function app::runtime::die { app::error::die "$1" "${2:-1}"; }
