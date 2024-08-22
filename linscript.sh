#!/bin/bash

# Clear the terminal
clear

# Color Definitions
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[37m"
ENDCOLOR="\e[0m"

# Header for SDDM Theme Setup
echo -e "${BLUE}"
cat <<"EOF"
+-------------------------------------------------------+
|  Setting up Catppuccin SDDM Theme                     |
+-------------------------------------------------------+
EOF
echo -e "${ENDCOLOR}"

# Confirm SDDM and Catppuccin Theme Installation
while true; do
    read -p "Do you want to continue with the SDDM and Catppuccin theme installation? [Y/n] " yn
    case $yn in
        [Yy]* ) echo "Proceeding with installation..."; break;;
        [Nn]* ) echo "Installation aborted."; exit;;
        * ) echo "Invalid response. Proceeding with installation..."; break;;
    esac
done

# Check and Install SDDM if not available
if ! command -v sddm &> /dev/null; then
    echo -e "${GREEN}Installing SDDM...${ENDCOLOR}"
    sudo pacman -S sddm --noconfirm
else
    echo -e "${GREEN}SDDM is already installed.${ENDCOLOR}"
fi

# Download Catppuccin SDDM Theme
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

# Set the Catppuccin Theme as the Current Theme
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

echo -e "${GREEN}SDDM Setup complete. Please reboot your system to see the changes.${ENDCOLOR}"

# Font Installer Header
echo -e "${YELLOW}═════════════════════════════════════════════════${ENDCOLOR}"
echo -e "${YELLOW}          Welcome to the Font Installer          ${ENDCOLOR}"
echo -e "${YELLOW}═════════════════════════════════════════════════${ENDCOLOR}"

# Define Font Download Links
declare -A FONT_URLS
FONT_URLS=(
    [1]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip"
    [2]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraMono.zip"
    [3]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
    [4]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip"
    [5]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
)

# Define Font Names
declare -A FONT_NAMES
FONT_NAMES=(
    [1]="FiraCode"
    [2]="FiraMono"
    [3]="JetBrainsMono"
    [4]="Meslo"
    [5]="Hack"
)

# Create ~/.fonts Directory if it Doesn't Exist
mkdir -p ~/.fonts

# Function to Download and Install Selected Font
install_font() {
    local font_choice=$1
    local font_name=${FONT_NAMES[$font_choice]}
    local font_url=${FONT_URLS[$font_choice]}
    
    echo -e "${MAGENTA}Starting the installation process for ${WHITE}$font_name${ENDCOLOR}..."
    sleep 1
    
    echo -e "${CYAN}Downloading ${WHITE}$font_name${ENDCOLOR}...${ENDCOLOR}"
    wget -q $font_url -O "${font_name}.zip"
    sleep 1

    echo -e "${CYAN}Unzipping ${WHITE}$font_name${ENDCOLOR}...${ENDCOLOR}"
    unzip -q "${font_name}.zip" -d "${font_name}"
    sleep 1

    echo -e "${CYAN}Installing ${WHITE}$font_name${ENDCOLOR}...${ENDCOLOR}"
    mv "${font_name}"/*.ttf ~/.fonts/
    sleep 1

    echo -e "${CYAN}Cleaning up...${ENDCOLOR}"
    rm -rf "${font_name}" "${font_name}.zip"
    sleep 1

    echo -e "${CYAN}Updating font cache...${ENDCOLOR}"
    fc-cache -vf

    echo -e "${GREEN}✔ ${WHITE}$font_name${GREEN} installed successfully!${ENDCOLOR}"
}

# Display Font Options with Formatting
echo -e "${CYAN}Please select a font to install:${ENDCOLOR}"
echo -e "${CYAN} 1. ${WHITE}FiraCode Nerd Font${ENDCOLOR}"
echo -e "${CYAN} 2. ${WHITE}FiraMono Nerd Font${ENDCOLOR}"
echo -e "${CYAN} 3. ${WHITE}JetBrainsMono${ENDCOLOR}"
echo -e "${CYAN} 4. ${WHITE}MesloLG Nerd Font${ENDCOLOR}"
echo -e "${CYAN} 5. ${WHITE}Hack Nerd Font${ENDCOLOR}"
echo -e "${YELLOW}═════════════════════════════════════════════════${ENDCOLOR}"

read -p "Enter the number (1-5): " choice

# Validate Choice and Install the Font
if [[ -n ${FONT_URLS[$choice]} ]]; then
    install_font $choice
else
    echo -e "${RED}❌ Invalid choice. Please run the script again and select a number between 1 and 5.${ENDCOLOR}"
fi

# Heading: GRUB Setup

# Clone the repository
echo "Cloning repository..."
git clone https://github.com/aayushx402/i3-CatDotfiles

# Change directory to the cloned repo
cd i3-CatDotfiles/grub

# Copy the GRUB theme to the appropriate directory
echo "Copying GRUB theme..."
sudo cp -r CyberRe /usr/share/grub/themes

# Update the GRUB configuration
echo "Updating GRUB configuration..."
sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/usr/share/grub/themes/CyberRe/theme.txt"|' /etc/default/grub

# Check if the system is Arch Linux
if grep -q "Arch" /etc/os-release; then
    # Regenerate the GRUB configuration for Arch Linux
    echo "Generating GRUB configuration for Arch Linux..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
else
    # Update GRUB for other distributions
    echo "Updating GRUB..."
    sudo update-grub
fi

echo "GRUB setup completed successfully!"
