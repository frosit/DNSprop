#!/usr/bin/env bats

# Load the bats-assert library
load "$(dirname "$BATS_TEST_DIRNAME")/test/test_helper/bats-support/load.bash"
load "$(dirname "$BATS_TEST_DIRNAME")/test/test_helper/bats-assert/load.bash"

# Load the log.sh script
setup() {
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/consts.sh"
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/log.sh"
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/requirements.sh"
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/record.sh"
}

@test "dnsprop::record.get_part record_type" {
  result=$(dnsprop::record.get_part "A::example.com" "record_type")
  assert_equal "$result" "A"
}

@test "dnsprop::record.get_part domain" {
  result=$(dnsprop::record.get_part "A::example.com" "domain")
  assert_equal "$result" "example.com"
}

@test "dnsprop::record.get_part expected_value" {
  result=$(dnsprop::record.get_part "A::example.com::example.com" "expected_value")
  assert_equal "$result" "example.com"
}

@test "dnsprop::record.compare_regexp" {
  run dnsprop::record.compare_regexp "88.77.66.55.44" "^[0-9\.]+$"
  assert_success
}

@test "dnsprop::record.compare_regexp fail" {
  run dnsprop::record.compare_regexp "some.serveraddress.com" "^[0-9\.]+$"
  assert_failure
}

@test "dnsprop::record.compare_regexp 2" {
  run dnsprop::record.compare_regexp "frosit.nl" "frosit\.(nl|it)"
  assert_success
}

@test "dnsprop::record.compare_like" {
  run dnsprop::record.compare_like "example.com" "example%"
  assert_success
}

@test "dnsprop::record.compare_wildcard" {
  run dnsprop::record.compare_wildcard "example.com" "example.*"
  assert_success
}

@test "dnsprop::record.compare_cidr" {
  run dnsprop::record.compare_cidr "192.168.1.15" "192.168.1.1/24"
  assert_success
}

@test "dnsprop::record.compare_string eq" {
  run dnsprop::record.compare_string "example.com" "example.com" "eq"
  assert_success
}

@test "dnsprop::record.compare_string ne" {
  run dnsprop::record.compare_string "example.com" "example.com" "ne"
  assert_failure
}

@test "dnsprop::record.compare_expected_value REGEXP" {
  run dnsprop::record.compare_expected_value "REGEXP'^[0-9\.]+$'" "88.77.66.55"
  assert_success
}

@test "dnsprop::record.compare_expected_value LIKE" {
  run dnsprop::record.compare_expected_value "LIKE'example%'" "example.com"
  assert_success
}

@test "dnsprop::record.compare_expected_value WILDCARD" {
  run dnsprop::record.compare_expected_value "WILDCARD'example.*'" "example.com"
  assert_success
}

@test "dnsprop::record.compare_expected_value CIDR match" {
  run dnsprop::record.compare_expected_value "CIDR'192.168.1.0/24'" "192.168.1.15"
  assert_success
}

@test "dnsprop::record.compare_expected_value STRING eq" {
  run dnsprop::record.compare_expected_value "='example.com'" "example.com"
  assert_success
}

@test "dnsprop::record.compare_expected_value STRING ne" {
  run dnsprop::record.compare_expected_value "!='example.com'" "notexample.com"
  assert_success
}

@test "dnsprop::record.dig" {
  result=$(dnsprop::record.dig "example.com" "A" "8.8.8.8")
  assert [ -n "$result" ]
}

# Additional tests

@test "dnsprop::record.get_part default domain" {
  result=$(dnsprop::record.get_part "A::example.com")
  assert_equal "$result" "example.com"
}

@test "dnsprop::record.get_part no type" {
  result=$(dnsprop::record.get_part "example.com" "record_type")
  assert_equal "$result" "A"
}

@test "dnsprop::record.compare_regexp no match" {
  run dnsprop::record.compare_regexp "example.com" "test.*"
  assert_failure
}

@test "dnsprop::record.compare_like no match" {
  run dnsprop::record.compare_like "example.com" "test%"
  assert_failure
}

@test "dnsprop::record.compare_wildcard no match" {
  run dnsprop::record.compare_wildcard "example.com" "test.*"
  assert_failure
}

@test "dnsprop::record.compare_cidr no match" {
  run dnsprop::record.compare_cidr "192.168.2.15" "192.168.1.1/24"
  assert_failure
}

@test "dnsprop::record.compare_string eq no match" {
  run dnsprop::record.compare_string "example.com" "test.com" "eq"
  assert_failure
}

@test "dnsprop::record.compare_string ne match" {
  run dnsprop::record.compare_string "example.com" "test.com" "ne"
  assert_success
}

@test "dnsprop::record.compare_expected_value REGEXP no match" {
  run dnsprop::record.compare_expected_value "REGEXP'^[0-9\.]+$'" "example.com"
  assert_failure
}

@test "dnsprop::record.compare_expected_value LIKE no match" {
  run dnsprop::record.compare_expected_value "LIKE'test%'" "example.com"
  assert_failure
}

@test "dnsprop::record.compare_expected_value WILDCARD no match" {
  run dnsprop::record.compare_expected_value "WILDCARD'test.*'" "example.com"
  assert_failure
}

@test "dnsprop::record.compare_expected_value CIDR no match" {
  run dnsprop::record.compare_expected_value "CIDR'192.168.1.1/24'" "192.168.2.15"
  assert_failure
}

@test "dnsprop::record.compare_expected_value STRING eq no match" {
  run dnsprop::record.compare_expected_value "='test.com'" "example.com"
  assert_failure
}

@test "dnsprop::record.compare_expected_value STRING ne no match" {
  run dnsprop::record.compare_expected_value "!='test.com'" "test.com"
  assert_failure
}
