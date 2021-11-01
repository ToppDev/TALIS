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

aurinstall wine-lol
wget -P /tmp -nc https://lol.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.euw.exe
WINEARCH=win32 WINEPREFIX=${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/LeagueOfLegends/ /opt/wine-lol/bin/wine /tmp/live.euw.exe
if ! sudo grep -q "abi.vsyscall32=0" /etc/sudoers; then
    sudo sed -i '/# ALL ALL=(ALL) ALL/a \\n%wheel ALL=(ALL) NOPASSWD: \/usr\/bin\/sysctl -w abi.vsyscall32=0' /etc/sudoers
fi
rm -f ${XDG_DATA_HOME:-$HOME/.local/share}/applications/wine/Programs/Riot\ Games/League\ of\ Legends.desktop
rm -r ${XDG_DATA_HOME:-$HOME/.local/share}/applications/wine