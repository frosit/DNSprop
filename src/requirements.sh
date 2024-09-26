#!/bin/bash

# Script: requirements.sh
# Description: Checks system requirements for DNSprop
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------
# Constants

__DNSPROP_OK=0
__DNSPROP_NOK=1

__DNSPROP_RETURN_TRUE=0
__DNSPROP_RETURN_FALSE=1

# __DNSPROP_LOG_DIR="$HOME/.dnsprop/logs"
__DNSPROP_LOG_DIR="/Users/frosit/git/DNSprop"
__DNSPROP_LOG_FORMAT="[{TIMESTAMP}] {LEVEL}: {MESSAGE}"
# __DNSPROP_LOG_LEVEL=5 # Defaults to INFO
__DNSPROP_LOG_LEVEL=8
__DNSPROP_LOG_TIMESTAMP="%T"
__DNSPROP_LOG_FILE="dnsprop.log"

__DNSPROP_VERBOSE=1
__DNSPROP_DEBUG=1

# Log levels
__DNSPROP_LOG_LEVEL_ALL=8
__DNSPROP_LOG_LEVEL_DEBUG=6
__DNSPROP_LOG_LEVEL_ERROR=2
__DNSPROP_LOG_LEVEL_FATAL=1
__DNSPROP_LOG_LEVEL_INFO=5
__DNSPROP_LOG_LEVEL_NOTICE=4
__DNSPROP_LOG_LEVEL_OFF=0
__DNSPROP_LOG_LEVEL_TRACE=7
__DNSPROP_LOG_LEVEL_WARNING=3

__DNSPROP_LOG_LEVELS=(
  [${__DNSPROP_LOG_LEVEL_OFF}]="OFF"
  [${__DNSPROP_LOG_LEVEL_FATAL}]="FATAL"
  [${__DNSPROP_LOG_LEVEL_ERROR}]="ERROR"
  [${__DNSPROP_LOG_LEVEL_WARNING}]="WARNING"
  [${__DNSPROP_LOG_LEVEL_NOTICE}]="NOTICE"
  [${__DNSPROP_LOG_LEVEL_INFO}]="INFO"
  [${__DNSPROP_LOG_LEVEL_DEBUG}]="DEBUG"
  [${__DNSPROP_LOG_LEVEL_TRACE}]="TRACE"
  [${__DNSPROP_LOG_LEVEL_ALL}]="ALL"
)

__DNSPROP_COLORS_ESCAPE="\033["
__DNSPROP_COLORS_RESET="${__DNSPROP_COLORS_ESCAPE}0m"
__DNSPROP_COLORS_DEFAULT="${__DNSPROP_COLORS_ESCAPE}39m"
__DNSPROP_COLORS_BLACK="${__DNSPROP_COLORS_ESCAPE}30m"
__DNSPROP_COLORS_RED="${__DNSPROP_COLORS_ESCAPE}31m"
__DNSPROP_COLORS_GREEN="${__DNSPROP_COLORS_ESCAPE}32m"
__DNSPROP_COLORS_YELLOW="${__DNSPROP_COLORS_ESCAPE}33m"
__DNSPROP_COLORS_BLUE="${__DNSPROP_COLORS_ESCAPE}34m"
__DNSPROP_COLORS_MAGENTA="${__DNSPROP_COLORS_ESCAPE}35m"
__DNSPROP_COLORS_CYAN="${__DNSPROP_COLORS_ESCAPE}36m"
__DNSPROP_COLORS_LIGHT_GRAY="${__DNSPROP_COLORS_ESCAPE}37m"
__DNSPROP_COLORS_BG_DEFAULT="${__DNSPROP_COLORS_ESCAPE}49m"
__DNSPROP_COLORS_BG_BLACK="${__DNSPROP_COLORS_ESCAPE}40m"
__DNSPROP_COLORS_BG_RED="${__DNSPROP_COLORS_ESCAPE}41m"
__DNSPROP_COLORS_BG_GREEN="${__DNSPROP_COLORS_ESCAPE}42m"
__DNSPROP_COLORS_BG_YELLOW="${__DNSPROP_COLORS_ESCAPE}43m"
__DNSPROP_COLORS_BG_BLUE="${__DNSPROP_COLORS_ESCAPE}44m"
__DNSPROP_COLORS_BG_MAGENTA="${__DNSPROP_COLORS_ESCAPE}45m"
__DNSPROP_COLORS_BG_CYAN="${__DNSPROP_COLORS_ESCAPE}46m"
__DNSPROP_COLORS_BG_WHITE="${__DNSPROP_COLORS_ESCAPE}47m"

# ------------------------------------------------------------------------------
# Logging

