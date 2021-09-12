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

pacinstall cups cups-pdf

#first try if you can print without foomatic
#pacinstall foomatic-db-engine
#pacinstall foomatic-db foomatic-db-ppds foomatic-db-nonfree-ppds foomatic-db-gutenprint-ppds

pacinstall ghostscript gsfonts gutenprint
# pacinstall gtk3-print-backends
pacinstall libcups
pacinstall hplip
# pacinstall system-config-printer

sudo systemctl enable cups.service

# Scanner Access Now Easy
pacinstall sane
# Simple scanning utility
pacinstall simple-scan

# ########################################################################################################## #

box "Printer management software installed"