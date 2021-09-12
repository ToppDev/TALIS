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

# Versatile file searching tool
# sudo pacman -S --noconfirm --needed catfish

# A curses-based scrolling 'Matrix'-like screen
#sudo pacman -S --noconfirm --needed cmatrix

# Powerful yet simple to use screenshot software
sudo pacman -S --noconfirm --needed flameshot

# GTK+ based scientific calculator
# sudo pacman -S --noconfirm --needed galculator

# Take pictures of your screen
#sudo pacman -S --noconfirm --needed gnome-screenshot

# Plotting package which outputs to X11, PostScript, PNG, GIF, and others
sudo pacman -S --noconfirm --needed gnuplot

# Cross-platform community-driven port of Keepass password manager
sudo pacman -S --noconfirm --needed keepassxc

# Simple screen recorder with an easy to use interface
sudo pacman -S --noconfirm --needed peek

# Elegant, simple, clean dock
#sudo pacman -S --noconfirm --needed plank

# A simple CD/DVD burning tool based on libburnia libraries
#sudo pacman -S --noconfirm --needed xfburn

# Changes the wallpaper on a regular interval using user-specified or automatically downloaded images.
sudo pacman -S --noconfirm --needed variety


echo "Installing category Development"

# A hackable text editor for the 21st Century
#sudo pacman -S --noconfirm --needed atom

# Compiler cache that speeds up recompilation by caching previous compilations
sudo pacman -S --noconfirm --needed ccache

# A cross-platform open-source make system
sudo pacman -S --noconfirm --needed cmake

# A tool for static C/C++ code analysis
sudo pacman -S --noconfirm --needed cppcheck

# The Open Source build of Visual Studio Code (vscode) editor
sudo pacman -S --noconfirm --needed code
mkdir -p ~/.config/Code\ -\ OSS/User
vscode-extensions() {
    vsextensions=$(cat "${0%/*}/.vscode-extensions")
    while IFS= read -r line; do
        code --install-extension $line
    done <<< "$vsextensions"
}
vscode-extensions
# Live Share dependencies
sudo pacman -S --noconfirm --needed gcr liburcu openssl-1.0 krb5 zlib icu gnome-keyring libsecret desktop-file-utils xorg-xprop
# sudo nano /usr/lib/code/product.json
# "extensionsGallery": {
#                 "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
#                 "cacheURL": "https://vscode.blob.core.windows.net/gallery/index",
#                 "itemUrl": "https://marketplace.visualstudio.com/items"
#         },
# "extensionAllowedProposedApi": ["ms-vscode.vscode-js-profile-flame",
#                                         "ms-vscode.vscode-js-profile-table",
#                                         "ms-vscode.references-view",
#                                         "ms-vscode.github-browser",
#                                         "ms-vsliveshare.vsliveshare",
#                                         "ms-vscode.node-debug",
#                                         "ms-vscode.node-debug2"],

# D-Bus debugger for GNOME
sudo pacman -S --noconfirm --needed d-feet

# Documentation system for C++, C, Java, IDL and PHP
sudo pacman -S --noconfirm --needed doxygen

# Fast and lightweight IDE
#sudo pacman -S --noconfirm --needed geany

# Compare files, directories and working copies
sudo pacman -S --noconfirm --needed meld

# The GNU Compiler Collection - C and C++ frontends
sudo pacman -S --noconfirm --needed gcc

# The GNU Debugger
sudo pacman -S --noconfirm --needed gdb

# A free, open source, portable framework for graphical application development (x11)
sudo pacman -S --noconfirm --needed glfw-x11

# GNU make utility to maintain groups of programs
sudo pacman -S --noconfirm --needed make

# A module for easy processing of XML
sudo pacman -S --noconfirm --needed perl-xml-twig

# Vulkan Installable Client Driver (ICD) Loader
sudo pacman -S --noconfirm --needed vulkan-icd-loader

# The .NET Core SDK
sudo pacman -S --noconfirm --needed dotnet-sdk

# OpenJDK Java 11 development kit
sudo pacman -S --noconfirm --needed jdk-openjdk

