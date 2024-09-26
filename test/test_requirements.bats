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
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/requirements.sh"
}

@test "_get_bash_version function" {
  run _get_bash_version
  assert_success
  # assert_output --partial "bash"
  assert_output
}

@test "_is_bash_version_meeting_required_version function" {
  run _is_bash_version_meeting_required_version
  assert_success
}

@test "check_bash_version function" {
  run check_bash_version
  assert_success
}

@test "is_installed function with existing command" {
  run is_installed "bash"
  assert_success
}

@test "is_installed function with non-existing command" {
  run is_installed "nonexistentcommand"
  assert_failure
}

@test "dnsprop::check_requirements function with all requirements met" {
  run dnsprop::check_requirements
  assert_success
}

@test "dnsprop::check_requirements function with missing requirements" {
  # Temporarily modify the requirements array to include a non-existent command
  __DNSPROP_REQUIREMENTS+=("nonexistentcommand")
  run dnsprop::check_requirements
  assert_failure
  # assert_output --partial "Requirement not found: nonexistentcommand"
}
