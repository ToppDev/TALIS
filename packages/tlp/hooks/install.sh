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

# https://wiki.archlinux.org/index.php/TLP
# TLP brings you the benefits of advanced power management for Linux without
# the need to understand every technical detail. TLP comes with a default
# configuration already optimized for battery life, so you may just install
# and forget it. Nevertheless TLP is highly customizable to fulfill your
# specific requirements

if ls /sys/class/power_supply/CMB?* > /dev/null 2>&1; then
    installpkg tlp
    sudo systemctl enable tlp.service
    sudo systemctl start tlp.service
fi