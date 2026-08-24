#!/usr/bin/env bash
# @module temp
# @brief Temporary paths and atomic filesystem operations.
# @requires core,error
# @public app::tmp::create
# @public app::fs::atomic_write

function app::tmp::create {
  local kind=${1:-file} path
  case $kind in
  file) path=$(mktemp "${TMPDIR:-/tmp}/${APP_NAME}.XXXXXX") || {
    app::error::io 'mktemp failed'
    return 5
  } ;;
  dir) path=$(mktemp -d "${TMPDIR:-/tmp}/${APP_NAME}.XXXXXX") || {
    app::error::io 'mktemp failed'
    return 5
  } ;;
  *)
    app::error::usage "unknown temporary path type: $kind"
    return 2
    ;;
  esac
  _APP_TMP_PATHS+=("$path")
  printf '%s\n' "$path"
}

function app::fs::atomic_write {
  local target=$1 content=$2 directory temp
  directory=$(dirname -- "$target")
  [[ -d $directory ]] || {
    app::error::io "directory does not exist: $directory"
    return 5
  }
  temp=$(app::tmp::create file) || return
  printf '%s' "$content" >"$temp" || {
    app::error::io "cannot write: $target"
    return 5
  }
  mv -f -- "$temp" "$target" || {
    app::error::io "cannot replace: $target"
    return 5
  }
}
