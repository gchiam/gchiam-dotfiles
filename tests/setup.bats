#!/usr/bin/env bats

@test "setup.sh exits with error for invalid argument" {
  run bin/setup.sh --invalid-arg
  [ "$status" -ne 0 ] # Expect a non-zero exit status for invalid arguments
  # Check if the output contains the specific error message
  [[ "${lines[*]}" =~ "Error: Unknown argument: --invalid-arg" ]] # Expect specific error message in output
}

@test "setup.sh enters debug mode with --debug argument" {
  run bin/setup.sh --debug
  [ "$status" -eq 0 ] # Expect zero exit status
  [[ "${lines[*]}" =~ "Debug mode is enabled." ]] # Expect debug message in output
}
