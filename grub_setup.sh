#!/bin/bash

echo -ne "

 ██████╗ ██████╗ ██╗   ██╗██████╗     ███████╗███████╗████████╗██╗   ██╗██████╗ 
██╔════╝ ██╔══██╗██║   ██║██╔══██╗    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██║  ███╗██████╔╝██║   ██║██████╔╝    ███████╗█████╗     ██║   ██║   ██║██████╔╝
██║   ██║██╔══██╗██║   ██║██╔══██╗    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
╚██████╔╝██║  ██║╚██████╔╝██████╔╝    ███████║███████╗   ██║   ╚██████╔╝██║     
 ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
                                                                                
"

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
