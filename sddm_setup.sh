#!/bin/bash

# Clear the terminal
clear

# Define colors for output
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

# Header display
echo -e "${BLUE}"
cat <<"EOF"

███████╗██████╗ ██████╗ ███╗   ███╗    ███████╗███████╗████████╗██╗   ██╗██████╗ 
██╔════╝██╔══██╗██╔══██╗████╗ ████║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
███████╗██║  ██║██║  ██║██╔████╔██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝
╚════██║██║  ██║██║  ██║██║╚██╔╝██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
███████║██████╔╝██████╔╝██║ ╚═╝ ██║    ███████║███████╗   ██║   ╚██████╔╝██║     
╚══════╝╚═════╝ ╚═════╝ ╚═╝     ╚═╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
                                                                                 
EOF
echo -e "${ENDCOLOR}"

# Confirmation prompt
read -p "Do you want to continue with SDDM and Catppuccin theme installation? [Y/n] " yn
yn=${yn:-Y} # Default to 'Y' if no input

if [[ $yn =~ ^[Nn]$ ]]; then
    echo "Installation aborted."
    exit
fi

echo "Proceeding with installation..."

# Install SDDM if not already installed
if ! command -v sddm &> /dev/null; then
    echo -e "${GREEN}Installing SDDM...${ENDCOLOR}"
    sudo pacman -S sddm --noconfirm
else
    echo -e "${GREEN}SDDM is already installed.${ENDCOLOR}"
fi

# Define theme download and directory
THEME_DIR="/usr/share/sddm/themes/catppuccin-mocha"
THEME_URL="https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-mocha.zip"

# Download and install Catppuccin SDDM theme if not installed
if [ ! -d "$THEME_DIR" ]; then
    echo -e "${GREEN}Downloading Catppuccin SDDM theme...${ENDCOLOR}"
    sudo mkdir -p $THEME_DIR
    sudo wget -O /tmp/catppuccin-mocha.zip $THEME_URL
    sudo unzip /tmp/catppuccin-mocha.zip -d $THEME_DIR
    sudo rm /tmp/catppuccin-mocha.zip
else
    echo -e "${GREEN}Catppuccin SDDM theme is already installed.${ENDCOLOR}"
fi

# Set Catppuccin theme in SDDM configuration
echo -e "${GREEN}Setting Catppuccin as the SDDM theme...${ENDCOLOR}"
sudo bash -c 'cat > /etc/sddm.conf <<EOF
[Theme]
Current=catppuccin-mocha
EOF'

# Enable SDDM and disable other display managers
echo -e "${GREEN}Enabling SDDM...${ENDCOLOR}"
sudo systemctl enable sddm --force
sudo systemctl disable lightdm gdm

echo -e "${GREEN}Setup complete. Please reboot your system to see the changes.${ENDCOLOR}"
