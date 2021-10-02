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
source "$scriptdir/helper/install.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"

# ########################################################################################################## #
#                                              Check Arch distro                                             #
# ########################################################################################################## #

check_arch_internet

# ########################################################################################################## #
#                                                Installation                                                #
# ########################################################################################################## #

# Sans serif font family for user interface environments
pacinstall adobe-source-sans-pro-fonts


# Humanist sans serif font
pacinstall cantarell-fonts

# Google Noto TTF fonts
pacinstall noto-fonts

# Google Noto emoji fonts
pacinstall noto-fonts-emoji

# Monospace bitmap font (for X11 and console)
pacinstall terminus-font

# Bitstream Vera fonts.
pacinstall ttf-bitstream-vera

# Font family based on the Bitstream Vera Fonts with a wider range of characters
pacinstall ttf-dejavu

# General-purpose fonts released by Google as part of Android
pacinstall ttf-droid

# Monospace font for pretty code listings and for the terminal
pacinstall ttf-inconsolata

# Red Hats Liberation fonts
pacinstall ttf-liberation

# Google's signature family of fonts
pacinstall ttf-roboto

# Ubuntu font family
pacinstall ttf-ubuntu-font-family

# A monospaced bitmap font for the console and X11
pacinstall tamsyn-font

# Serif (Libertine) and Sans Serif (Biolinum) OpenType fonts with large Unicode coverage
pacinstall ttf-linux-libertine

# ########################################################################################################## #

box "Fonts have been copied and loaded"