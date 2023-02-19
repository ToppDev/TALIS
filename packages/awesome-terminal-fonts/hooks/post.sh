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

# Awesome Terminal Fonts (patching-strategy branch)
sudo mkdir -p /usr/share/fonts/awesome-terminal-fonts-patching-strategy
sudo wget -P /usr/share/fonts/awesome-terminal-fonts-patching-strategy -nc https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/Droid%2BSans%2BMono%2BAwesome.ttf
sudo wget -P /usr/share/fonts/awesome-terminal-fonts-patching-strategy -nc https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/Inconsolata%2BAwesome.ttf
sudo wget -P /usr/share/fonts/awesome-terminal-fonts-patching-strategy -nc https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf

# Update font cache
fc-cache -fv