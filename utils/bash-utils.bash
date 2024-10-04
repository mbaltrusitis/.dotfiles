# Bash utility functions.
#
# This file is meant to be sourced from other bash scripts.

# logger helpers
LOG_DEBUG() { printf "\e[0;34m[DEBUG] %s\e[0m\n" "$1" ; }
LOG_INFO() { printf "\e[0;32m[INFO]  %s\e[0m\n" "$1" ; }
LOG_ERROR() { printf "\e[0;31m[ERROR] %s\e[0m\n" "$1" ; }
LOG_WARNING() { printf "\e[0;33m[WARN]  %s\e[0m\n" "$1" ; }
