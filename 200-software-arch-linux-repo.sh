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
source "$scriptdir/helper/user.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"

# ########################################################################################################## #
#                                              Check Arch distro                                             #
# ########################################################################################################## #

check_arch_internet

# ########################################################################################################## #
#                                                Installation                                                #
# ########################################################################################################## #

echo "Installing category Accessories"

echo "Installing category Development"

# Live Share dependencies
pacinstall gcr liburcu openssl-1.0 krb5 zlib icu gnome-keyring libsecret desktop-file-utils

# The .NET Core SDK
pacinstall dotnet-sdk

# OpenJDK Java 11 development kit
pacinstall jdk-openjdk

# Powerful x86 virtualization for enterprise as well as home use
pacinstall virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
sudo gpasswd -a $(whoami) vboxusers

echo "Installing category Office"

# Standalone mail and news reader from mozilla.org
pacinstall thunderbird

# LibreOffice branch which contains new features and program enhancements
pacinstall libreoffice-fresh

# Spell checker and morphological analyzer library and program
pacinstall hunspell hunspell-de hunspell-en_us

echo "Installing category System"

# Open-source KVM software based on Synergy (GUI)
pacinstall barrier

# Lightweight battery icon for the system tray
pacinstall cbatticon

# An URL retrieval utility and library
pacinstall curl

# DOS filesystem utilities
pacinstall dosfstools

# Complete solution to record, convert and stream audio and video
pacinstall ffmpeg

# Lightweight video thumbnailer that can be used by file managers
pacinstall ffmpegthumbnailer

# Disk Management Utility for GNOME
pacinstall gnome-disk-utility

# Stores passwords and encryption keys
pacinstall gnome-keyring

# A Partition Magic clone, frontend to GNU Parted
pacinstall gparted

# Virtual filesystem implementation for GIO
pacinstall gvfs gvfs-mtp

# Interactive process viewer
pacinstall htop

# A collection of common network programs
pacinstall inetutils

# An image viewing/manipulation program
pacinstall imagemagick

# Headers and scripts for building modules for the Linux kernel
pacinstall linux-headers

# Headers and scripts for building modules for the LTS Linux kernel
pacinstall linux-lts-headers

# A utility for reading man pages
pacinstall man-db
# Linux man pages
pacinstall man-pages

# Configuration tools for Linux networking
pacinstall net-tools

# NetworkManager GUI connection editor and widgets
pacinstall nm-connection-editor
# Applet for managing network connections
pacinstall network-manager-applet
# Open client for Cisco AnyConnect VPN
pacinstall openconnect
# NetworkManager VPN plugin for OpenConnect
pacinstall networkmanager-openconnect
# An easy-to-use, robust and highly configurable VPN (Virtual Private Network)
pacinstall openvpn
# NetworkManager VPN plugin for OpenVPN
pacinstall networkmanager-openvpn

# A CLI system information tool written in BASH that supports displaying images.
pacinstall neofetch

# The programmers solid 3D CAD modeller
pacinstall openscad

# Premier connectivity tool for remote login with the SSH protocol
pacinstall openssh

# A Python 3 module and script to retrieve and filter the latest Pacman mirror list
pacinstall reflector

# A fast and versatile file copying tool for remote and local files
pacinstall rsync

# D-Bus service for applications to request thumbnails
pacinstall tumbler

# The original ex/vi text editor
pacinstall vi
# Vi Improved, a highly configurable, improved version of the vi text editor
pacinstall vim

# Volume control for the system tray
# pacinstall volumeicon

# Network utility to retrieve files from the Web
pacinstall wget

# A compatibility layer for running Windows programs
pacinstall wine

# Manage user directories like ~/Desktop and ~/Music
pacinstall xdg-user-dirs


# Power manager for Xfce desktop
#pacinstall xfce4-power-manager

# Settings manager for xfce
#pacinstall xfce4-settings

# Lightweight passphrase dialog for SSH
pacinstall x11-ssh-askpass

###############################################################################################

# installation of zippers and unzippers
pacinstall unace unrar zip unzip sharutils  uudeview  arj cabextract file-roller
# Command-line file archiver with high compression ratio
pacinstall p7zip

# ########################################################################################################## #

box "Software from standard Arch Linux Repo installed"
