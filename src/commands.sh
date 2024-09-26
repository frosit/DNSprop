#!/bin/bash

# Script: cli.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

# Start DNSProp in monitoring mode
dnsprop::commands.monitor() {
  echo -e "===== MONITOR ====="
}

# Start DNSProp in checking mode
dnsprop::commands.check() {

  local domains=()
  local options=()

  domains=("${DNSPROP_ARGS[@]}")

  for record in "${domains[@]}"; do
    local record_type=$(dnsprop::record.get_part "$record" "record_type")
    local record_domain=$(dnsprop::record.get_part "$record" "domain")
    local record_expected_value=$(dnsprop::record.get_part "$record" "expected_value")

    echo -e "Record to parse: $record"
    echo -e "Record Type: $record_type"
    echo -e "Record Domain: $record_domain"
    echo -e "Record Expected Value: $record_expected_value"
    echo -e "===="
  done

  dnsprop::log::info "Checking DNS propagation..."
}

# Show information about DNSProp
dnsprop::commands.info() {
  echo -e "===== INFO ====="

  echo -e "Feature not implemented yet..."
}

# Update DNSProp to the latest version
dnsprop::commands.update() {
  echo -e "===== UPDATE ====="
  echo -e "Feature not implemented yet..."
}
