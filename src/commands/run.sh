#!/usr/bin/env bash
# @cmd Run a demonstration application action.
# @arg message Message to print.
run() {
  app::runtime::init "${argc_no_color:-0}" "${argc_verbose:-0}" "${argc_quiet:-0}" "${argc_format:-}" "${argc_dry_run:-0}" "${argc_yes:-0}"
  app::output::value message "${argc_message:-ready}"
}
