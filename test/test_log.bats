#!/usr/bin/env bats

# Load the bats-assert library
load "$(dirname "$BATS_TEST_DIRNAME")/test/test_helper/bats-assert/load.bash"

# Load the log.sh script
setup() {
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/consts.sh"
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/log.sh"
}

# @test "dnsprop::log::info not verbose" {
#   DNSPROP_VERBOSE=0
#   run dnsprop::log::info "This is an info message"
#   assert_success
#   assert_output --partial "INFO:"
#   assert_output --partial "This is an info message"
# }

@test "dnsprop::log::info function" {
  run dnsprop::log::info "This is an info message"
  assert_success
  assert_output --partial "INFO:"
  assert_output --partial "This is an info message"
}

@test "dnsprop::log::error function" {
  run dnsprop::log::error "This is an error message"
  assert_success
  assert_output --partial "ERROR:"
  assert_output --partial "This is an error message"
}
