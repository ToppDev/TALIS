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

# A featureful, general-purpose sound server
pacinstall pulseaudio

# ALSA Configuration for PulseAudio
pacinstall pulseaudio-alsa

# PulseAudio Volume Control
pacinstall pavucontrol

# Advanced Linux Sound Architecture - Utilities
# Additional ALSA plugins
# An alternative implementation of Linux sound support
# Firmware binaries for loader programs in alsa-tools and hotplug firmware loader
pacinstall alsa-utils alsa-plugins alsa-lib alsa-firmware

# Multimedia graph framework - core
pacinstall gstreamer

# Multimedia graph framework - good plugins
# Multimedia graph framework - bad plugins
# Multimedia graph framework - base plugins
# Multimedia graph framework - ugly plugins
pacinstall gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly

# Volume control for the system tray
pacinstall volumeicon

# mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others.
pacinstall playerctl

# Fix fluidsynth/pulseaudio issue.
sudo grep -q "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" /etc/conf.d/fluidsynth ||
    sudo sh -c 'echo "OTHER_OPTS=\"-a pulseaudio -m alsa_seq -r 48000\"" >> /etc/conf.d/fluidsynth'
# Start/restart PulseAudio.
pkill -15 -x 'pulseaudio'; pulseaudio --start

# ########################################################################################################## #

box "Sound software installed"