# Group, that contains most TeX Live packages.
sudo pacman -S --noconfirm --needed texlive-most

# Tool to help find memory-management problems in programs
sudo pacman -S --noconfirm --needed valgrind

# Visualization of Performance Profiling Data
sudo pacman -S --noconfirm --needed kcachegrind

# Graph visualization software
sudo pacman -S --noconfirm --needed graphviz

# Fast, multi-threaded malloc and nifty performance analysis tools
sudo pacman -S --noconfirm --needed gperftools

# A program to view PostScript and PDF documents
sudo pacman -S --noconfirm --needed gv

# Interactive viewer for graphs written in Graphviz's dot language
sudo pacman -S --noconfirm --needed xdot

# the fast distributed version control system
sudo pacman -S --noconfirm --needed git

# Command-line X11 automation tool
sudo pacman -S --noconfirm --needed xdotool

# Powerful x86 virtualization for enterprise as well as home use
sudo pacman -S --noconfirm --needed virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
sudo gpasswd -a $(whoami) vboxusers

echo "Installing category Education"

#sudo pacman -S --noconfirm --needed

echo "Installing category Games"

#sudo pacman -S --noconfirm --needed

echo "Installing category Graphics"

# A fully integrated 3D graphics creation suite
sudo pacman -S --noconfirm --needed blender

# Utility to organize and develop raw images
#sudo pacman -S --noconfirm --needed darktable

# GNU Image Manipulation Program
# sudo pacman -S --noconfirm --needed gimp

# A font viewer utility for GNOME
# sudo pacman -S --noconfirm --needed gnome-font-viewer

# Lightweight image viewer
# sudo pacman -S --noconfirm --needed geeqie


# Advanced color picker written in C++ using GTK+ toolkit
#sudo pacman -S --noconfirm --needed gpick

# Professional vector graphics editor
sudo pacman -S --noconfirm --needed inkscape

# Edit and paint images
sudo pacman -S --noconfirm --needed krita

# A Qt image viewer
sudo pacman -S --noconfirm --needed nomacs

# Drawing/editing program modeled after Paint.NET.
# It's goal is to provide a simplified alternative to GIMP for casual users
#sudo pacman -S --noconfirm --needed pinta

# Fast and lightweight picture-viewer for Xfce4
#sudo pacman -S --noconfirm --needed ristretto

# Simple terminal image viewer
sudo pacman -S --noconfirm --needed viu

echo "Installing category Internet"

# TeamSpeak is software for quality voice communication via the Internet
sudo pacman -S --noconfirm --needed teamspeak3

# A web browser built for speed, simplicity, and security
#sudo pacman -S --noconfirm --needed chromium

# Fast and reliable FTP, FTPS and SFTP client
#sudo pacman -S --noconfirm --needed filezilla

# Standalone web browser from mozilla.org
#sudo pacman -S --noconfirm --needed firefox

# A popular and easy to use graphical IRC (chat) client
#sudo pacman -S --noconfirm --needed hexchat

# An advanced BitTorrent client programmed in C++, based on Qt toolkit and libtorrent-rasterbar.
#sudo pacman -S --noconfirm --needed qbittorrent

#sudo pacman -S --noconfirm --needed

echo "Installing category Multimedia"

# A modern music player and library organizer
#sudo pacman -S --noconfirm --needed clementine

# A GTK+ audio player for GNU/Linux.
#sudo pacman -S --noconfirm --needed deadbeef

# a free, open source, and cross-platform media player
#sudo pacman -S --noconfirm --needed mpv

# an open-source, non-linear video editor for Linux based on MLT framework
#sudo pacman -S --noconfirm --needed openshot

# A lightweight GTK+ music manager - fork of Consonance Music Manager.
#sudo pacman -S --noconfirm --needed pragha

# Cross-platform Qt based Video Editor
sudo pacman -S --noconfirm --needed shotcut

# A digital photo organizer designed for the GNOME desktop environment
#sudo pacman -S --noconfirm --needed shotwell

