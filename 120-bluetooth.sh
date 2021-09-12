#!/bin/sh
# ToppDev's Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #
#                                               Helper scripts                                               #
# ########################################################################################################## #

scriptdir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source "$scriptdir/helper/color.sh"
source "$scriptdir/helper/log.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"

# ########################################################################################################## #
#                                              Check Arch distro                                             #
# ########################################################################################################## #

check_arch_internet

# ########################################################################################################## #
#                                                Installation                                                #
# ########################################################################################################## #

# Bluetooth support for PulseAudio
sudo pacman -S --noconfirm --needed pulseaudio-bluetooth

# Daemons for the bluetooth protocol stack
sudo pacman -S --noconfirm --needed bluez

# Deprecated libraries for the bluetooth protocol stack
sudo pacman -S --noconfirm --needed bluez-libs

# Development and debugging utilities for the bluetooth protocol stack
sudo pacman -S --noconfirm --needed bluez-utils

# Bluetooth configuration tool
sudo pacman -S --noconfirm --needed blueberry

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

# ########################################################################################################## #

box "Bluetooth software installed"