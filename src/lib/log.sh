#!/usr/bin/env bash
# @module log
# @brief stderr-only diagnostics.
# @requires core
# @public app::log::write
# @public app::log::debug
# @public app::log::info
# @public app::log::warn
# @public app::log::error

function _app::log::enabled {
  case ${APP_LOG_LEVEL}:${1:-info} in
  debug:debug | debug:info | debug:warn | debug:error | info:info | info:warn | info:error | warn:warn | warn:error | error:error) return 0 ;;
  *) return 1 ;;
  esac
}

function app::log::write {
  local level=$1
  shift
  _app::log::enabled "$level" || return 0
  printf '%s: %s\n' "$level" "$*" >&2
}
function app::log::debug { app::log::write debug "$@"; }
function app::log::info { app::log::write info "$@"; }
function app::log::warn { app::log::write warn "$@"; }
function app::log::error { app::log::write error "$@"; }
