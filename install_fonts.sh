#!/bin/bash

# Variables
NERD_FONT_VERSION="v3.3.0"
FONTS_TO_INSTALL=(
  "Hack"
  "FiraCode"
)
FONT_INSTALL_DIR="$HOME/.local/share/fonts"

# Function to install a font
install_font() {
  local font_name="$1"
  echo "Installing $font_name Nerd Font..."

  # Download the font zip file
  font_zip="${font_name}.zip"
  font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/${font_zip}"
  wget -q "$font_url" -O "$font_zip"

  if [ $? -ne 0 ]; then
    echo "Error: Failed to download $font_name Nerd Font from $font_url"
    return 1
  fi

  # Unzip the font to the install directory
  unzip -q "$font_zip" -d "$FONT_INSTALL_DIR/$font_name"

  if [ $? -ne 0 ]; then
    echo "Error: Failed to unzip $font_name Nerd Font."
    rm -f "$font_zip"
    return 1
  fi

  # Cleanup the zip file
  rm -f "$font_zip"
  echo "$font_name Nerd Font installed successfully."
}

# Ensure the font install directory exists
mkdir -p "$FONT_INSTALL_DIR"

# Install each font
for font in "${FONTS_TO_INSTALL[@]}"; do
  install_font "$font"
done

# Refresh the font cache
fc-cache -fv

# Completion message
echo "All specified Nerd Fonts have been installed and the font cache has been updated."
