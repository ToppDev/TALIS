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

mkdir -p ~/.config/Code\ -\ OSS/User
vsextensions=$(cat "$packagedir/extensions")
while IFS= read -r line; do
    code --install-extension $line
done <<< "$vsextensions"

# Live Share dependencies
installpkg gcr liburcu openssl-1.0 krb5 zlib icu gnome-keyring libsecret desktop-file-utils