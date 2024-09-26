#!/bin/bash

# DNSProp main function

# Whether the script is build/compiled
DNSPROP_IS_BUILD="${DNSPROP_IS_BUILD:-false}"

# DNSProp environment (dev, test, prod)
DNSPROP_ENV="${DNSPROP_ENV:-dev}"

# Function: _dnsprop_is_build_mode
# Description: Check if the script is build/compiled
# Returns: None
_dnsprop_is_build_mode() {
  [[ "${DNSPROP_IS_BUILD}" == "true" ]]
}

_dnsprop_script() {
  echo "$(basename "$0")"
}

# Function: _dnsprop_get_env
# Description: Get the DNSProp environment
# Returns: None
_dnsprop_get_env() {
  echo "${DNSPROP_ENV:-}"
}

get_dnsprop_env() {
  echo "${DNSPROP_ENV:-}"
  [[ "$BUILD_MODE" == "true" ]]
}

is_dnsprop_dev() {
  [[ "$(get_dnsprop_env)" == "dev" ]]
}

is_dnsprop_test() {
  [[ "$(get_dnsprop_env)" == "test" ]]
}

is_dnsprop_prod() {
  [[ "$(get_dnsprop_env)" == "prod" ]]
}

if ! _dnsprop_is_build_mode; then
  source "$(dirname "$0")/requirements.sh"
  source "$(dirname "$0")/utils.sh"
fi

main() {
  echo "Running main script logic..."
  # util_function
  dnsprop::log::info "This is an info message"
}

# Execute main function
main
