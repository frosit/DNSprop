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

        if [[ "$value" == "$record_expected_value" ]]; then
          # status="OK:"
          # status="V"
          status="Y"
          # status="${__NSPROP_COLORS_GREEN}V${__NSPROP_COLORS_RESET}"
          # status="\033[32mY\033[0m" # Green 'Y'
          # value="${__NSPROP_COLORS_GREEN}OK:${value}${__NSPROP_COLORS_RESET}"
        else
          # status="FAIL:"
          status="X"
          # status="\033[31mX\033[0m" # Red 'X'
          # value="${__NSPROP_COLORS_RED}FAIL:${value}${__NSPROP_COLORS_RESET}"
        fi
        # value="${status}${value}"
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
