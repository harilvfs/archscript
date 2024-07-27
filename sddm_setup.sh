#!/bin/bash

# Clear the terminal
clear

# Define colors
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

# Header
echo -e "${BLUE}"
cat <<"EOF"
+-------------------------------------------------------+
|  Setting up Catppuccin SDDM Theme                     |
+-------------------------------------------------------+
EOF
echo -e "${ENDCOLOR}"

# Confirm installation
while true; do
    read -p "Do you want to continue with the SDDM and Catppuccin theme installation? [Y/n] " yn
    case $yn in
        [Yy]* ) echo "Proceeding with installation..."; break;;
        [Nn]* ) echo "Installation aborted."; exit;;
        * ) echo "Invalid response. Proceeding with installation..."; break;;
    esac
done

# Check and install SDDM if not available
if ! command -v sddm &> /dev/null; then
    echo -e "${GREEN}Installing SDDM...${ENDCOLOR}"
    sudo pacman -S sddm --noconfirm
else
    echo -e "${GREEN}SDDM is already installed.${ENDCOLOR}"
fi

# Download Catppuccin SDDM theme
THEME_DIR="/usr/share/sddm/themes/catppuccin-mocha"
if [ ! -d "$THEME_DIR" ]; then
    echo -e "${GREEN}Downloading Catppuccin SDDM theme...${ENDCOLOR}"
    sudo mkdir -p $THEME_DIR
    sudo wget -O $THEME_DIR/theme.tar.gz https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-mocha.tar.gz
    sudo tar -xzvf $THEME_DIR/theme.tar.gz -C $THEME_DIR --strip-components=1
    sudo rm $THEME_DIR/theme.tar.gz
else
    echo -e "${GREEN}Catppuccin SDDM theme is already installed.${ENDCOLOR}"
fi

# Set the Catppuccin theme as the current theme
echo -e "${GREEN}Setting Catppuccin as the SDDM theme...${ENDCOLOR}"
sudo bash -c 'cat > /etc/sddm.conf <<EOF
[Theme]
Current=catppuccin-mocha
EOF'

# Enable SDDM
echo -e "${GREEN}Enabling SDDM...${ENDCOLOR}"
sudo systemctl enable sddm --force
sudo systemctl disable lightdm
sudo systemctl disable gdm

echo -e "${GREEN}Setup complete. Please reboot your system to see the changes.${ENDCOLOR}"
