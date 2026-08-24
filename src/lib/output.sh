#!/usr/bin/env bash
# @module output
# @brief Composable stdout output helpers.
# @requires core
# @public app::output::text
# @public app::output::json
# @public app::output::value

function app::output::text { printf '%s\n' "$*"; }

function app::output::json {
  local key=$1 value=${2:-}
  printf '{"%s":"%s"}\n' \
    "${key//\\/\\\\}" "${value//\\/\\\\}" | sed 's/"/\\"/g; s/{\\"/{"/; s/\\":/":/; s/:\\"/:"/; s/\\"}/"}/'
}

function app::output::value {
  if [[ ${APP_FORMAT} == json ]]; then app::output::json "$@"; else app::output::text "${2:-}"; fi
}
