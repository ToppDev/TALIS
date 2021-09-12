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

# https://wiki.archlinux.org/index.php/TLP
#TLP brings you the benefits of advanced power management for Linux without
#the need to understand every technical detail. TLP comes with a default
#configuration already optimized for battery life, so you may just install
# and forget it. Nevertheless TLP is highly customizable to fulfill your
# specific requirements

sudo pacman -S tlp --noconfirm --needed
# TODO: Artix
sudo systemctl enable tlp.service
sudo systemctl start tlp.service

# ########################################################################################################## #

box "TLP  software installed"
