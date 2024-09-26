#!/bin/bash

# DNSProp main function

# Whether the script is build/compiled
DNSPROP_IS_BUILD="${DNSPROP_IS_BUILD:-false}"

# DNSProp environment (dev, test, prod)
DNSPROP_ENV="${DNSPROP_ENV:-dev}"

_dnsprop_is_build_mode() {
  [[ "${DNSPROP_IS_BUILD}" == "true" ]]
}

_dnsprop_env() {
  echo "${DNSPROP_ENV}"
}

_dnsprop_debug_info() {
  echo "DNSPROP_IS_BUILD: ${DNSPROP_IS_BUILD}"
  echo "DNSPROP_ENV: ${DNSPROP_ENV}"
  echo "DNSPROP_VERBOSE: ${DNSPROP_VERBOSE}"
  echo "DNSPROP_DEBUG: ${DNSPROP_DEBUG}"
  echo "DNSPROP_LOG_LEVEL: ${DNSPROP_LOG_LEVEL}"
  echo "DNSPROP_PARAMS: ${DNSPROP_PARAMS[*]}"
  echo "DNSPROP_ARGS: ${DNSPROP_ARGS[*]}"
}

# ------------------------------------------------------------------------------
main() {

  if ! _dnsprop_is_build_mode; then
    source "$(dirname "$0")/utils/utils.sh"
  fi

  _dnsprop_debug_info

  echo "Running main script logic..."
  # util_function
  dnsprop::log::info "This is an info message"
}

# ------------------------------------------------------------------------------

# Load CLI
if ! _dnsprop_is_build_mode; then
  source "$(dirname "$0")/cli.sh"
fi

# Execute main function
_dnsprop_parse_args "$@"

main
