#!/bin/bash

# Script: utils.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

__DNSPROP_DNSSERVERS=("8.8.8.8" "208.67.222.222")
__DNSPROP_SERVERNAMES="[US] Google Public DNS;[US] OpenDNS;"

__DNSPROP_DNSSERVERS=("8.8.8.8" "208.67.222.222")
__DNSPROP_SERVERNAMES="[US] Google Public DNS;[US] OpenDNS;"

__DNSPROP_DNS_SERVER_NAME_IP=("[US] Google Public DNS::8.8.8.8" "[US] OpenDNS::208.67.222.222" "[EU] Quad9::9.9.9.9" "[EU] Cloudflare::1.1.1.1")

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
  local expected_value=false

  # the part to resturn, either "record_type", "domain" or "expected_value"
  local return_value="${2:-"domain"}"

  # parse record type
  if [[ $input =~ ^(A|CNAME|TXT|SRV|MX) ]]; then
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

# Function: dnsprop::record.compare_regexp
# Description: Compares a string with a regular expression pattern.
# Parameters:
#   $1: The actual string.
#   $2: The regular expression pattern to compare.
# Returns:
#   boolean: true if the string matches the regular expression pattern, false otherwise.
# Example:
#   dnsprop::record.compare_regexp "example.com" "example.*" # Output: true
dnsprop::record.compare_regexp() {
  local actual="$1"
  local pattern="$2"
  # @TODO validate pattern

  if [[ "$actual" =~ $pattern ]]; then
    dnsprop::log::debug "REGEXP match of actual: ${actual} against pattern: ${pattern} = true"
    return 0
  else
    dnsprop::log::debug "REGEXP match of actual: ${actual} against pattern: ${pattern} = false"
    return 1
  fi
}

# Function: dnsprop::record.compare_like
# Description: Compares a string with a SQL LIKE pattern.
# Parameters:
#   $1: The actual string.
#   $2: The SQL LIKE pattern to compare.
# Returns:
#   boolean: true if the string matches the SQL LIKE pattern, false otherwise.
# Example:
#   dnsprop::record.compare_like "example.com" "example%" # Output: true
dnsprop::record.compare_like() {
  local actual="$1"
  local pattern="$2"
  # Replace % with .* for regex LIKE matching
  local regex="${pattern//%/.+}"
  dnsprop::record.compare_regexp "$actual" "$regex"
}

# Function: dnsprop::record.compare_wildcard
# Description: Compares a string with a wildcard pattern.
# Parameters:
#   $1: The actual string.
#   $2: The wildcard pattern to compare.
# Returns:
#   boolean: true if the string matches the wildcard pattern, false otherwise.
# Example:
#   dnsprop::record.compare_wildcard "example.com" "example.*" # Output: true
dnsprop::record.compare_wildcard() {
  local actual="$1"
  local pattern="$2"
  # Convert wildcard syntax to regex
  local regex="${pattern//\*/.*}" # * -> .*
  regex="${regex//\?/[^.]}"       # ? -> [^.]
  dnsprop::record.compare_regexp "$actual" "$regex"
}

# Function to convert an IP address to a binary number
dnsprop::record.ip_to_binary() {
  local IFS=.
  local ip=($1)
  printf "%08b%08b%08b%08b\n" "${ip[0]}" "${ip[1]}" "${ip[2]}" "${ip[3]}"
}

