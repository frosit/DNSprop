#!/bin/bash

# Script: requirements.sh
# Description: Checks system requirements for DNSprop
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# Main system requirements
__DNSPROP_REQUIREMENTS=(bash grep dig awk sed bc)

# Development requirements
__DNSPROP_REQUIREMENTS_DEV=(bats)

# Check for minimal bash version
__DNSPROP_REQUIRED_BASH_VERSION=4.0

# Function: _get_bash_version
# Description: Retrieves the current Bash version.
# Parameters: None
# Returns: The current Bash version.
_get_bash_version() {
  bash --version | head -n 1 | awk '{print $4}'
}

# Function: _is_bash_version_meeting_required_version
# Description: Checks if the current Bash version meets the required version.
# Parameters: None
# Returns: 0 if the version meets the requirement, 1 otherwise.
_is_bash_version_meeting_required_version() {
  local version
  version=$(_get_bash_version)
  local major_version
  major_version=$(echo "$version" | awk -F. '{print $1}')
  if [[ $major_version -ge $required_bash_version ]]; then
    return 0
  else
    return 1
  fi
}

# Function: check_bash_version
# Description: Checks if the current Bash version meets the required version and exits if not.
# Parameters: None
# Returns: None
check_bash_version() {
  _is_bash_version_meeting_required_version

  if [[ $? -ne 0 ]]; then
    local current_bash_version=$(_get_bash_version)
    local bash_path=$(which bash)
    echo "Bash version $required_bash_version or higher is required. Current version: $current_bash_version at $bash_path"
    exit 1
  fi
}

# Get current OS
current_os=$(uname -s) # @todo test osx:Darwin, linux:Linux

if [[ $current_os == "Windows" ]]; then
  echo "Windows is not supported"
  exit 1
fi

# Darwin has other params for grep, so we need to use ggrep which is a GNU grep installed via brew install grep
# @TODO add to docs
# @TODO show message on how to install ggrep
if [[ $current_os == "Darwin" ]]; then

  # Add GNU tools to requirements
  __DNSPROP_REQUIREMENTS+=(brew ggrep gawk)

  # Check for installed packages with brew
  __DNSPROP_REQUIREMENTS_BREW=(gnu-sed gnu-grep awk bash coreutils) # @TODO fix brew deps

  # Add command aliases to fix GNU / BSD
  alias grep='ggrep'
  alias awk='gawk'
  alias sed='gsed'
fi

# Check if a requirement is installed
#
# Function: is_installed
# Description: Checks if a given command is available in the system.
# Parameters:
#   $1 - The name of the command to check.
# Returns:
#   0 if the command is found, 1 otherwise.
is_installed() {
  command -v "$1" &>/dev/null
}

# Check requirements
#
# Function: check_requirements
# Description: Iterates over the list of required commands and checks if each one is installed.
#              If a command is not found, it prints an error message and exits the script.
# Parameters: None
# Returns: None
function dnsprop::check_requirements() {
  local requirements=()
  requirements+=("${__DNSPROP_REQUIREMENTS[@]}")

  for requirement in "${requirements[@]}"; do
    if ! is_installed "$requirement"; then
      echo "Requirement not found: $requirement"

      if [[ $current_os == "Linux" ]]; then
        echo "You can install it using: sudo apt-get install $requirement"
      fi

      # Show about brew GNU tools
      if [[ $current_os == "Darwin" ]]; then
        echo "You can install it using: brew install $requirement"
      fi
      return 0
    fi
  done
}
