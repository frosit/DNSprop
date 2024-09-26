#!/bin/bash

# ------------------------------------------------------------------------------
# Logging
# ------------------------------------------------------------------------------
# @TODO split log as write and log as output functions
# @TODO add log trace, debug etc.
# @TODO perhaps use stderr

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

  # Create logs dir
  if [[ ! -d "${__DNSPROP_LOG_DIR}" ]]; then
    if ! mkdir -p "${__DNSPROP_LOG_DIR}" &>/dev/null; then
      echo -e "[DNSPROP] Error creating log directory: ${__DNSPROP_LOG_DIR}"
      return "${__DNSPROP_NOK}"
    else
      if [[ "${__DNSPROP_VERBOSE}" = 1 ]]; then
        echo -e "[DNSPROP] Created log directory: ${__DNSPROP_LOG_DIR}"
      fi
    fi
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
dnsprop::log::info() {
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
