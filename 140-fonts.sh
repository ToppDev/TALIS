#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
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

# Sans serif font family for user interface environments
sudo pacman -S adobe-source-sans-pro-fonts --noconfirm --needed

# fonts/icons for powerlines
sudo pacman -S awesome-terminal-fonts --noconfirm --needed

# Humanist sans serif font
sudo pacman -S cantarell-fonts --noconfirm --needed

# Google Noto TTF fonts
sudo pacman -S noto-fonts --noconfirm --needed

# Google Noto emoji fonts
sudo pacman -S noto-fonts-emoji --noconfirm --needed

# Monospace bitmap font (for X11 and console)
sudo pacman -S terminus-font --noconfirm --needed

# Bitstream Vera fonts.
sudo pacman -S ttf-bitstream-vera --noconfirm --needed

# Font family based on the Bitstream Vera Fonts with a wider range of characters
sudo pacman -S ttf-dejavu --noconfirm --needed

# General-purpose fonts released by Google as part of Android
sudo pacman -S ttf-droid --noconfirm --needed

# Monospace font for pretty code listings and for the terminal
sudo pacman -S ttf-inconsolata --noconfirm --needed

# Red Hats Liberation fonts
sudo pacman -S ttf-liberation --noconfirm --needed

# Google's signature family of fonts
sudo pacman -S ttf-roboto --noconfirm --needed

# Ubuntu font family
sudo pacman -S ttf-ubuntu-font-family --noconfirm --needed

# A monospaced bitmap font for the console and X11
sudo pacman -S tamsyn-font --noconfirm --needed

# Serif (Libertine) and Sans Serif (Biolinum) OpenType fonts with large Unicode coverage
sudo pacman -S ttf-linux-libertine --noconfirm --needed

# Download Nerd Fonts
sudo mkdir -p /usr/share/fonts/nerd-fonts
sudo wget -P /usr/share/fonts/nerd-fonts -nc https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/complete/Inconsolata%20Nerd%20Font%20Complete%20Mono.otf
sudo wget -P /usr/share/fonts/nerd-fonts -nc https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/complete/Inconsolata%20Nerd%20Font%20Complete.otf
sudo wget -P /usr/share/fonts/nerd-fonts -nc https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.otf
sudo wget -P /usr/share/fonts/nerd-fonts -nc https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.otf
sudo wget -P /usr/share/fonts/nerd-fonts -nc https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Windows%20Compatible.otf
sudo wget -P /usr/share/fonts/nerd-fonts -nc https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
# Download Patched Awesome Terminal Fonts
sudo mkdir -p /usr/share/fonts/awesome-terminal-fonts-patched
sudo wget -P /usr/share/fonts/awesome-terminal-fonts-patched -nc https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/Droid%2BSans%2BMono%2BAwesome.ttf
sudo wget -P /usr/share/fonts/awesome-terminal-fonts-patched -nc https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/Inconsolata%2BAwesome.ttf
sudo wget -P /usr/share/fonts/awesome-terminal-fonts-patched -nc https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf

# Update font cache
fc-cache -fv

# ########################################################################################################## #

box "Fonts have been copied and loaded"