# A feature-rich screen recorder that supports X11 and OpenGL
#sudo pacman -S --noconfirm --needed simplescreenrecorder

# Media player with built-in codecs that can play virtually all video and audio formats
#sudo pacman -S --noconfirm --needed smplayer

# Multi-platform MPEG, VCD/DVD, and DivX player
sudo pacman -S --noconfirm --needed vlc

#sudo pacman -S --noconfirm --needed

echo "Installing category Office"

# Document viewer (PDF, Postscript, djvu, tiff, dvi, XPS, SyncTex support with gedit, comics books (cbr,cbz,cb7 and cbt))
#sudo pacman -S --noconfirm --needed evince

# Manage your email, contacts and schedule
#sudo pacman -S --noconfirm --needed evolution

# Standalone mail and news reader from mozilla.org
sudo pacman -S --noconfirm --needed thunderbird

# A lightweight email client for the GNOME desktop
#sudo pacman -S --noconfirm --needed geary

# LibreOffice branch which contains new features and program enhancements
sudo pacman -S --noconfirm --needed libreoffice-fresh

# Nextcloud desktop client
sudo pacman -S --noconfirm --needed nextcloud-client

# Document Viewer
sudo pacman -S --noconfirm --needed okular

# Handwriting notetaking software with PDF annotation support
sudo pacman -S --noconfirm --needed xournalpp

#sudo pacman -S --noconfirm --needed

echo "Installing category Other"

#sudo pacman -S --noconfirm --needed

echo "Installing category System"

# A cross-platform, GPU-accelerated terminal emulator
sudo pacman -S --noconfirm --needed alacritty

# Provide a simple visual front end for XRandR 1.2.
sudo pacman -S --noconfirm --needed arandr

# A flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell
sudo pacman -S --noconfirm --needed arc-gtk-theme

# D-Bus interface for user account query and manipulation
sudo pacman -S --noconfirm --needed accountsservice

# Output a logo and various system information
#sudo pacman -S --noconfirm --needed archey3

