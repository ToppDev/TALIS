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

sudo sh -c 'echo "[Desktop Entry]
Version=1.0
Name=Google Chrome Incognito

# Gnome and KDE 3 uses Comment.
Comment=Access the Internet Incognito
Comment[de]=Inkognito Internetzugriff
Comment[en_GB]=Access the Internet Incognito
StartupWMClass=Google-chrome
Exec=/usr/bin/google-chrome-stable --incognito %U
StartupNotify=true
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Actions=new-window;new-private-window;" > /usr/share/applications/google-chrome-incognito.desktop'