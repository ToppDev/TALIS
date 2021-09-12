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
source "$scriptdir/helper/sudo.sh"

# ########################################################################################################## #
#                                              Check Arch distro                                             #
# ########################################################################################################## #

check_arch_internet

# ########################################################################################################## #
#                                                 Sudo config                                                #
# ########################################################################################################## #

# Remove the previous 'NOPASSWD ALL' and set new permissions
sudoperms "%wheel ALL=(ALL) ALL" \
          "%users ALL=(ALL) NOPASSWD: /usr/bin/halt,/usr/bin/shutdown,/usr/bin/reboot,/usr/bin/poweroff" \
          "%users ALL=(ALL) NOPASSWD: /usr/bin/bluetooth on,/usr/bin/bluetooth off" \
          "%wheel ALL=(ALL) NOPASSWD: /usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/loadkeys" \
          "%wheel ALL=(ALL) NOPASSWD: /usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/pacman -Syyu --noconfirm"
