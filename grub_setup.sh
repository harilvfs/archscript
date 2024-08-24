#!/bin/bash

echo -ne "

 ██████╗ ██████╗ ██╗   ██╗██████╗     ███████╗███████╗████████╗██╗   ██╗██████╗ 
██╔════╝ ██╔══██╗██║   ██║██╔══██╗    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██║  ███╗██████╔╝██║   ██║██████╔╝    ███████╗█████╗     ██║   ██║   ██║██████╔╝
██║   ██║██╔══██╗██║   ██║██╔══██╗    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
╚██████╔╝██║  ██║╚██████╔╝██████╔╝    ███████║███████╗   ██║   ╚██████╔╝██║     
 ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
                                                                                
"

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
