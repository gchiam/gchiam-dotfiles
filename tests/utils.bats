#!/usr/bin/env bats

@test "utils.sh uses [[ for safer evaluations (final check)" {
  run grep 'if \[\[ -t 1 \]\]' bin/lib/utils.sh
  [ "$status" -eq 0 ] # Expect to find the new pattern
}