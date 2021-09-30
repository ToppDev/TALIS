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

# Versatile file searching tool
# pacinstall catfish

# A curses-based scrolling 'Matrix'-like screen
#pacinstall cmatrix

# Powerful yet simple to use screenshot software
pacinstall flameshot

# GTK+ based scientific calculator
# pacinstall galculator

# Take pictures of your screen
#pacinstall gnome-screenshot

# Plotting package which outputs to X11, PostScript, PNG, GIF, and others
pacinstall gnuplot

# Cross-platform community-driven port of Keepass password manager
pacinstall keepassxc

# Simple screen recorder with an easy to use interface
pacinstall peek

# Elegant, simple, clean dock
#pacinstall plank

# A simple CD/DVD burning tool based on libburnia libraries
#pacinstall xfburn

# Changes the wallpaper on a regular interval using user-specified or automatically downloaded images.
pacinstall variety


echo "Installing category Development"

# A hackable text editor for the 21st Century
#pacinstall atom

# Compiler cache that speeds up recompilation by caching previous compilations
pacinstall ccache

# A cross-platform open-source make system
pacinstall cmake

# A tool for static C/C++ code analysis
pacinstall cppcheck

# The Open Source build of Visual Studio Code (vscode) editor
pacinstall code
info "Installing VSCode extensions"
mkdir -p ~/.config/Code\ -\ OSS/User
vsextensions=$(cat "$scriptdir/vscode/extensions")
while IFS= read -r line; do
    code --install-extension $line
done <<< "$vsextensions"

# Live Share dependencies
pacinstall gcr liburcu openssl-1.0 krb5 zlib icu gnome-keyring libsecret desktop-file-utils xorg-xprop

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
pacinstall d-feet

# Documentation system for C++, C, Java, IDL and PHP
pacinstall doxygen

# Fast and lightweight IDE
#pacinstall geany

# Compare files, directories and working copies
pacinstall meld

# The GNU Compiler Collection - C and C++ frontends
pacinstall gcc

# The GNU Debugger
pacinstall gdb

# A free, open source, portable framework for graphical application development (x11)
pacinstall glfw-x11

# GNU make utility to maintain groups of programs
pacinstall make

# A module for easy processing of XML
pacinstall perl-xml-twig

# Vulkan Installable Client Driver (ICD) Loader
pacinstall vulkan-icd-loader

# The .NET Core SDK
pacinstall dotnet-sdk

# OpenJDK Java 11 development kit
pacinstall jdk-openjdk

# Group, that contains most TeX Live packages.
pacinstall texlive-most

# Tool to help find memory-management problems in programs
pacinstall valgrind

# Visualization of Performance Profiling Data
pacinstall kcachegrind

# Graph visualization software
pacinstall graphviz

# Fast, multi-threaded malloc and nifty performance analysis tools
pacinstall gperftools

# A program to view PostScript and PDF documents
pacinstall gv

# Interactive viewer for graphs written in Graphviz's dot language
pacinstall xdot

# the fast distributed version control system
pacinstall git

# Command-line X11 automation tool
pacinstall xdotool

# Powerful x86 virtualization for enterprise as well as home use
pacinstall virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
sudo gpasswd -a $(whoami) vboxusers

echo "Installing category Education"

#pacinstall

echo "Installing category Games"

#pacinstall

echo "Installing category Graphics"

# A fully integrated 3D graphics creation suite
pacinstall blender

# Utility to organize and develop raw images
#pacinstall darktable

# GNU Image Manipulation Program
# pacinstall gimp

# A font viewer utility for GNOME
# pacinstall gnome-font-viewer

# Lightweight image viewer
# pacinstall geeqie


# Advanced color picker written in C++ using GTK+ toolkit
#pacinstall gpick

# Professional vector graphics editor
pacinstall inkscape

# Edit and paint images
pacinstall krita

# A Qt image viewer
pacinstall nomacs

# Drawing/editing program modeled after Paint.NET.
# It's goal is to provide a simplified alternative to GIMP for casual users
#pacinstall pinta

# Fast and lightweight picture-viewer for Xfce4
#pacinstall ristretto

# Simple terminal image viewer
pacinstall viu

echo "Installing category Internet"

# TeamSpeak is software for quality voice communication via the Internet
pacinstall teamspeak3

# A web browser built for speed, simplicity, and security
#pacinstall chromium

# Fast and reliable FTP, FTPS and SFTP client
#pacinstall filezilla

