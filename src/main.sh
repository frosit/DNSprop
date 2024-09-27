#!/bin/bash

# DNSProp main function

# Whether the script is build/compiled
DNSPROP_IS_BUILD="${DNSPROP_IS_BUILD:-false}"

# DNSProp environment (dev, test, prod)
DNSPROP_ENV="${DNSPROP_ENV:-dev}"
DNSPROB_LOG_DIR="./"

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
    source "$(dirname "$0")/commands.sh"
    # source "$(dirname "$0")/commands/commands.sh"
  fi

  # @TODO load env file

  # if debug enabled
  if [[ "${DNSPROP_DEBUG:-false}" == true ]]; then
    _dnsprop_debug_info
  fi

  # Start actions
  if [[ " ${DNSPROP_PARAMS[*]} " == *" -expect "* ]]; then
    dnsprop::commands.expect
    exit 0
  fi

  if [[ " ${DNSPROP_PARAMS[*]} " == *" -monitor "* ]]; then
    dnsprop::commands.monitor
    exit 0
  fi

  if [[ " ${DNSPROP_PARAMS[*]} " == *" -info "* ]]; then
    dnsprop::commands.info
    exit 0
  fi

  if [[ " ${DNSPROP_PARAMS[*]} " == *" -update "* ]]; then
    dnsprop::commands.update
    exit 0
  fi

  if [[ ${#DNSPROP_ARGS[@]} -eq 0 ]]; then
    dnsprop::log::error "No domains to check, please provide at least one domain. See --help for more information."
    exit 1
  else
    dnsprop::commands.check
    exit 0
  fi
}

# ------------------------------------------------------------------------------

# Load CLI
if ! _dnsprop_is_build_mode; then
  source "$(dirname "$0")/cli.sh"
fi

# Execute main function
_dnsprop_parse_args "$@"

# main execution
main