# Open-source KVM software based on Synergy (GUI)
sudo pacman -S --noconfirm --needed barrier
mkdir -p ~/.config/Debauchee/
cp $scriptdir/Barrier/$(hostname)/* ~/.config/Debauchee/

# Resource monitor that shows usage and stats for processor, memory, disks, network and processes
#sudo pacman -S --noconfirm --needed bpytop

# A graphical directory tree analyzer
#sudo pacman -S --noconfirm --needed baobab

# Deletes unneeded files to free disk space and maintain privacy
#sudo pacman -S --noconfirm --needed bleachbit

# Lightweight battery icon for the system tray
sudo pacman -S --noconfirm --needed cbatticon

# An URL retrieval utility and library
sudo pacman -S --noconfirm --needed curl

# dconf Editor
# sudo pacman -S --noconfirm --needed dconf-editor

# Generic menu for X
sudo pacman -S --noconfirm --needed dmenu

# Desktop Management Interface table related utilities
#sudo pacman -S --noconfirm --needed dmidecode

# DOS filesystem utilities
sudo pacman -S --noconfirm --needed dosfstools

# Fast and light imlib2-based image viewer
sudo pacman -S --noconfirm --needed feh

# Complete solution to record, convert and stream audio and video
sudo pacman -S --noconfirm --needed ffmpeg

# Lightweight video thumbnailer that can be used by file managers
sudo pacman -S --noconfirm --needed ffmpegthumbnailer

# CLI curses-based monitoring tool
#sudo pacman -S --noconfirm --needed glances

# Disk Management Utility for GNOME
sudo pacman -S --noconfirm --needed gnome-disk-utility

# Stores passwords and encryption keys
sudo pacman -S --noconfirm --needed gnome-keyring

# View current processes and monitor system state
#sudo pacman -S --noconfirm --needed gnome-system-monitor

# The GNOME Terminal Emulator
#sudo pacman -S --noconfirm --needed gnome-terminal

# Graphical interface for advanced GNOME 3 settings (Tweak Tool)
#sudo pacman -S --noconfirm --needed gnome-tweaks

# A Partition Magic clone, frontend to GNU Parted
sudo pacman -S --noconfirm --needed gparted

# GTK+ GUI for rsync to synchronize folders, files and make backups
#sudo pacman -S --noconfirm --needed grsync

# GTK2 engine to make your desktop look like a 'murrina',
# an italian word meaning the art glass works done by Venicians glass blowers.
# sudo pacman -S --noconfirm --needed gtk-engine-murrine

# Drop-down terminal for GNOME
# sudo pacman -S --noconfirm --needed guake

# Virtual filesystem implementation for GIO
sudo pacman -S --noconfirm --needed gvfs gvfs-mtp

# A system information and benchmark tool
sudo pacman -S --noconfirm --needed hardinfo

# Gives you the temperature of your hard drive by reading S.M.A.R.T. information
# sudo pacman -S --noconfirm --needed hddtemp

# Interactive process viewer
sudo pacman -S --noconfirm --needed htop

# Improved screenlocker based upon XCB and PAM
sudo pacman -S --noconfirm --needed i3lock
mkdir -p ~/Pictures
cp $scriptdir/i3lock/$(hostname)/i3lock.png ~/Pictures/

# A collection of common network programs
sudo pacman -S --noconfirm --needed inetutils

# An image viewing/manipulation program
sudo pacman -S --noconfirm --needed imagemagick

# SVG-based theme engine for Qt5 (including config tool and extra themes)
# sudo pacman -S --noconfirm --needed kvantum-qt5

# Arc theme for Kvantum
# sudo pacman -S --noconfirm --needed kvantum-theme-arc

# Headers and scripts for building modules for the Linux kernel
sudo pacman -S --noconfirm --needed linux-headers

# Headers and scripts for building modules for the LTS Linux kernel
sudo pacman -S --noconfirm --needed linux-lts-headers

# Collection of user space tools for general SMBus access and hardware monitoring
# sudo pacman -S --noconfirm --needed lm_sensors

# LSB version query program
sudo pacman -S --noconfirm --needed lsb-release

# Feature-rich GTK+ theme switcher of the LXDE Desktop
sudo pacman -S --noconfirm --needed lxappearance

# A utility for reading man pages
sudo pacman -S --noconfirm --needed man-db
# Linux man pages
sudo pacman -S --noconfirm --needed man-pages

# Merging locate/updatedb implementation
# sudo pacman -S --noconfirm --needed mlocate

# Configuration tools for Linux networking
sudo pacman -S --noconfirm --needed net-tools

# Background browser and setter for X windows
# sudo pacman -S --noconfirm --needed nitrogen

# Canonical's on-screen-display notification agent,
# implementing the freedesktop.org Desktop Notifications Specification
# with semi-transparent click-through bubbles
#sudo pacman -S --noconfirm --needed notify-osd

# NetworkManager GUI connection editor and widgets
sudo pacman -S --noconfirm --needed nm-connection-editor
# Applet for managing network connections
sudo pacman -S --noconfirm --needed network-manager-applet
# Open client for Cisco AnyConnect VPN
sudo pacman -S --noconfirm --needed openconnect
# NetworkManager VPN plugin for OpenConnect
sudo pacman -S --noconfirm --needed networkmanager-openconnect
# An easy-to-use, robust and highly configurable VPN (Virtual Private Network)
sudo pacman -S --noconfirm --needed openvpn
# NetworkManager VPN plugin for OpenVPN
sudo pacman -S --noconfirm --needed networkmanager-openvpn

# A CLI system information tool written in BASH that supports displaying images.
sudo pacman -S --noconfirm --needed neofetch

# Simple NUMA policy support
sudo pacman -S --noconfirm --needed numactl

# Turns on the numlock key in X11
sudo pacman -S --noconfirm --needed numlockx

# The programmers solid 3D CAD modeller
sudo pacman -S --noconfirm --needed openscad

# Premier connectivity tool for remote login with the SSH protocol
sudo pacman -S --noconfirm --needed openssh

# X compositor that may fix tearing issues
sudo pacman -S --noconfirm --needed picom

# Legacy polkit authentication agent for GNOME
# sudo pacman -S --noconfirm --needed polkit-gnome

# Qt5 Configuration Utility
# sudo pacman -S --noconfirm --needed qt5ct

# A Python 3 module and script to retrieve and filter the latest Pacman mirror list
sudo pacman -S --noconfirm --needed reflector

# A fast and versatile file copying tool for remote and local files
sudo pacman -S --noconfirm --needed rsync

# CLI Bash script to show system/theme info in screenshots
# sudo pacman -S --noconfirm --needed screenfetch

# Simple command-line screenshot utility for X
# sudo pacman -S --noconfirm --needed scrot

# Simple X hotkey daemon
sudo pacman -S --noconfirm --needed sxhkd

# a collection of performance monitoring tools (iostat,isag,mpstat,pidstat,sadf,sar)
sudo pacman -S --noconfirm --needed sysstat

# Terminal emulator that supports tabs and grids
#sudo pacman -S --noconfirm --needed terminator

# Modern file manager for Xfce
sudo pacman -S --noconfirm --needed thunar
# Create and extract archives in Thunar
sudo pacman -S --noconfirm --needed thunar-archive-plugin
# Automatic management of removeable devices in Thunar
sudo pacman -S --noconfirm --needed thunar-volman
# Adds special features for media files to the Thunar File Manager
sudo pacman -S --noconfirm --needed thunar-media-tags-plugin

# A directory listing program displaying a depth indented list of files
sudo pacman -S --noconfirm --needed tree

# D-Bus service for applications to request thumbnails
sudo pacman -S --noconfirm --needed tumbler

# The original ex/vi text editor
sudo pacman -S --noconfirm --needed vi
# Vi Improved, a highly configurable, improved version of the vi text editor
sudo pacman -S --noconfirm --needed vim

# A console-based network traffic monitor
# sudo pacman -S --noconfirm --needed vnstat

# Volume control for the system tray
sudo pacman -S --noconfirm --needed volumeicon

# Network utility to retrieve files from the Web
sudo pacman -S --noconfirm --needed wget

# A compatibility layer for running Windows programs
sudo pacman -S --noconfirm --needed wine

# Control your EWMH compliant window manager from command line
# sudo pacman -S --noconfirm --needed wmctrl

# A small program for hiding the mouse cursor
# sudo pacman -S --noconfirm --needed unclutter

# Unicode enabled rxvt-clone terminal emulator (urxvt)
# sudo pacman -S --noconfirm --needed rxvt-unicode

# URL and Mouseless text selection for rxvt-unicode
# sudo pacman -S --noconfirm --needed urxvt-perls

# Manage user directories like ~/Desktop and ~/Music
sudo pacman -S --noconfirm --needed xdg-user-dirs

# An application finder for Xfce
sudo pacman -S --noconfirm --needed xfce4-appfinder

# Notification daemon for the Xfce desktop
sudo pacman -S --noconfirm --needed xfce4-notifyd

# Power manager for Xfce desktop
sudo pacman -S --noconfirm --needed xfce4-power-manager

# Settings manager for xfce
sudo pacman -S --noconfirm --needed xfce4-settings

# Plugin that makes screenshots for the Xfce panel
# sudo pacman -S --noconfirm --needed xfce4-screenshooter

# Easy to use task manager
sudo pacman -S --noconfirm --needed xfce4-taskmanager

# Lightweight passphrase dialog for SSH
sudo pacman -S --noconfirm --needed x11-ssh-askpass

# Display graphical dialog boxes from shell scripts
sudo pacman -S --noconfirm --needed zenity

#sudo pacman -S --noconfirm --needed


###############################################################################################

# installation of zippers and unzippers
sudo pacman -S --noconfirm --needed unace unrar zip unzip sharutils  uudeview  arj cabextract file-roller
# Command-line file archiver with high compression ratio
sudo pacman -S --noconfirm --needed p7zip

# ########################################################################################################## #

box "Software from standard Arch Linux Repo installed"
