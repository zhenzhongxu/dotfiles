#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define Miniconda version and installation directory
MINICONDA_VERSION="latest"
INSTALL_DIR="$HOME/miniconda"

# Download URL for Miniconda installer
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"

# Temporary file for the installer
INSTALLER_PATH="/tmp/miniconda.sh"

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install required dependencies
sudo apt install -y wget

# Download the Miniconda installer
wget "$MINICONDA_URL" -O "$INSTALLER_PATH"

# Make the installer executable
chmod +x "$INSTALLER_PATH"

# Run the Miniconda installer
bash "$INSTALLER_PATH" -b -p "$INSTALL_DIR"

# Clean up the installer
rm "$INSTALLER_PATH"

# init conda
$INSTALL_DIR/bin/conda init
$INSTALL_DIR/bin/conda init zsh

# Update conda to the latest version
$INSTALL_DIR/bin/conda update -n base -c defaults conda -y

# Display installation success message
echo "Miniconda has been successfully installed in $INSTALL_DIR."
echo "Restart your shell or run 'source ~/.bashrc' to use conda."