# Standalone web browser from mozilla.org
#pacinstall firefox

# A popular and easy to use graphical IRC (chat) client
#pacinstall hexchat

# An advanced BitTorrent client programmed in C++, based on Qt toolkit and libtorrent-rasterbar.
#pacinstall qbittorrent

#pacinstall

echo "Installing category Multimedia"

# A modern music player and library organizer
#pacinstall clementine

# A GTK+ audio player for GNU/Linux.
#pacinstall deadbeef

# a free, open source, and cross-platform media player
#pacinstall mpv

# an open-source, non-linear video editor for Linux based on MLT framework
#pacinstall openshot

# A lightweight GTK+ music manager - fork of Consonance Music Manager.
#pacinstall pragha

# Cross-platform Qt based Video Editor
pacinstall shotcut

# A digital photo organizer designed for the GNOME desktop environment
#pacinstall shotwell

# A feature-rich screen recorder that supports X11 and OpenGL
#pacinstall simplescreenrecorder

# Media player with built-in codecs that can play virtually all video and audio formats
#pacinstall smplayer

# Multi-platform MPEG, VCD/DVD, and DivX player
pacinstall vlc

#pacinstall

echo "Installing category Office"

# Document viewer (PDF, Postscript, djvu, tiff, dvi, XPS, SyncTex support with gedit, comics books (cbr,cbz,cb7 and cbt))
#pacinstall evince

# Manage your email, contacts and schedule
#pacinstall evolution

# Standalone mail and news reader from mozilla.org
pacinstall thunderbird

# A lightweight email client for the GNOME desktop
#pacinstall geary

# LibreOffice branch which contains new features and program enhancements
pacinstall libreoffice-fresh

# Spell checker and morphological analyzer library and program
pacinstall hunspell hunspell-de hunspell-en_us

# Nextcloud desktop client
pacinstall nextcloud-client

# Document Viewer
pacinstall okular

# Handwriting notetaking software with PDF annotation support
pacinstall xournalpp

#pacinstall

echo "Installing category Other"

#pacinstall

echo "Installing category System"

# A cross-platform, GPU-accelerated terminal emulator
pacinstall alacritty

# Provide a simple visual front end for XRandR 1.2.
pacinstall arandr

# A flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell
pacinstall arc-gtk-theme

# D-Bus interface for user account query and manipulation
pacinstall accountsservice

# Output a logo and various system information
#pacinstall archey3

# Open-source KVM software based on Synergy (GUI)
pacinstall barrier

# Resource monitor that shows usage and stats for processor, memory, disks, network and processes
#pacinstall bpytop

# A graphical directory tree analyzer
#pacinstall baobab

# Deletes unneeded files to free disk space and maintain privacy
#pacinstall bleachbit

# Lightweight battery icon for the system tray
pacinstall cbatticon

# An URL retrieval utility and library
pacinstall curl

# dconf Editor
# pacinstall dconf-editor

# Generic menu for X
pacinstall dmenu

# Desktop Management Interface table related utilities
#pacinstall dmidecode

# DOS filesystem utilities
pacinstall dosfstools

# Fast and light imlib2-based image viewer
pacinstall feh

# Complete solution to record, convert and stream audio and video
pacinstall ffmpeg

# Lightweight video thumbnailer that can be used by file managers
pacinstall ffmpegthumbnailer

# CLI curses-based monitoring tool
#pacinstall glances

# Disk Management Utility for GNOME
pacinstall gnome-disk-utility

# Stores passwords and encryption keys
pacinstall gnome-keyring

# View current processes and monitor system state
#pacinstall gnome-system-monitor

# The GNOME Terminal Emulator
#pacinstall gnome-terminal

# Graphical interface for advanced GNOME 3 settings (Tweak Tool)
#pacinstall gnome-tweaks

# A Partition Magic clone, frontend to GNU Parted
pacinstall gparted

# GTK+ GUI for rsync to synchronize folders, files and make backups
#pacinstall grsync

# GTK2 engine to make your desktop look like a 'murrina',
# an italian word meaning the art glass works done by Venicians glass blowers.
# pacinstall gtk-engine-murrine

# Drop-down terminal for GNOME
# pacinstall guake

# Virtual filesystem implementation for GIO
pacinstall gvfs gvfs-mtp

# A system information and benchmark tool
pacinstall hardinfo

# Gives you the temperature of your hard drive by reading S.M.A.R.T. information
# pacinstall hddtemp

# Interactive process viewer
pacinstall htop

