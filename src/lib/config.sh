#!/usr/bin/env bash
# @module config
# @brief Example application configuration API.
# @requires core,output,error
# @public app::config::get
# @public app::config::set

function app::config::get {
  local key=$1
  case $key in
  APP_NAME) app::output::value "$key" "$APP_NAME" ;;
  APP_VERSION) app::output::value "$key" "$APP_VERSION" ;;
  APP_CONFIG_DIR) app::output::value "$key" "$APP_CONFIG_DIR" ;;
  *)
    app::error::config "unknown key: $key"
    return 3
    ;;
  esac
}

function app::config::set {
  local key=$1 value=$2
  case $key in
  APP_LOG_LEVEL)
    APP_LOG_LEVEL=$value
    export APP_LOG_LEVEL
    ;;
  *)
    app::error::config "key is not writable: $key"
    return 3
    ;;
  esac
}
