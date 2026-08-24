#!/usr/bin/env bash
# @cmd Manage configuration.
config() { :; }

# @cmd Read a configuration value.
# @arg key! Configuration key.
# shellcheck disable=SC2154
function config::get {
  app::runtime::init "${argc_no_color:-0}" "${argc_verbose:-0}" "${argc_quiet:-0}" "${argc_format:-}" "${argc_dry_run:-0}" "${argc_yes:-0}"
  app::config::get "$argc_key"
}

# @cmd Set a writable configuration value.
# @arg key! Configuration key.
# @arg value! New value.
# shellcheck disable=SC2154
function config::set {
  app::runtime::init "${argc_no_color:-0}" "${argc_verbose:-0}" "${argc_quiet:-0}" "${argc_format:-}" "${argc_dry_run:-0}" "${argc_yes:-0}"
  app::config::set "$argc_key" "$argc_value"
}
