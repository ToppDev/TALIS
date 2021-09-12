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
trizen -S --noconfirm --needed --noedit mintstick
# Python module for GNU parted (needed by mintstick)
trizen -S --noconfirm --needed --noedit python-pyparted

echo "Installing category Development"

# A distributed, open source, C/C++ package manager.
trizen -S --noconfirm --needed --noedit conan


echo "Installing category Education"


echo "Installing category Games"


echo "Installing category Graphics"


echo "Installing category Internet"

# Download manager, written in Java, for one-click hosting sites like
# Rapidshare and Megaupload. Uses its own updater.
trizen -S --noconfirm --needed --noedit jdownloader2
sed -i 's/Exec=/Exec=export _JAVA_AWT_WM_NONREPARENTING=1 \&\& /' /usr/share/applications/jdownloader.desktop

# Drive for PC, the desktop utility of the DSM add-on package,
# Drive, allows you to sync and share files owned by you or shared
# by others between a centralized Synology NASand multiple client computers.
#trizen -S --noconfirm --needed --noedit synology-drive

# The popular and trusted web browser by Google (Stable Channel)
trizen -S --noconfirm --needed --noedit google-chrome
sudo bash -c 'echo "[Desktop Entry]
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

trizen -S --noconfirm --needed --noedit brave-bin
sudo bash -c 'echo "[Desktop Entry]
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
trizen -S --noconfirm --needed --noedit spotify

echo "Installing category Office"

# A note taking and to-do application with synchronization capabilities - Desktop
trizen -S --noconfirm --needed --noedit joplin-desktop

# Simple & Secure Password Management
#trizen -S --noconfirm --needed --noedit passwordsafe

# Slack Desktop (Beta) for Linux
trizen -S --noconfirm --needed --noedit slack-desktop

# Zotero Standalone. Is a free, easy-to-use tool to help you collect, organize, cite, and share your research sources.
trizen -S --noconfirm --needed --noedit zotero

echo "Installing category Other"


echo "Installing category System"


# libXft with BGRA glyph (color emoji) rendering & scaling patches by Maxime Coste
trizen -S --noconfirm --needed  libxft-bgra-git

# Bash script for downgrading one or more packages to a version in your cache or the A.L.A.
trizen -S --noconfirm --needed --noedit downgrade

# A much faster replacement for i3-dmenu-desktop. Its purpose is to find .desktop files and offer you a menu to start an application using dmenu.
gpg --keyserver keyserver.ubuntu.com --recv-keys 9B8450B91D1362C1
trizen -S --noconfirm --needed --noedit j4-dmenu-desktop

# Sardi is an icon collection for any linux distro with 6 different circular icons and 10 different kind of folders.
trizen -S --noconfirm --needed --noedit sardi-icons

# Breeze cursor theme (KDE Plasma 5). This package is for usage in non-KDE Plasma desktops.
trizen -S --noconfirm --needed --noedit xcursor-breeze
mkdir -p /usr/share/icons/default
bash -c 'echo -e "[Icon Theme]\nInherits=Breeze_Snow" > /usr/share/icons/default/index.theme'

# these come always last

# Fixes Hardcoded Icons
trizen -S --noconfirm --needed --noedit hardcode-fixer-git
hardcode-fixer

# ########################################################################################################## #

box "Software from AUR Repository installed"
