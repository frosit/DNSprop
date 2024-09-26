#!/bin/bash

# Script: info.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

function dnsprop::commands.check() {
  local domains=()
  local options=()

  dnsprop::log::info "Checking DNS propagation..."

}

dnsprop_add_command "check" "dnsprop::commands:check"
dnsprop::commands:add_command "check" "dnsprop::commands:check"
