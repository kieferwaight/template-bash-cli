#!/usr/bin/env bats

setup() {
  APP="${BATS_TEST_DIRNAME}/../../dist/bin/app"
}

@test "compiled app reports its version" {
  run "$APP" --version
  [ "$status" -eq 0 ]
  [ "$output" = "app 0.1.0" ]
}

@test "config get keeps data on stdout" {
  run "$APP" config get APP_NAME
  [ "$status" -eq 0 ]
  [ "$output" = "app" ]
}

@test "invalid command returns usage status" {
  run "$APP" does-not-exist
  [ "$status" -eq 2 ]
}
