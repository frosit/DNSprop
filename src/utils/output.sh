#!/bin/bash

# Script: output.sh
# Description: Loader for all utility functions
# Author: Fabio Ros
# Date: YYYY-MM-DD
# Version: 1.0.0

# ------------------------------------------------------------------------------

# Initialize an empty table
table=()
table_format="%-25s %-15s %-20s %-s\t"
table_format_colspan="%-40s %-20s %-s\t"

# Formats
table_format_no_status="%-25s %-15s %-20s\t"
table_format_status="%-25s %-15s %-20s %-s\t"
table_format_status_cg="%-25s %-15s %-20s ${__DNSPROP_COLORS_GREEN}%-s${__DNSPROP_COLORS_RESET}\t"
table_format_status_cr="%-25s %-15s %-20s ${__DNSPROP_COLORS_RED}%-s${__DNSPROP_COLORS_RED}\t"

# selected format
table_format=$table_format_status

# Function to write output
dnsprop::output.write() {
  local message="$1"
  echo "$message"
}

dnsprop::output::table_reset() {
  table=()
}

# Function to add a header to the table
dnsprop::output.table_add_header() {
  local header=("$@")

  # table+=("$(printf "%-25s %-15s %-20s %-3s\t" "${header[@]}")")   # status
  # table+=("$(printf "%-25s %-15s %-20s\t" "${header[@]}")") # no status
  table+=("$(printf "%-25s %-15s %-20s\t" "${header[@]}")") # no status
}

dnsprop::output.table_add_row_success() {
  local row=("$@")
  table+=("$(printf "%-25s %-15s ${__DNSPROP_COLORS_GREEN}%-s${__DNSPROP_COLORS_RESET}\t" "${row[@]}")")
}

# Function to add a row to the table
dnsprop::output.table_add_row() {
  local row=("$@")
  # table+=("$(printf "%-25s %-15s %-20s ${__DNSPROP_COLORS_YELLOW}%-3s${__DNSPROP_COLORS_RESET}\t" "${row[@]}")")
  # printf "${__DNSPROP_COLORS_YELLOW}%-3s${__DNSPROP_COLORS_RESET}\n" "$row"
  # table+=("$(printf "%-25s %-15s %-20s ${__DNSPROP_COLORS_YELLOW}%-3s${__DNSPROP_COLORS_RESET}\t" "${row[@]}")")
  table+=("$(printf "%-25s %-15s %-20s %s\t" "${row[@]}")")
}

# Table row spans multiple columns
# @TODO: Fix the color
dnsprop::output.table_add_row_span_success() {
  local first_field="$1"
  local span_field="$2"
  local status_field="${3:-}"

  # Table row with green status color
  table+=("$(printf "%-40s  %-20s ${__DNSPROP_COLORS_GREEN}%s${__DNSPROP_COLORS_RESET}\t" "$first_field" "$span_field" "$status_field")")
}

# Function to add a row with a field that spans multiple columns
dnsprop::output.table_add_row_span() {
  local first_field="$1"
  local span_field="$2"
  local status_field="${3:-}"
  table+=("$(printf "%-40s  %-20s %s\t" "$first_field" "$span_field" "$status_field")")
}

# Function to display the table
dnsprop::output.table_display() {
  local IFS=$'\n'
  for row in "${table[@]}"; do
    printf "%s\n" "$row"
  done
}

# Function to display the table with color
dnsprop::output.table_display_colored() {
  local IFS=$'\n'
  local is_header=true
  for row in "${table[@]}"; do
    if $is_header; then
      printf "${__DNSPROP_COLORS_YELLOW}%s${__DNSPROP_COLORS_RESET}\n" "$row"
      is_header=false
    else
      printf "%s\n" "$row"
    fi
  done
}

# ------------------------------------------------------------------------------