# Function: dnsprop::record.compare_cidr
# Description: Compares an IP address with a CIDR range.
# Parameters:
#   $1: The actual IP address.
#   $2: The CIDR range to compare.
# Returns:
#   boolean: true if the IP address is within the CIDR range, false otherwise.
# Example:
#   dnsprop::record.compare_cidr "192.168.1.15" "192.168.1.1/24"
dnsprop::record.compare_cidr() {
  local actual="$1"
  local cidr="$2"

  # @TODO validate CIDR notation

  # Split the CIDR notation into IP and mask
  local network_ip=$(echo "$cidr" | cut -d'/' -f1)
  local prefix_length=$(echo "$cidr" | cut -d'/' -f2)

  # Convert IPs to binary
  local binary_ip=$(dnsprop::record.ip_to_binary "$actual")
  local binary_network_ip=$(dnsprop::record.ip_to_binary "$network_ip")

  # Extract the relevant part of the binary IP and network based on the prefix length
  local ip_prefix="${binary_ip:0:$prefix_length}"
  local network_prefix="${binary_network_ip:0:$prefix_length}"

  # Compare the prefixes
  if [[ "$ip_prefix" == "$network_prefix" ]]; then
    dnsprop::log::debug "CIDR matched of actual: ${actual} against pattern: ${cidr} = true"
    return 0
  else
    dnsprop::log::debug "CIDR did not match, actual: ${actual} against pattern: ${cidr} = true"
    return 1
  fi
}

# Function: dnsprop::record.compare_string
# Description: Compares two strings.
# Parameters:
#   $1: The actual string.
#   $2: The expected string.
#   $3: The operator to use for comparison. Either "eq" or "ne". Default is "eq".
# Returns:
#   boolean: true if the strings match, false otherwise.
# Example:
#   dnsprop::record.compare_string "example.com" "example.com" "eq" # Output: true
#   dnsprop::record.compare_string "example.com" "example.com" "ne" # Output: false
dnsprop::record.compare_string() {
  local actual="$1"
  local expected="$2"
  local op="$3"

  if [[ "$op" == "eq" ]]; then
    if [[ "$actual" == "$expected" ]]; then
      dnsprop::log::debug "string match of ${actual} ${op} ${expected} = true"
      echo "STRING match: true"
      return 0
    else
      dnsprop::log::debug "string match of ${actual} ${op} ${expected} = false"
      return 1
    fi
  elif [[ "$op" == "ne" ]]; then
    if [[ "$actual" != "$expected" ]]; then
      dnsprop::log::debug "string match of ${actual} ${op} ${expected} = true"
      return 0
    else
      dnsprop::log::debug "string match of ${actual} ${op} ${expected} = false"
      return 1
    fi
  fi
}

