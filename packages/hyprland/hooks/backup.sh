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
source "$scriptdir/helper/user.sh"
source "$scriptdir/helper/install.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"

# ########################################################################################################## #
#                                                   Script                                                   #
# ########################################################################################################## #

[ -f /usr/share/wayland-sessions/wrapped_hl.desktop ] && sudo cp /usr/share/wayland-sessions/wrapped_hl.desktop $packagedir/config/wayland-sessions/wrapped_hl.desktop
[ -f /usr/local/bin/wrappedhl ] && sudo cp /usr/local/bin/wrappedhl $packagedir/config/wrappedhl
