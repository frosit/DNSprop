#!/bin/bash

# DNSProp main function

# Whether the script is build/compiled
DNSPROP_IS_BUILD="${DNSPROP_IS_BUILD:-false}"

# DNSProp environment (dev, test, prod)
DNSPROP_ENV="${DNSPROP_ENV:-dev}"

__DNSPROP_COMMANDS=()
CLI_COMMANDS=()

dnsprop_add_command() {
  local key=$1
  local value=$2
  CLI_COMMANDS["$key"]="$value"
}

dnsprop_get_command() {
  local key=$1
  echo "${CLI_COMMANDS[$key]}"
}

dnsprop_list_commands() {
  for key in "${!cli_commands[@]}"; do
    echo "Key: $key, Value: ${cli_commands[$key]}"
  done
}

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
    source "$(dirname "$0")/commands/commands.sh"
  fi

  # if debug enabled
  if [[ "${DNSPROP_DEBUG:-false}" == true ]]; then
    _dnsprop_debug_info
  fi

  if [[ " ${DNSPROP_PARAMS[*]} " == *" -info "* ]]; then
    dnsprop::commands.info
  fi

  if [[ " ${DNSPROP_PARAMS[*]} " == *" -info "* ]]; then
    dnsprop::commands.info
  fi
}

# ------------------------------------------------------------------------------

# Load CLI
if ! _dnsprop_is_build_mode; then
  source "$(dirname "$0")/cli.sh"
fi

# Execute main function
_dnsprop_parse_args "$@"

main
