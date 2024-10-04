#!/bin/bash

clear

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

echo -e "${BLUE}"
cat <<"EOF"

██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗    ███████╗███████╗████████╗██╗   ██╗██████╗ 
██║     ██║████╗  ██║██║   ██║╚██╗██╔╝    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝     ███████╗█████╗     ██║   ██║   ██║██████╔╝
██║     ██║██║╚██╗██║██║   ██║ ██╔██╗     ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗    ███████║███████╗   ██║   ╚██████╔╝██║     
╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
                                                                                    

EOF
echo -e "${ENDCOLOR}"

sddm_setup() {
    echo "Proceeding with SDDM installation..."
    if ! command -v sddm &> /dev/null; then
        echo -e "${GREEN}Installing SDDM...${ENDCOLOR}"
        sudo pacman -S sddm --noconfirm
    else
        echo -e "${GREEN}SDDM is already installed.${ENDCOLOR}"
    fi

    THEME_DIR="/usr/share/sddm/themes/catppuccin-mocha"
    THEME_URL="https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-mocha.zip"

    if [ ! -d "$THEME_DIR" ]; then
        echo -e "${GREEN}Downloading Catppuccin SDDM theme...${ENDCOLOR}"
        sudo mkdir -p $THEME_DIR
        sudo wget -O /tmp/catppuccin-mocha.zip $THEME_URL
        sudo unzip /tmp/catppuccin-mocha.zip -d $THEME_DIR
        sudo rm /tmp/catppuccin-mocha.zip
    else
        echo -e "${GREEN}Catppuccin SDDM theme is already installed.${ENDCOLOR}"
    fi

    echo -e "${GREEN}Setting Catppuccin as the SDDM theme...${ENDCOLOR}"
    sudo bash -c 'cat > /etc/sddm.conf <<EOF
[Theme]
Current=catppuccin-mocha
EOF'

    echo -e "${GREEN}Enabling SDDM...${ENDCOLOR}"
    sudo systemctl enable sddm --force
    sudo systemctl disable lightdm gdm

    echo -e "${GREEN}Setup complete. Please reboot your system to see the changes.${ENDCOLOR}"
}

font_setup() {
    echo "Proceeding with font installation..."

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
        wget -q $font_url -O "${font_name}.zip"
        unzip -q "${font_name}.zip" -d "${font_name}"
        mv "${font_name}"/*.ttf ~/.fonts/
        rm -rf "${font_name}" "${font_name}.zip"
        fc-cache -vf
        echo -e "${GREEN}$font_name installed successfully!${ENDCOLOR}"
    }

    echo -e "${CYAN}Please select a font to install or press 6 to Skip:${NC}"
    echo -e " 1. FiraCode Nerd Font"
    echo -e " 2. FiraMono Nerd Font"
    echo -e " 3. JetBrainsMono"
    echo -e " 4. MesloLG Nerd Font"
    echo -e " 5. Hack Nerd Font"
    echo -e " 6. Skip and return to the main menu"

    while true; do
        read -p "Enter the number (1-6): " choice

        if [[ $choice -eq 6 ]]; then
            echo -e "${YELLOW}Skipping font installation and returning to the main menu...${ENDCOLOR}"
            break 
        elif [[ -n ${FONT_URLS[$choice]} ]]; then
            install_font $choice
            break 
        else
            echo -e "${RED}Invalid choice. Please select a valid option (1-6).${ENDCOLOR}"
        fi
    done
}

grub_setup() {
    echo "Cloning repository..."
    git clone https://github.com/harilvfs/i3wmdotfiles
    cd i3wmdotfiles/grub

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
}

PS3="Select a setup option from the menu: "
options=("SDDM Setup" "Font Setup" "GRUB Setup" "Exit")

select opt in "${options[@]}"; do
    case $opt in
        "SDDM Setup")
            sddm_setup
            ;;
        "Font Setup")
            font_setup
            ;;
        "GRUB Setup")
            grub_setup
            ;;
        "Exit")
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done
