#!/bin/bash

# Script: utils.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

__DNSPROP_DNSSERVERS=("8.8.8.8" "208.67.222.222")
__DNSPROP_SERVERNAMES="[US] Google Public DNS;[US] OpenDNS;"
# SERVERIPS="8.8.8.8 208.67.222.222 9.9.9.9 1.1.1.1 185.228.168.9 194.150.168.168"
# SERVERNAMES="[US] Google Public DNS;[US] OpenDNS;[EU] Quad9;[EU] Cloudflare;[UK] CleanBrowsing;[NL] OpenNIC;"

# Function: dnsprop::record.get_part
# Description: Parses a DNS record string and returns the specified part.
# Parameters:
#   $1: The DNS record string to parse.
#   $2: The part to return. Either "record_type", "domain" or "expected_value". Default is "domain".
# Returns:
#   The specified part of the DNS record string.
# Example:
#   dnsprop::record.get_part "A::example.com" "record_type" # Output: A
#   dnsprop::record.get_part "A::example.com" "domain" # Output: example.com
#   dnsprop::record.get_part "A::example.com" "expected_value" # Output: example.com
dnsprop::record.get_part() {
  local input="$1"
  local input_without_type

  local record_type
  local domain
  local expected_value

  # the part to resturn, either "record_type", "domain" or "expected_value"
  local return_value="${2:-"domain"}"

  # parse record type
  if [[ $input =~ ^(A|CNAME|TXT|SRV) ]]; then
    record_type="${input%%::*}"
    input_without_type="${input#*::}"
  else # default to A record type
    record_type="A"
    input_without_type="${input}"
  fi

  # parse domain, check if there is also a "expected_value" part
  if [[ "$input_without_type" == *::* ]]; then
    domain="${input_without_type%%::*}"
    expected_value="${input_without_type#*::}"
  else # no expected value provided, domain is input_without_type
    domain="$input_without_type"
  fi

  case $return_value in
  "record_type")
    echo "$record_type"
    ;;
  "domain")
    echo "$domain"
    ;;
  "expected_value")
    echo "$expected_value"
    ;;
  *)
    echo "$domain"
    ;;
  esac
}

# Function: dnsprop::record.dig
# Description: Queries a DNS server for a specific DNS record type of a given domain.
# Parameters:
#   $1: The domain to query.
#   $2: The record type to query. Default is "A".
#   $3: The IP address of the DNS server to query.
dnsprop::record.dig() {
  local domain="$1"
  local record_type="${2:-"A"}"
  local dns_server="${3}"
  local options=()

  if [[ -z "$dns_server" ]]; then
    options=("$domain" "$record_type" +short)
  else
    options=("@$dns_server" "$domain" "$record_type" +short)
  fi

  dig "${options[@]}"

  local dig

  if [[ -z "$dns_server" ]]; then
    dig @"$dns_server" "$domain" "$record_type" +short
  else
    dig @"$dns_server" "$domain" "$record_type" +short
  fi
  dig +short "$domain" "$record_type"
}