# Function to display colored text
dnsprop::output.color() {
  local color="$1"
  local message="$2"
  case "$color" in
  red)
    echo -e "\033[31m${message}\033[0m"
    ;;
  green)
    echo -e "\033[32m${message}\033[0m"
    ;;
  yellow)
    echo -e "\033[33m${message}\033[0m"
    ;;
  blue)
    echo -e "\033[34m${message}\033[0m"
    ;;
  magenta)
    echo -e "\033[35m${message}\033[0m"
    ;;
  cyan)
    echo -e "\033[36m${message}\033[0m"
    ;;
  *)
    echo "$message"
    ;;
  esac
}

# Function: dnsprop::log::writeln
# Description: Logs a message with a newline.
# Parameters:
#   $1 - The message to log.
# Returns: None
dnsprop::output.writeln() {
  local message=$1
  echo -e "${message}"
}

dnsprop::output.key_value() {
  local key=$1
  local message=$2
  echo -e "${__DNSPROP_COLORS_YELLOW}${key}${__DNSPROP_COLORS_RESET}: ${message}"
}

dnsprop::output.bullet_key_value() {
  local key=$1
  local message=$*
  echo -e "* ${__DNSPROP_COLORS_YELLOW}${key}${__DNSPROP_COLORS_RESET}: ${message}"
}

dnsprop::output.bullet() {
  local key=$1
  local message=$2
  echo -e "* ${message}"
}

# Function: dnsprop::log.title
# Description: Logs a title.
# Parameters:
#   $1 - The title to log.
dnsprop::output.title2() {
  local key="====="
  local message=$1
  echo -e "${__DNSPROP_COLORS_CYAN}${key}${__DNSPROP_COLORS_RESET} ${message} ${__DNSPROP_COLORS_CYAN}${key}${__DNSPROP_COLORS_RESET}"
}

dnsprop.output.colorcode() {
  local color="$1"
  local message="$2"
  case "$color" in
  red)
    echo -e "\033[31m${message}\033[0m"
    ;;
  green)
    echo -e "\033[32m${message}\033[0m"
    ;;
  yellow)
    echo -e "\033[33m${message}\033[0m"
    ;;
  blue)
    echo -e "\033[34m${message}\033[0m"
    ;;
  magenta)
    echo -e "\033[35m${message}\033[0m"
    ;;
  cyan)
    echo -e "\033[36m${message}\033[0m"
    ;;
  *)
    echo "$message"
    ;;
  esac
}

dnsprop::output.list() {
  local items=("$@")

  for item in "${items[@]}"; do
    echo -e "* ${item}"
  done
}

dnsprop::output.seperator() {
  local padding_char="${1:-"~"}"
  local text="${2:-}"
  echo -e ""
  dnsprop::output.title "$text" "blue" "$padding_char"
  echo -e ""
}

dnsprop::output.subtitle() {
  dnsprop::output.title "$1" "magenta" "-"
}

dnsprop::output.title() {
  local title="$1"
  local color="${2:-"cyan"}"
  local width=50 # Set the desired width for the title line
  local padding_char="${3:-"="}"

  # ANSI color codes
  local color_reset="\033[0m"
  local color_red="\033[31m"
  local color_green="\033[32m"
  local color_yellow="\033[33m"
  local color_blue="\033[34m"
  local color_magenta="\033[35m"
  local color_cyan="\033[36m"
  local color_bold="\033[1m"

  # Determine the color code
  local color_code=""
  case "$color" in
  red) color_code="$color_red" ;;
  green) color_code="$color_green" ;;
  yellow) color_code="$color_yellow" ;;
  blue) color_code="$color_blue" ;;
  magenta) color_code="$color_magenta" ;;
  cyan) color_code="$color_cyan" ;;
  bold) color_code="$color_bold" ;;
  *) color_code="" ;;
  esac

  # local color_code=$(dnsprop.output.colorcode "$color" "")

  # Calculate the length of the title and the padding needed
  local title_length=${#title}
  local padding_length=$(((width - title_length - 2) / 2))

  # Create the padding
  local padding=$(gprintf "%*s" "$padding_length" | tr ' ' "$padding_char")

  echo -e "${color_code}${padding}${color_bold} ${title} ${color_reset}${color_code}${padding}${color_reset}"
  echo -e ""
}
