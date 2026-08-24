#!/usr/bin/env bash
# @module path
# @brief Path manipulation primitives.
# @requires core
# @public app::path::is_absolute
# @public app::path::canonicalize
# @public app::path::normalize

function app::path::is_absolute { [[ $1 == /* ]]; }
function app::path::canonicalize { CDPATH='' cd -- "$1" 2>/dev/null && pwd -P; }
function app::path::normalize {
  local path=$1
  path=${path//\/\//\/}
  while [[ $path == */./* ]]; do path=${path//\/\.\//\/}; done
  printf '%s\n' "${path%/}"
}
