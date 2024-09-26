Docblocks
=========

* [Documentation standards](https://google.github.io/styleguide/shellguide.html)


# Google example

```shell
#######################################
# Get configuration directory.
# Globals:
#   SOMEDIR
# Arguments:
#   None
# Outputs:
#   Writes location to stdout
#######################################
function get_dir() {
  echo "${SOMEDIR}"
}
```

# Other example
See example

```shell
#!/bin/bash

# Script: example_script.sh
# Description: This script demonstrates how to use docblocks in a Bash script.
# Usage: ./example_script.sh [options]
# Options:
#   -h, --help    Show this help message and exit.
#   -v, --version Show script version.
# Author: Your Name
# Date: YYYY-MM-DD
# Version: 1.0.0

# Function: greet
# Description: Prints a greeting message.
# Parameters:
#   $1 - The name of the person to greet.
# Returns:
#   None
greet() {
  local name="$1"
  echo "Hello, $name!"
}

# Function: add
# Description: Adds two numbers and prints the result.
# Parameters:
#   $1 - The first number.
#   $2 - The second number.
# Returns:
#   The sum of the two numbers.
add() {
  local num1="$1"
  local num2="$2"
  echo "$((num1 + num2))"
}

# Main script logic
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: ./example_script.sh [options]"
  echo "Options:"
  echo "  -h, --help    Show this help message and exit."
  echo "  -v, --version Show script version."
  exit 0
elif [[ "$1" == "-v" || "$1" == "--version" ]]; then
  echo "example_script.sh version 1.0.0"
  exit 0
fi

# Example usage of functions
greet "World"
result=$(add 3 5)
echo "3 + 5 = $result"
```