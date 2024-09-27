#!/bin/bash

# Script: utils.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

# Function: utils_load
# Description: Loads utility functions script files in the correct order when not compiled.
# Returns: None
utils_load() {
  local script_dir
  local script_files
  script_dir="$(dirname "$0")"
  script_files=(
    "env.sh"
    "consts.sh"
    "log.sh"
    "output.sh"
    "requirements.sh"
    "record.sh"
  )

  for script_file in "${script_files[@]}"; do
    if [[ ! -f "${script_dir}/utils/${script_file}" ]]; then
      echo -e "error" "File not found: ${script_dir}/utils/${script_file}"
      exit 1
    fi

    # shellcheck source=/dev/null
    source "${script_dir}/utils/${script_file}"
  done
}

# Function: utils_init
# Description: Loads utility functions.
# Returns: None
utils_init() {

  # if env not set, exit
  if [[ -z "${DNSPROP_IS_BUILD:-}" ]]; then
    echo -e "error" "DNSPROP_IS_BUILD is not set"
    exit 1
  fi

  # if not build mode, load utility functions
  if [[ "${DNSPROP_IS_BUILD:-false}" = false ]]; then
    utils_load
  fi

  dnsprop::log::debug "Utils autoloaded"
}

# Execute main function
utils_init
