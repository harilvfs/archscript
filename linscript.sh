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

echo -ne "

███████╗ ██████╗ ███╗   ██╗████████╗    ███████╗███████╗████████╗██╗   ██╗██████╗ 
██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
█████╗  ██║   ██║██╔██╗ ██║   ██║       ███████╗█████╗     ██║   ██║   ██║██████╔╝
██╔══╝  ██║   ██║██║╚██╗██║   ██║       ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
██║     ╚██████╔╝██║ ╚████║   ██║       ███████║███████╗   ██║   ╚██████╔╝██║     
╚═╝      ╚═════╝ ╚═╝  ╚═══╝   ╚═╝       ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
                                                                                  
"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # 

declare -A FONT_URLS
FONT_URLS=(
    [1]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip"
    [2]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraMono.zip"
    [3]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
    [4]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip"
    [5]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
)

declare -A FONT_NAMES
FONT_NAMES=(
    [1]="FiraCode"
    [2]="FiraMono"
    [3]="JetBrainsMono"
    [4]="Meslo"
    [5]="Hack"
)

mkdir -p ~/.fonts

install_font() {
    local font_choice=$1
    local font_name=${FONT_NAMES[$font_choice]}
    local font_url=${FONT_URLS[$font_choice]}
    
    echo -e "${MAGENTA}Starting the installation process for ${WHITE}$font_name${NC}..."
    sleep 1
    
    echo -e "${CYAN}Downloading ${WHITE}$font_name${NC}...${NC}"
    wget -q $font_url -O "${font_name}.zip"
    sleep 1

    echo -e "${CYAN}Unzipping ${WHITE}$font_name${NC}...${NC}"
    unzip -q "${font_name}.zip" -d "${font_name}"
    sleep 1

    echo -e "${CYAN}Installing ${WHITE}$font_name${NC}...${NC}"
    mv "${font_name}"/*.ttf ~/.fonts/
    sleep 1

    echo -e "${CYAN}Cleaning up...${NC}"
    rm -rf "${font_name}" "${font_name}.zip"
    sleep 1

    echo -e "${CYAN}Updating font cache...${NC}"
    fc-cache -vf

    echo -e "${GREEN}✔ ${WHITE}$font_name${GREEN} installed successfully!${NC}"
}

echo -e "${YELLOW}═════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}          Welcome to the Font Installer          ${NC}"
echo -e "${YELLOW}═════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Please select a font to install:${NC}"
echo -e "${CYAN} 1. ${WHITE}FiraCode Nerd Font${NC}"
echo -e "${CYAN} 2. ${WHITE}FiraMono Nerd Font${NC}"
echo -e "${CYAN} 3. ${WHITE}JetBrainsMono${NC}"
echo -e "${CYAN} 4. ${WHITE}MesloLG Nerd Font${NC}"
echo -e "${CYAN} 5. ${WHITE}Hack Nerd Font${NC}"
echo -e "${YELLOW}═════════════════════════════════════════════════${NC}"

read -p "Enter the number (1-5): " choice

if [[ -n ${FONT_URLS[$choice]} ]]; then
    install_font $choice
else
    echo -e "${RED}❌ Invalid choice. Please run the script again and select a number between 1 and 5.${NC}"
fi

echo -ne "

 ██████╗ ██████╗ ██╗   ██╗██████╗     ███████╗███████╗████████╗██╗   ██╗██████╗ 
██╔════╝ ██╔══██╗██║   ██║██╔══██╗    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██║  ███╗██████╔╝██║   ██║██████╔╝    ███████╗█████╗     ██║   ██║   ██║██████╔╝
██║   ██║██╔══██╗██║   ██║██╔══██╗    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
╚██████╔╝██║  ██║╚██████╔╝██████╔╝    ███████║███████╗   ██║   ╚██████╔╝██║     
 ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
                                                                                
"

echo "Cloning repository..."
git clone https://github.com/aayushx402/i3-CatDotfiles

cd i3-CatDotfiles/grub

echo "Copying GRUB theme..."
sudo cp -r CyberRe /usr/share/grub/themes

echo "Updating GRUB configuration..."
sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/usr/share/grub/themes/CyberRe/theme.txt"|' /etc/default/grub

if grep -q "Arch" /etc/os-release; then
    echo "Generating GRUB configuration for Arch Linux..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "Updating GRUB..."
    sudo update-grub
fi

echo "GRUB setup completed successfully!"
