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
# Usage: _dnsprop_add_arg <arg>
# Returns:
#   None
_dnsprop_add_arg() {
  DNSPROP_ARGS+=("$@")
}

# Add parameter to params array
# Usage: _dnsprop_add_param <param>
# Returns:
#   None
_dnsprop_add_param() {
  DNSPROP_PARAMS+=("$@")
}

# Show usage information
# Usage: _dnsprop_usage
# Returns:
#   None
# TODO:
#  @TODO Implement all options
#  @TODO document all options
_dnsprop_usage() {
  echo "Usage: $0 [options]"
  echo "Commands:"
  echo "  -monitor                Start DNSProp in monitoring mode, checking propagation every x seconds, use together with --monitor-interval"
  echo "  -check (default)        Check DNS propagation for a domain"
  echo "  -info                   Show information about DNSProp (environment, server, settings)"
  echo "  -update                 Update DNSProp to the latest version"
  echo "Options:"
  echo "  -e, --env=<env>         Set the environment (dev, test, prod)"
  echo "  -v, --verbose           Enable verbose mode"
  echo "  -d, --debug             Enable debug mode"
  echo "  --log-level=<level>     Set the log level (0-8)"
  echo "Options for dig:"
  echo "  --norecurse             Applies +norecurse to the query"
  echo "  --timeout=2s            Applies +timeout=2"
  echo "  --fast                  Applies +timeout=2 and +tries=1"
  echo "  --dns-servers=<servers> Allows to specify DNS servers to use"
  echo "  --server-names=<names>  Allows to specify DNS server names"
  echo "Options for monitor:"
  echo "  --monitor-interval=30   Set the interval in seconds for the monitoring mode"
  echo "  -h, --help              Show this help message"
  exit 1
}

# Parse command line arguments
# Usage: _dnsprop_parse_args "$@"
# Returns:
#   None
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
