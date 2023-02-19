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
sudo cp $scriptdir/resources/images/login-background_5120x1440.jpg /usr/share/pixmaps/login-background.jpg

set-gdm-theme set Arc-Dark /usr/share/pixmaps/login-background.jpg

sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme 'Breeze_Snow'
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme 'Sardi-Arc'