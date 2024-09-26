#!/bin/bash

# Script: utils.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

dnsprop::env::get() {
  echo "${DNSPROP_ENV:-}"
}

dnsprop::env::is_dev() {
  [[ "$(dnsprop::env::get)" == "dev" ]]
}

dnsprop::env::is_test() {
  [[ "$(dnsprop::env::get)" == "test" ]]
}

# Checks if the current environment is production.
# Returns 0 (true) if the environment is production, otherwise returns 1 (false).
dnsprop::env::is_prod() {
  [[ "$(dnsprop::env::get)" == "prod" ]]
}

dnsprop::env::is_build_mode() {
  [[ "${DNSPROP_IS_BUILD}" == "true" ]]
}

dnsprop::env::dump() {
  echo "DNSPROP_ENV: $(dnsprop::env::get)"
  echo "DNSPROP_IS_BUILD: ${DNSPROP_IS_BUILD}"
  echo "Log level: ${__DNSPROP_LOG_LEVELS[$__DNSPROP_LOG_LEVEL]}"
}
