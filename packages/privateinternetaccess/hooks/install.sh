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

version=$(curl -s https://www.privateinternetaccess.com/download/linux-vpn \
          | grep '"download_linux"' \
          | sed 's/.*https:\/\/installers.privateinternetaccess.com\/download\/pia-linux-\([^"]*\).*/\1/')
wget -P /tmp -nc https://installers.privateinternetaccess.com/download/pia-linux-$version
chmod +x /tmp/pia-linux-*.run
/tmp/pia-linux-*.run
rm -f /tmp/pia-linux-*.run