# Improved screenlocker based upon XCB and PAM
pacinstall i3lock

# A collection of common network programs
pacinstall inetutils

# An image viewing/manipulation program
pacinstall imagemagick

# SVG-based theme engine for Qt5 (including config tool and extra themes)
# pacinstall kvantum-qt5

# Arc theme for Kvantum
# pacinstall kvantum-theme-arc

# Headers and scripts for building modules for the Linux kernel
pacinstall linux-headers

# Headers and scripts for building modules for the LTS Linux kernel
pacinstall linux-lts-headers

# Collection of user space tools for general SMBus access and hardware monitoring
# pacinstall lm_sensors

# LSB version query program
pacinstall lsb-release

# Feature-rich GTK+ theme switcher of the LXDE Desktop
pacinstall lxappearance

# A utility for reading man pages
pacinstall man-db
# Linux man pages
pacinstall man-pages

# Merging locate/updatedb implementation
# pacinstall mlocate

# Configuration tools for Linux networking
pacinstall net-tools

# Background browser and setter for X windows
# pacinstall nitrogen

# Canonical's on-screen-display notification agent,
# implementing the freedesktop.org Desktop Notifications Specification
# with semi-transparent click-through bubbles
#pacinstall notify-osd

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

# Simple NUMA policy support
pacinstall numactl

# Turns on the numlock key in X11
pacinstall numlockx

# The programmers solid 3D CAD modeller
pacinstall openscad

# Premier connectivity tool for remote login with the SSH protocol
pacinstall openssh

# X compositor that may fix tearing issues
pacinstall picom

# Legacy polkit authentication agent for GNOME
# pacinstall polkit-gnome

# Qt5 Configuration Utility
# pacinstall qt5ct

# A Python 3 module and script to retrieve and filter the latest Pacman mirror list
pacinstall reflector

# A fast and versatile file copying tool for remote and local files
pacinstall rsync

# CLI Bash script to show system/theme info in screenshots
# pacinstall screenfetch

# Simple command-line screenshot utility for X
# pacinstall scrot

# Simple X hotkey daemon
pacinstall sxhkd

# a collection of performance monitoring tools (iostat,isag,mpstat,pidstat,sadf,sar)
pacinstall sysstat

# Terminal emulator that supports tabs and grids
#pacinstall terminator

# Modern file manager for Xfce
pacinstall thunar
# Create and extract archives in Thunar
pacinstall thunar-archive-plugin
# Automatic management of removeable devices in Thunar
pacinstall thunar-volman
# Adds special features for media files to the Thunar File Manager
pacinstall thunar-media-tags-plugin

# A directory listing program displaying a depth indented list of files
pacinstall tree

# D-Bus service for applications to request thumbnails
pacinstall tumbler

# The original ex/vi text editor
pacinstall vi
# Vi Improved, a highly configurable, improved version of the vi text editor
pacinstall vim

# A console-based network traffic monitor
# pacinstall vnstat

# Volume control for the system tray
pacinstall volumeicon

# Network utility to retrieve files from the Web
pacinstall wget

# A compatibility layer for running Windows programs
pacinstall wine

# Control your EWMH compliant window manager from command line
# pacinstall wmctrl

# A small program for hiding the mouse cursor
# pacinstall unclutter

# Unicode enabled rxvt-clone terminal emulator (urxvt)
# pacinstall rxvt-unicode

# URL and Mouseless text selection for rxvt-unicode
# pacinstall urxvt-perls

# Manage user directories like ~/Desktop and ~/Music
pacinstall xdg-user-dirs

# An application finder for Xfce
pacinstall xfce4-appfinder

# Notification daemon for the Xfce desktop
pacinstall xfce4-notifyd

# Power manager for Xfce desktop
pacinstall xfce4-power-manager

# Settings manager for xfce
pacinstall xfce4-settings

# Plugin that makes screenshots for the Xfce panel
# pacinstall xfce4-screenshooter

# Easy to use task manager
pacinstall xfce4-taskmanager

# Lightweight passphrase dialog for SSH
pacinstall x11-ssh-askpass

# Display graphical dialog boxes from shell scripts
pacinstall zenity

#pacinstall


###############################################################################################

# installation of zippers and unzippers
pacinstall unace unrar zip unzip sharutils  uudeview  arj cabextract file-roller
# Command-line file archiver with high compression ratio
pacinstall p7zip

# ########################################################################################################## #

box "Software from standard Arch Linux Repo installed"
