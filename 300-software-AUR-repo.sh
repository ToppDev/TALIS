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

echo "Installing category Accessories"

# A GUI to write .img or .iso files to a USB Key. It can also format them
aurinstall mintstick
# Python module for GNU parted (needed by mintstick)
aurinstall python-pyparted

echo "Installing category Development"

# A distributed, open source, C/C++ package manager.
aurinstall conan


echo "Installing category Education"


echo "Installing category Games"


echo "Installing category Graphics"


echo "Installing category Internet"

# Download manager, written in Java, for one-click hosting sites like
# Rapidshare and Megaupload. Uses its own updater.
aurinstall jdownloader2
sudo sed -i 's/Exec=/Exec=export _JAVA_AWT_WM_NONREPARENTING=1 \&\& /' /usr/share/applications/jdownloader.desktop

# Drive for PC, the desktop utility of the DSM add-on package,
# Drive, allows you to sync and share files owned by you or shared
# by others between a centralized Synology NASand multiple client computers.
#aurinstall synology-drive

# The popular and trusted web browser by Google (Stable Channel)
aurinstall google-chrome
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

aurinstall brave-bin
sudo sh -c 'echo "[Desktop Entry]
Version=1.0
Name=Brave Incognito

# Gnome and KDE 3 uses Comment.
Comment=Access the Internet Incognito
Comment[de]=Inkognito Internetzugriff
Comment[en_GB]=Access the Internet Incognito
StartupWMClass=brave-browser
Exec=brave --incognito %U
StartupNotify=true
Terminal=false
Icon=brave
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Actions=new-window;new-private-window;" > /usr/share/applications/brave-browser-incognito.desktop'

echo "Installing category Multimedia"

# A proprietary music streaming service
gpg --keyserver keyserver.ubuntu.com --recv-keys D1742AD60D811D58
aurinstall spotify

echo "Installing category Office"

# A note taking and to-do application with synchronization capabilities - Desktop
aurinstall joplin-desktop

# Slack Desktop (Beta) for Linux
aurinstall slack-desktop

# Zotero Standalone. Is a free, easy-to-use tool to help you collect, organize, cite, and share your research sources.
aurinstall zotero

echo "Installing category Other"


echo "Installing category System"

# Bash script for downgrading one or more packages to a version in your cache or the A.L.A.
aurinstall downgrade

# A much faster replacement for i3-dmenu-desktop. Its purpose is to find .desktop files and offer you a menu to start an application using dmenu.
gpg --keyserver keyserver.ubuntu.com --recv-keys 9B8450B91D1362C1
aurinstall j4-dmenu-desktop

# Sardi is an icon collection for any linux distro with 6 different circular icons and 10 different kind of folders.
aurinstall sardi-icons

# Breeze cursor theme (KDE Plasma 5). This package is for usage in non-KDE Plasma desktops.
aurinstall xcursor-breeze
sudo mkdir -p /usr/share/icons/default
sudo sh -c 'echo -e "[Icon Theme]\nInherits=Breeze_Snow" > /usr/share/icons/default/index.theme'

# these come always last

# Fixes Hardcoded Icons
aurinstall hardcode-fixer-git
sudo hardcode-fixer

# ########################################################################################################## #

box "Software from AUR Repository installed"
