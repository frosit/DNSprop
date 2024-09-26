#!/usr/bin/env bats

# Load the bats-assert library
load "$(dirname "$BATS_TEST_DIRNAME")/test/test_helper/bats-support/load.bash"
load "$(dirname "$BATS_TEST_DIRNAME")/test/test_helper/bats-assert/load.bash"

DNSPROP_VERBOSE=1
DNSPROP_DEBUG=1
DNSPROP_LOG_LEVEL=8
DNSPROP_ENV="test"
DNSPROP_LOG_DIR="$(dirname "$BATS_TEST_DIRNAME")/test"
DNSPROP_LOG_FILE="dnsprob_test.log"

# Load the log.sh script
setup() {
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/consts.sh"
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/log.sh"
}

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

@test "dnsprop::log::info not verbose" {
  DNSPROP_VERBOSE=0
  setup # Re-run setup to apply the new value
  run dnsprop::log::info "This is an info message"
  assert_success
  ! assert_output --partial "This is an info message"
}

@test "dnsprop::log::info outside log level" {
  DNSPROP_VERBOSE=1
  DNSPROP_LOG_LEVEL=2
  setup
  run dnsprop::log::info "This is an info message"
  assert_success
  ! assert_output --partial "This is an info message"
}

@test "dnsprop::log::info enabled log write" {
  DNSPROP_VERBOSE=1
  DNSPROP_LOG_LEVEL=8
  DNSPROP_LOG_FILE="dnsprob_test.log"

  setup

  run dnsprop::log::info "This is an info message"
  assert_success

  run test -f "$DNSPROP_LOG_DIR/$DNSPROP_LOG_FILE"
  assert_success

  run cat "$DNSPROP_LOG_DIR/$DNSPROP_LOG_FILE"
  assert_success
  assert_output --partial "INFO: This is an info message"
}

@test "disable log write" {
  DNSPROP_VERBOSE=1
  DNSPROP_LOG_LEVEL=8
  DNSPROP_LOG_FILE=false

  setup # Re-run setup to apply the new value

  run dnsprop::log::info "This is an info message"
  assert_success

  run test -f "$DNSPROP_LOG_DIR/$DNSPROP_LOG_FILE"
  assert_failure

}