# Function: dnsprop::record.compare_expected_value
# Description: Compares the expected value of a DNS record with the actual value.
# Parameters:
#   $1: The expected value of the DNS record.
#   $2: The actual value of the DNS record.
# Returns:
#   boolean: true if the values match, false otherwise.
# Example:
#   dnsprop::record.compare_expected_value "REGEXP'^[0-9\.]+$'" "88.77.66.55.44" # Output: true
#   dnsprop::record.compare_expected_value "REGEXP'^[0-9\.]+$'" "some.serveraddress.com" # Output: false
#   dnsprop::record.compare_expected_value "LIKE'some.%.com'" "some.serveraddress.com" # Output: true
#   dnsprop::record.compare_expected_value "WILDCARD'*.some.?.com'" "some.serveraddress.com" # Output: true
#   dnsprop::record.compare_expected_value "CIDR'192.168.1.1/24'" "192.168.1.15" # Output: true
#   dnsprop::record.compare_expected_value "='domain.com'" "some.serveraddress.com" # Output: false
#   dnsprop::record.compare_expected_value "='domain.com'" "domain.com" # Output: true
#   dnsprop::record.compare_expected_value "!='domain.com'" "domains.com" # Output: false
# Options: Expected value can be a regular expression, wildcard, CIDR range, or a simple string.
#  REGEXP: Regex matching
#  WILDCARD: Wildcard (? and *) matching
#  LIKE: SQL LIKE matching (using %)
#  CIDR: CIDR range matching (requires ipcalc)
#  STRING: Simple string matching using = or != ()
dnsprop::record.compare_expected_value() {
  local expected="$1"
  local actual="$2"

  dnsprop::log::debug "Expected: ${expected}, Actual: ${actual}"

  # determine type of compare by the string starting with:
  # REGEXP:
  # WILDCARD: if expected_value contains * or ?, then use wildcard compare
  # LIKE: if expected_value contains %, then use SQL LIKE compare
  # CIDR: if expected_value contains /, then use CIDR compare
  # STRING: otherwise, use string compare

  local pattern
  local matching

  if [[ "$expected" =~ REGEXP\'(.*)\' ]]; then
    pattern="${BASH_REMATCH[1]}"
    dnsprop::log::debug "REGEXP pattern: ${pattern}, expected: ${expected}, actual: ${actual}"
    dnsprop::record.compare_regexp "$actual" "$pattern"
  elif [[ "$expected" =~ LIKE\'(.*)\' ]]; then
    pattern="${BASH_REMATCH[1]}"
    dnsprop::log::debug "LIKE pattern: ${pattern}, expected: ${expected}, actual: ${actual}"
    dnsprop::record.compare_like "$actual" "$pattern"
  elif [[ "$expected" =~ WILDCARD\'(.*)\' ]]; then
    wildcard_pattern="${BASH_REMATCH[1]}"
    dnsprop::log::debug "WILDCARD pattern: ${pattern}, expected: ${expected}, actual: ${actual}"
    dnsprop::record.compare_wildcard "$actual" "$wildcard_pattern"
  elif [[ "$expected" =~ CIDR\'(.*)\' ]]; then
    cidr_pattern="${BASH_REMATCH[1]}"
    dnsprop::log::debug "CIDR pattern: ${pattern}, expected: ${expected}, actual: ${actual}"
    dnsprop::record.compare_cidr "$actual" "$cidr_pattern"
  elif [[ "$expected" =~ ^(.*)!=\'(.*) ]]; then
    # elif [[ "$expected" =~ ^!=\'(.*)\' ]]; then
    string="${BASH_REMATCH[2]}"
    dnsprop::log::debug "STRING match != : string: ${string}, expected: ${expected}, actual: ${actual}"
    dnsprop::record.compare_string "$actual" "$string" "ne"
  # elif [[ "$expected" =~ ^(.*)'='(.*) ]]; then
  elif [[ "$expected" =~ ^=\'(.*)\' ]]; then
    string="${BASH_REMATCH[1]}"
    dnsprop::log::debug "STRING match '=' : string: ${string}, expected: ${expected}, actual: ${actual}"
    dnsprop::record.compare_string "$actual" "$string" "eq"
  else
    # Default to simple string comparison if no operator is specified
    dnsprop::record.compare_string "$actual" "$expected" "eq"
  fi

  matching=$?

  if [[ $matching -eq 0 ]]; then
    dnsprop::log::debug "Expected value: ${expected} matches actual value: ${actual}"
    return 0
  else
    dnsprop::log::debug "Expected value: ${expected} does not match actual value: ${actual}"
    return 1
  fi

}

# Function: dnsprop::record.dig
# Description: Queries a DNS server for a specific DNS record type of a given domain.
# Parameters:
#   $1: The domain to query.
#   $2: The record type to query. Default is "A".
#   $3: The IP address of the DNS server to query.
# Returns:
#   The DNS record value.
# Example:
#   dnsprop::record.dig "example.com" "A" "8.8.8.8" # Output:
# TODO:
#  - @TODO Add support for other record types (CNAME, TXT, SRV, MX)? (already implemented?)
#  - @TODO implement the DNSProp options like -fast and -retries=3
dnsprop::record.dig() {
  local domain="$1"
  local record_type="${2:-"A"}"
  local dns_server="${3:-"8.8.8.8"}"

  # local options=("+short") # @TODO test if this works
  local options=()

  if [[ -z "$dns_server" ]]; then
    options=("$domain" "$record_type" +short)
  else
    options=("@$dns_server" "$domain" "$record_type" +short)
  fi

  dig "${options[@]}"
}
