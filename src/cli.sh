#!/bin/bash

# Script: cli.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

# Parameters and arguments
DNSPROP_PARAMS=()
DNSPROP_ARGS=()

# Add argument to args array
_dnsprop_add_arg() {
  DNSPROP_ARGS+=("$@")
}

# Add parameter to params array
_dnsprop_add_param() {
  DNSPROP_PARAMS+=("$@")
}

_dnsprop_usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -e, --env <env>      Set the environment (dev, test, prod)"
  echo "  -v, --verbose        Enable verbose mode"
  echo "  -d, --debug          Enable debug mode"
  echo "  --log-level <level>  Set the log level (0-8)"
  echo "  -b, --build          Run in build mode"
  exit 1
}

# Parse command line arguments
_dnsprop_parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      _dnsprop_usage
      exit 0
      ;;
    --env=*)
      DNSPROP_ENV="${1#*=}"
      shift
      ;;
    -v | -vv | -vvv | --verbose)
      DNSPROP_VERBOSE=true
      shift
      ;;
    -d | --debug)
      DNSPROP_DEBUG=true
      DNSPROP_LOG_LEVEL=7
      shift
      ;;
    --log-level=*)
      DNSPROP_LOG_LEVEL="${1#*=}"
      shift
      ;;
    -*)
      _dnsprop_add_param "$1"
      shift
      ;;
    *)
      _dnsprop_add_arg "$1"
      shift
      ;;
    esac
  done
}
