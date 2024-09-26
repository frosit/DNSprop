#!/bin/bash

# Script: commands.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

# declare -A loaded_commands
loaded_commands=()

# declare -A cli_commands

# dnsprop_add_command() {
#   local key=$1
#   local value=$2
#   cli_commands["$key"]="$value"
# }

# dnsprop_get_command() {
#   local key=$1
#   echo "${cli_commands[$key]}"
# }

# dnsprop_list_commands() {
#   for key in "${!cli_commands[@]}"; do
#     echo "Key: $key, Value: ${cli_commands[$key]}"
#   done
# }

# @TODO not working as expected
dnsprop::commands:add_command() {
  local command_name="$1"
  local command_function="$2"
  __DNSPROP_COMMANDS["${command_name}"]="${command_function}"
  loaded_commands["${command_name}"]="${command_function}"
}

# @TODO not working as expected
dnsprop::get::command() {
  local command_name=$1
  # echo "${__DNSPROP_COMMANDS["${command_name}"]}"
  echo "${loaded_commands[$command_name]}"
}

# @TODO not working as expected
dnsprop::commands::run() {
  local command_name="$1"
  local command_function
  command_function="$(dnsprop::get::command "${command_name}")"
  if [[ -z "${command_function}" ]]; then
    dnsprop::log::error "Command not found: ${command_name}"
    exit 1
  fi
  shift
  "${command_function}" "$@"
}

# Function: utils_load
# Description: Loads utility functions script files in the correct order when not compiled.
# Returns: None
commands_load() {
  local script_dir
  local script_files
  script_dir="$(dirname "$0")"
  script_files=(
    "info.sh"
    "check.sh"
  )

  for script_file in "${script_files[@]}"; do
    if [[ ! -f "${script_dir}/commands/${script_file}" ]]; then
      echo -e "error" "File not found: ${script_dir}/commands/${script_file}"
      exit 1
    fi

    echo -e "loaded command" "${script_file}"

    # shellcheck source=/dev/null
    source "${script_dir}/commands/${script_file}"
  done
}

# Function: utils_init
# Description: Loads utility functions.
# Returns: None
commands_init() {

  # if env not set, exit
  if [[ -z "${DNSPROP_IS_BUILD:-}" ]]; then
    echo -e "error" "DNSPROP_IS_BUILD is not set"
    exit 1
  fi

  # if not build mode, load utility functions
  if [[ "${DNSPROP_IS_BUILD:-false}" = false ]]; then
    commands_load
  fi

  # Check if info exists in

  dnsprop::log::debug "commands autoloaded"
}

# Execute main function
commands_init
