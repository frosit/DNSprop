#!/bin/bash

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
#
# @TODO document the constants, options, and environment variables

__DNSPROP_OK=0
__DNSPROP_NOK=1

__DNSPROP_RETURN_TRUE=0
__DNSPROP_RETURN_FALSE=1

# __DNSPROP_LOG_DIR="$HOME/.dnsprop/logs"
__DNSPROP_LOG_DIR=${DNSPROP_LOG_DIR:-"/tmp/"} # @TODO different default dir
__DNSPROP_LOG_FORMAT="[{TIMESTAMP}] {LEVEL}: {MESSAGE}"
__DNSPROP_LOG_LEVEL=${DNSPROP_LOG_LEVEL:-4}

__DNSPROP_LOG_TIMESTAMP="%T"
__DNSPROP_LOG_FILE=${DNSPROP_LOG_FILE:-"dnsprop.log"}

__DNSPROP_VERBOSE=${DNSPROP_VERBOSE:-0}
__DNSPROP_DEBUG=${DNSPROP_DEBUG:-0}

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
