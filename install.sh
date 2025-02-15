#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eo pipefail

# Function to print error message to stderr and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Check if CODESPACES environment variable is set to "true"
if [ "$CODESPACES" = "true" ]; then
    ./install_codespace.sh
    
# Else, check if the operating system is Linux
elif [ "$(uname)" = "Linux" ]; then
    # Check if /etc/os-release exists to determine the Linux distribution
    if [ -f /etc/os-release ]; then
        # Source the os-release file to get OS information
        . /etc/os-release

        # Check if the distribution is Ubuntu or Debian
        case "$ID" in
            ubuntu|debian)
                # Check if install_linux_qemu.sh exists and is executable
                if [ -x "./install_linux_qemu.sh" ]; then
                    echo "Detected Linux distribution: $PRETTY_NAME. Executing install_linux.sh..."
                    ./install_linux_qemu.sh
                else
                    error_exit "install_linux.sh not found or not executable."
                fi
                ;;
            *)
                error_exit "Unsupported Linux distribution: $PRETTY_NAME."
                ;;
        esac
    else
        error_exit "/etc/os-release not found. Cannot determine Linux distribution."
    fi

# If neither Codespaces nor Linux, prompt an error
else
    error_exit "Operating system not supported yet."
fi
