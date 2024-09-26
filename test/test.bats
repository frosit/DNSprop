#!/usr/bin/env bats

@test "example test" {
  run ./src/your_script.sh
  [ "$status" -eq 0 ]
  [ "$output" = "expected output" ]
}