# Function: dnsprop::log
# Description: Logs a message.
# Parameters:
#   $2 - The message to log.
# Returns: None
dnsprop::log() {
  dnsprop::log.log "${__DNSPROP_LOG_LEVEL_INFO}" "$1"
}

# Function: dnsprop::log
# Description: Logs a message.
# Parameters:
#   $1 - The log level.
#   $2 - The message to log.
# Returns: None
dnsprop::log.log() {
  local level=$1
  local message=$2
  local log_file=${3:-${__DNSPROP_LOG_FILE}}
  local timestamp
  local output
  local output_fmt
  local msg_color

  if [[ "${level}" -gt "${__DNSPROP_LOG_LEVEL}" ]]; then
    return "${__DNSPROP_OK}"
  fi

  log_file="${__DNSPROP_LOG_DIR}/${log_file}"
  timestamp=$(date +"${__DNSPROP_LOG_TIMESTAMP}")

  # Set the color of the message based on the log level
  case "${level}" in
  "${__DNSPROP_LOG_LEVEL_FATAL}")
    msg_color="${__DNSPROP_COLORS_RED}"
    ;;
  "${__DNSPROP_LOG_LEVEL_ERROR}")
    msg_color="${__DNSPROP_COLORS_MAGENTA}"
    ;;
  "${__DNSPROP_LOG_LEVEL_WARNING}")
    msg_color="${__DNSPROP_COLORS_YELLOW}"
    ;;
  "${__DNSPROP_LOG_LEVEL_NOTICE}")
    msg_color="${__DNSPROP_COLORS_CYAN}"
    ;;
  "${__DNSPROP_LOG_LEVEL_INFO}")
    msg_color="${__DNSPROP_COLORS_GREEN}"
    ;;
  "${__DNSPROP_LOG_LEVEL_DEBUG}")
    msg_color="${__DNSPROP_COLORS_BLUE}"
    ;;
  "${__DNSPROP_LOG_LEVEL_TRACE}")
    msg_color="${__DNSPROP_COLORS_LIGHT_GRAY}"
    ;;
  *)
    msg_color="${__DNSPROP_COLORS_RESET}"
    ;;
  esac

  # Colorize the message
  message_colorized="${msg_color}${message}${__DNSPROP_COLORS_RESET}"

  # Build message with and without color
  output="${__DNSPROP_LOG_FORMAT}"
  output_fmt="${__DNSPROP_LOG_FORMAT}" # terminal output, with colors

  output="${output//\{TIMESTAMP\}/${timestamp}}"
  output_fmt="${output_fmt//\{TIMESTAMP\}/${timestamp}}"

  output="${output//\{MESSAGE\}/${message}}"
  output_fmt="${output_fmt//\{MESSAGE\}/${message_colorized}}"

  output="${output//\{LEVEL\}/${__DNSPROP_LOG_LEVELS[$level]}}"
  output_fmt="${output_fmt//\{LEVEL\}/${__DNSPROP_LOG_LEVELS[$level]}}"

  # write to log
  echo -e "${output}" >>"${log_file}"

  # write to terminal
  if [[ "${__DNSPROP_VERBOSE}" -eq 1 ]]; then
    echo -e "${output_fmt}"
  fi

  return "${__DNSPROP_OK}"
}

# Function: dnsprop::log::error
# Description: Logs an error message.
# Parameters:
#   $1 - The error message to log.
# Returns: None
dnsprop::log::error() {
  local message=$*
  dnsprop::log.log "${__DNSPROP_LOG_LEVEL_ERROR}" "${message}"
}

# Function: dnsprop::log::info
# Description: Logs an informational message.
# Parameters:
#   $1 - The informational message to log.
# Returns: None
function dnsprop::log::info() {
  local message=$*
  dnsprop::log.log "${__DNSPROP_LOG_LEVEL_INFO}" "${message}"
}

# Function: dnsprop::log::debug
# Description: Logs a debug message.
# Parameters:
#   $1 - The debug message to log.
# Returns: None
dnsprop::log::debug() {
  local message=$*
  dnsprop::log.log "${__DNSPROP_LOG_LEVEL_DEBUG}" "${message}"
}

# Function: dnsprop::log::warning
# Description: Logs a warning message.
# Parameters:
#   $1 - The warning message to log.
# Returns: None
dnsprop::log::warning() {
  local message=$*
  dnsprop::log.log "${__DNSPROP_LOG_LEVEL_WARNING}" "${message}"
}

# Function: dnsprop::log::success
# Description: Logs a success message.
# Parameters:
#   $1 - The success message to log.
# Returns: None
dnsprop::log::success() {
  local message=$*
  dnsprop::log.log "${__DNSPROP_LOG_LEVEL_SUCCESS}" "${message}"
}

# ------------------------------------------------------------------------------

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
check_requirements() {
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
