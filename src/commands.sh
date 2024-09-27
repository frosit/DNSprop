#!/bin/bash

# Script: cli.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

__DNSPROP_DNSSERVERS_TABLE_HEADERS=("DNS" "IP")

# Start DNSProp in monitoring mode
dnsprop::commands.monitor() {
  dnsprop::output.title "Monitor"
}
# Show information about DNSProp
dnsprop::commands.info() {
  dnsprop::output.title "DNSProp - info"
  dnsprop::output.writeln "DNSProp is a tool to check DNS propagation."

  # Show all major env variables
  dnsprop::output.key_value "Environment" "$DNSPROP_ENV"
  dnsprop::output.key_value "Build Mode" "$DNSPROP_IS_BUILD"
  dnsprop::output.key_value "Debug" "$DNSPROP_DEBUG"
  dnsprop::output.key_value "Verbose" "$DNSPROP_VERBOSE"
  dnsprop::output.key_value "Log Level" "$DNSPROP_LOG_LEVEL"
  dnsprop::output.key_value "Log file" "$__DNSPROP_LOG_FILE"
  dnsprop::output.key_value "Log dir" "$__DNSPROP_LOG_DIR"

  echo -e ""

  dnsprop::commands.dnsservers
}

# Show DNS servers
# Usage: dnsprop::commands.dnsservers
# Returns:
#   None
dnsprop::commands.dnsservers() {
  local dns_servers=()
  local server_name
  local server_ip

  dns_servers=("${__DNSPROP_DNS_SERVER_NAME_IP[@]}")

  dnsprop::output.subtitle "DNS Servers"

  for dns_server in "${dns_servers[@]}"; do
    server_name="${dns_server%%::*}"
    server_ip="${dns_server#*::}"
    dnsprop::output.key_value "$server_name" "$server_ip"
  done

  dnsprop::output.seperator "^" "*"
}

dnsprop::commands.expect() {
  dnsprop::output.title "DNSProp - Expect debugger"
  dnsprop::output.writeln "The expect debugger helps you to debug the patterm and matching for expected value of a DNS record."

  local record="${DNSPROP_ARGS[0]}"
  local record_type=$(dnsprop::record.get_part "$record" "record_type")
  local record_domain=$(dnsprop::record.get_part "$record" "domain")
  local record_expected_value=$(dnsprop::record.get_part "$record" "expected_value")

  local expect_matching_type
  local expect_matching_pattern

  # regex="^(REGEXP|LIKE|WILDCARD|CIDR|!=|=)\'([^\']*)\'$"
  regex="^(REGEXP|LIKE|WILDCARD|CIDR|!=|=)(?:\'|)([^\']*)(?:\'|)$"
  # if [[ "$record_expected_value" =~ ^(REGEXP|LIKE|WILDCARD|CIDR|!=|=)\(\'([^\']*)\'\)$ ]]; then
  if [[ "$expect_value" =~ $regex ]]; then
    expect_matching_type="${BASH_REMATCH[1]}"
    expect_matching_pattern="${BASH_REMATCH[2]}"
  fi

  # dnsprop::record.compare_expected_value $expected $actual
  # dnsprop::record.compare_expect_type "$record_expected_value"

  dnsprop::output.key_value "Record" "$record"
  dnsprop::output.key_value "Record Type" "$record_type"
  dnsprop::output.key_value "Record Domain" "$record_domain"
  dnsprop::output.key_value "Record Expected Value" "$record_expected_value"

  dnsprop::output.key_value "Record Expected match type" "$expect_matching_type"
  dnsprop::output.key_value "Record Expected match pattern" "$expect_matching_pattern"

}

# Check DNS propagation for a domain
# Usage: dnsprop::commands.check
# Returns:
#   None
dnsprop::commands.check() {

  local domains=()
  local options=()

  dnsprop::output.title "DNS Propagation Check."

  domains=("${DNSPROP_ARGS[@]}")
  if [[ ${#domains[@]} -eq 0 ]]; then
    dnsprop::log::error "No domains to check"
    exit 1
  fi

  dnsprop::output.write "Preparing to check DNS servers...."

  # Iterate records
  for record in "${domains[@]}"; do
    dnsprop::commands.check_record "$record"
  done

  dnsprop::log::info "Checking DNS propagation..."
}

# Check DNS propagation for a specific record
# Usage: dnsprop::commands.check_record "record"
# Parameters:
#   $1 - The record to check
# Returns:
#   None
dnsprop::commands.check_record() {
  local record="$1"

  dnsprop::output.subtitle "Checking: $record"

  local record_type=$(dnsprop::record.get_part "$record" "record_type")
  local record_domain=$(dnsprop::record.get_part "$record" "domain")
  local record_expected_value=$(dnsprop::record.get_part "$record" "expected_value")

  dnsprop::output.key_value "Record Type" "$record_type"
  dnsprop::output.key_value "Record Domain" "$record_domain"
  dnsprop::output.key_value "Record Expected Value" "$record_expected_value"

  echo -e ""

  # dnsprop::output.table_add_header "DNS" "DNS IP" "value" "s"
  dnsprop::output.table_add_header "DNS" "DNS IP" "value"

  for dns_server in "${__DNSPROP_DNS_SERVER_NAME_IP[@]}"; do
    local server_name="${dns_server%%::*}"
    local server_ip="${dns_server#*::}"

    local dns_value=$(dnsprop::record.dig "$record_domain" "$record_type" "$server_ip")
    local dig_response=()

    IFS=$'\n' read -r -d '' -a dig_response <<<"$dns_value"
    unset IFS

    local first_row=true
    local status=""
    for value in "${dig_response[@]}"; do

      if [[ "$record_expected_value" != false ]]; then # Check if expected value matches

        # echo -e "xxxx NG $record_expected_value -- $value"

        # local compare_expected_value=$(dnsprop::record.compare_expected_value "$record_expected_value" "$value")

        if dnsprop::record.compare_expected_value "$record_expected_value" "$value"; then
          status="Y"
        else
          status="X"
        fi
      fi

      if [[ "$first_row" == true ]]; then
        first_row=false
        if [[ $status == "Y" ]]; then
          # dnsprop::output.table_add_row_success "$server_name" "$server_ip" "$value" "$status"
          dnsprop::output.table_add_row_success "$server_name" "$server_ip" "$value"
        else
          # dnsprop::output.table_add_row "$server_name" "$server_ip" "$value" "$status"
          dnsprop::output.table_add_row "$server_name" "$server_ip" "$value"
        fi
      else
        if [[ $status == "Y" ]]; then
          # dnsprop::output.table_add_row_span_success "" "$value" "$status"
          dnsprop::output.table_add_row_span_success "" "$value"
        else
          # dnsprop::output.table_add_row_span "" "$value" "$status"
          dnsprop::output.table_add_row_span "" "$value"
        fi
      fi
    done
  done

  dnsprop::output.table_display_colored
  dnsprop::output::table_reset
}

# Update DNSProp to the latest version
dnsprop::commands.update() {
  echo -e "===== UPDATE ====="
  echo -e "Feature not implemented yet..."
}
