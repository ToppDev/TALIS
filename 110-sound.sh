#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #
#                                               Helper scripts                                               #
# ########################################################################################################## #

scriptdir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

echo $scriptdir
exit 1

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

# A featureful, general-purpose sound server
sudo pacman -S pulseaudio --noconfirm --needed

# ALSA Configuration for PulseAudio
sudo pacman -S pulseaudio-alsa --noconfirm --needed

# PulseAudio Volume Control
sudo pacman -S pavucontrol --noconfirm --needed

# Advanced Linux Sound Architecture - Utilities
# Additional ALSA plugins
# An alternative implementation of Linux sound support
# Firmware binaries for loader programs in alsa-tools and hotplug firmware loader
sudo pacman -S alsa-utils alsa-plugins alsa-lib alsa-firmware --noconfirm --needed

# Multimedia graph framework - core
sudo pacman -S gstreamer --noconfirm --needed

# Multimedia graph framework - good plugins
# Multimedia graph framework - bad plugins
# Multimedia graph framework - base plugins
# Multimedia graph framework - ugly plugins
sudo pacman -S gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly --noconfirm --needed

# Volume control for the system tray
sudo pacman -S volumeicon --noconfirm --needed

# mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others.
sudo pacman -S playerctl --noconfirm --needed

# ########################################################################################################## #

box "Sound software installed"