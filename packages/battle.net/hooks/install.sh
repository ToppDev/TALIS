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

if pacman -Qs lutris > /dev/null; then
    if ! lutris --list-games --installed | grep Battle.net; then
        installpkg wine lib32-gnutls lib32-libldap lib32-libgpg-error lib32-sqlite lib32-libpulse
        xdg-open lutris:blizzard-battlenet-standard
        echo "[Desktop Entry]
Type=Application
Name=Blizzard Battle.net
Icon=lutris_battlenet
Exec=lutris lutris:rungameid/1
Categories=Game
Name[en_US.UTF-8]=Blizzard Battle.net" > $HOME/.local/share/applications/Blizzard\ Battle.net
    fi
else
    error "Please install lutris before Battle.net"
fi