#!/usr/bin/env bash
# @module error
# @brief Stable exit status and diagnostic helpers.
# @requires core
# @public app::error::usage
# @public app::error::config
# @public app::error::dependency
# @public app::error::io
# @public app::error::network
# @public app::error::auth
# @public app::error::die

function app::error::usage {
  printf 'error: %s\n' "$1" >&2
  return 2
}
function app::error::config {
  printf 'config error: %s\n' "$1" >&2
  return 3
}
function app::error::dependency {
  printf 'dependency unavailable: %s\n' "$1" >&2
  return 4
}
function app::error::io {
  printf 'I/O error: %s\n' "$1" >&2
  return 5
}
function app::error::network {
  printf 'network error: %s\n' "$1" >&2
  return 6
}
function app::error::auth {
  printf 'authentication error: %s\n' "$1" >&2
  return 7
}
function app::error::die {
  printf 'error: %s\n' "$1" >&2
  exit "${2:-1}"
}
