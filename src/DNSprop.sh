#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Treat unset variables as an error and exit immediately.
set -u

# Print each command before executing it (useful for debugging).
# set -x

# Function to display usage information
usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -h, --help    Show this help message and exit"
  echo "  -v, --version Show script version"
}

# Function to display script version
version() {
  echo "your_script.sh version 1.0.0"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --help)
    usage
    exit 0
    ;;
  -v | --version)
    version
    exit 0
    ;;
  *)
    echo "Unknown option: $1"
    usage
    exit 1
    ;;
  esac
  shift
done

# Main script logic
main() {
  echo "Running main script logic..."
  # Add your script logic here
}

# Execute main function
main
