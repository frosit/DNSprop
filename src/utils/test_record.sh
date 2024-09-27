#!/usr/bin/env bats

# Load the bats-assert library
load "$(dirname "$BATS_TEST_DIRNAME")/test/test_helper/bats-support/load.bash"
load "$(dirname "$BATS_TEST_DIRNAME")/test/test_helper/bats-assert/load.bash"

# Load the functions from record.sh
source /Users/frosit/git/DNSprop/src/utils/record.sh

# Load the log.sh script
setup() {
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/consts.sh"
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/log.sh"
  source "$(dirname "$BATS_TEST_DIRNAME")/src/utils/record.sh"
}

@test "dnsprop::record.get_part record_type" {
  result=$(dnsprop::record.get_part "A::example.com" "record_type")
  [ "$result" = "A" ]
}

@test "dnsprop::record.get_part domain" {
  result=$(dnsprop::record.get_part "A::example.com" "domain")
  [ "$result" = "example.com" ]
}

@test "dnsprop::record.get_part expected_value" {
  result=$(dnsprop::record.get_part "A::example.com" "expected_value")
  [ "$result" = "example.com" ]
}

@test "dnsprop::record.compare_regexp" {
  run dnsprop::record.compare_regexp "example.com" "example.*"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_like" {
  run dnsprop::record.compare_like "example.com" "example%"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_wildcard" {
  run dnsprop::record.compare_wildcard "example.com" "example.*"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_cidr" {
  run dnsprop::record.compare_cidr "192.168.1.15" "192.168.1.1/24"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_string eq" {
  run dnsprop::record.compare_string "example.com" "example.com" "eq"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_string ne" {
  run dnsprop::record.compare_string "example.com" "example.com" "ne"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_expected_value REGEXP" {
  run dnsprop::record.compare_expected_value "REGEXP'^[0-9\.]+$'" "88.77.66.55"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_expected_value LIKE" {
  run dnsprop::record.compare_expected_value "LIKE'example%'" "example.com"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_expected_value WILDCARD" {
  run dnsprop::record.compare_expected_value "WILDCARD'example.*'" "example.com"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_expected_value CIDR" {
  run dnsprop::record.compare_expected_value "CIDR'192.168.1.1/24'" "192.168.1.15"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_expected_value STRING eq" {
  run dnsprop::record.compare_expected_value "='example.com'" "example.com"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_expected_value STRING ne" {
  run dnsprop::record.compare_expected_value "!='example.com'" "notexample.com"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.dig" {
  result=$(dnsprop::record.dig "example.com" "A" "8.8.8.8")
  [ -n "$result" ]
}

# Additional tests

@test "dnsprop::record.get_part default domain" {
  result=$(dnsprop::record.get_part "A::example.com")
  [ "$result" = "example.com" ]
}

@test "dnsprop::record.get_part no type" {
  result=$(dnsprop::record.get_part "example.com" "record_type")
  [ "$result" = "A" ]
}

@test "dnsprop::record.compare_regexp no match" {
  run dnsprop::record.compare_regexp "example.com" "test.*"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_like no match" {
  run dnsprop::record.compare_like "example.com" "test%"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_wildcard no match" {
  run dnsprop::record.compare_wildcard "example.com" "test.*"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_cidr no match" {
  run dnsprop::record.compare_cidr "192.168.2.15" "192.168.1.1/24"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_string eq no match" {
  run dnsprop::record.compare_string "example.com" "test.com" "eq"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_string ne match" {
  run dnsprop::record.compare_string "example.com" "test.com" "ne"
  [ "$status" -eq 0 ]
}

@test "dnsprop::record.compare_expected_value REGEXP no match" {
  run dnsprop::record.compare_expected_value "REGEXP'^[0-9\.]+$'" "example.com"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_expected_value LIKE no match" {
  run dnsprop::record.compare_expected_value "LIKE'test%'" "example.com"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_expected_value WILDCARD no match" {
  run dnsprop::record.compare_expected_value "WILDCARD'test.*'" "example.com"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_expected_value CIDR no match" {
  run dnsprop::record.compare_expected_value "CIDR'192.168.1.1/24'" "192.168.2.15"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_expected_value STRING eq no match" {
  run dnsprop::record.compare_expected_value "='test.com'" "example.com"
  [ "$status" -eq 1 ]
}

@test "dnsprop::record.compare_expected_value STRING ne no match" {
  run dnsprop::record.compare_expected_value "!='test.com'" "test.com"
  [ "$status" -eq 1 ]
}
