#!/bin/bash

# Script: pushbullet.sh
# Description: Allows to send messages to Pushbullet
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

__DNSPROP_PUSHBULLET_TOKEN=${DNSPROP_PUSHBULLET_TOKEN:-false}

dnsprop::pushbullet.push() {
  local title=${1:-"DNSPROP noticiation"}
  local message=${2}

  if [[ "$__DNSPROP_PUSHBULLET_TOKEN" == "false" ]]; then
    dnsprop::log::error "pushbullet" "No token found"
    return 1
  fi

  if [[ -z "$message" ]]; then
    dnsprop::log::error "pushbullet" "No message found"
    return 1
  fi

  if ! is_installed "curl"; then
    dnsprop::log::error "pushbullet" "curl is not installed"
    return 1
  fi

  curl -s -u $__DNSPROP_PUSHBULLET_TOKEN: -X POST https://api.pushbullet.com/v2/pushes \
    --header 'Content-Type: application/json' \
    --data-binary '{"type": "note", "title": "'"$title"'", "body": "'"$message"'"}' >/dev/null 2>&1
}
