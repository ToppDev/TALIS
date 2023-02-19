#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #
#                                               Helper scripts                                               #
# ########################################################################################################## #

packagedir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/.."

source "$scriptdir/helper/color.sh"
source "$scriptdir/helper/log.sh"
source "$scriptdir/helper/install.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"

# ########################################################################################################## #
#                                                   Script                                                   #
# ########################################################################################################## #

sudo mkdir -p /usr/share/pixmaps/

# LightDM config
sudo cp $packagedir/config/lightdm-background.jpg /usr/share/pixmaps/lightdm-background.jpg
sudo cp $packagedir/config/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf

# Put the .Xauthority file into '/var/run/lightdm/user/xauthority' instead of '~/.Xauthority'
sudo sed -i "s/#user-authority-in-system-dir=false/user-authority-in-system-dir=true/" /etc/lightdm/lightdm.conf

# Enable service
if is_archlinux; then
    sudo systemctl enable lightdm.service
elif is_artixlinux; then
    installpkg lightdm-runit
    sudo ln -s /etc/runit/sv/lightdm /run/runit/service && sudo sv stop lightdm
else
    error "System not supported"
fi