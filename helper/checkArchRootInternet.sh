#!/bin/sh
# ToppDev's Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #

# Check if user is root on Arch distro and has internet
check_arch_root_internet() {
    pacman --noconfirm --needed -Sy curl >/dev/null 2>&1 || error "Are you sure you're running this as the root user, are on an Arch-based distribution and have an internet connection?"
}

# Check if user is root on Arch distro and has internet
check_arch_internet() {
    user=`whoami`
    if [ $user = "root" ]; then
        error "ERROR: Don't run this script as root"
    fi
    sudo pacman --noconfirm --needed -Sy curl >/dev/null 2>&1 || error "Are you sure the current user has sudo rights, are on an Arch-based distribution and have an internet connection?"
}