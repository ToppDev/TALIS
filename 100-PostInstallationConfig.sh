#!/bin/sh
# ToppDev's Artix Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# Some parts of the script use functions from
# Luke's Auto Rice Boostrapping Script (LARBS) by Luke Smith <luke@lukesmith.xyz>
# Please pay him a visit
# - https://lukesmith.xyz/
# - https://larbs.xyz/

# ########################################################################################################## #
#                                               Helper scripts                                               #
# ########################################################################################################## #

scriptdir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source "$scriptdir/helper/color.sh"
source "$scriptdir/helper/log.sh"
source "$scriptdir/helper/user.sh"
source "$scriptdir/helper/install.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"
source "$scriptdir/helper/sudo.sh"

# ########################################################################################################## #
#                                            Options and Variables                                           #
# ########################################################################################################## #

# Print the usage message
usage() {
    echo "Required arguments:"
    echo "  -r: Dotfiles repository (local file or url)"
    echo "Optional arguments:"
    echo "  -h: Show this message"
    exit 1
}

while getopts ":a:r:b:p:h" flag; do
    case "${flag}" in
        h) usage ;;
        r) dotfilesrepo=${OPTARG} && git ls-remote "$dotfilesrepo" >/dev/null || exit 1 ;;
        b) repobranch=${OPTARG} ;;
        *) printf "Invalid option: -%s\\n" "$OPTARG" && exit 1 ;;
    esac
done

[ -z "$dotfilesrepo" ] && echo -e "Dotfiles repository is required. Please specify -r\\n" && usage
[ -z "$repobranch" ] && repobranch="main"

# ########################################################################################################## #
#                                              Check Arch distro                                             #
# ########################################################################################################## #

check_arch_internet

export repodir="/home/$(whoami)/.local/src"

# ########################################################################################################## #
#                                           Repositories & Keyring                                           #
# ########################################################################################################## #

box "Repositories & Keyring"

# Make pacman colorful and add eye candy on the progress bar
sudo grep -q "^Color" /etc/pacman.conf || sudo sed -i "s/^#Color$/Color/" /etc/pacman.conf
sudo grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# Reinstall Keyrings
info "Refreshing Arch Keyring..."
sudo pacman --noconfirm -S artix-archlinux-support gnupg artix-keyring archlinux-keyring

# Enable 32-bit support
sudo sed -i '/#\[lib32\]/,+1{/#\[lib32\]/ n; s/^#//}' /etc/pacman.conf # Remove comment in next line after '#[lib32]'
sudo sed -i '/#\[lib32\]/s/^.//' /etc/pacman.conf                      # Remove comment at start of line '#[lib32]'
# Add Arch repositories
if ! grep -q -o "\[[^]]*extra\]" /etc/pacman.conf; then
    sudo bash -c 'echo "" >> /etc/pacman.conf'
    sudo bash -c 'echo "[extra]" >> /etc/pacman.conf'
    sudo bash -c 'echo "Include = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf'
fi
if ! grep -q -o "\[[^]]*community\]" /etc/pacman.conf; then
    sudo bash -c 'echo "" >> /etc/pacman.conf'
    sudo bash -c 'echo "[community]" >> /etc/pacman.conf'
    sudo bash -c 'echo "Include = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf'
fi
if ! grep -q -o "\[[^]]*multilib\]" /etc/pacman.conf; then
    sudo bash -c 'echo "" >> /etc/pacman.conf'
    sudo bash -c 'echo "[multilib]" >> /etc/pacman.conf'
    sudo bash -c 'echo "Include = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf'
fi

# Copy pacman hooks
sudo cp $scriptdir/libalpm-hooks/* /usr/share/libalpm/hooks/

# Reset the Keychain
sudo rm -r /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux artix
# Update package database
sudo pacman -Sy

# ########################################################################################################## #
#                                               Necessary Tools                                              #
# ########################################################################################################## #

box "Necessary Tools"

pacinstall curl base-devel git ntp zsh

# Use all cores for compilation
sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$(nproc)"' -z -)/g' /etc/makepkg.conf

info "Synchronizing time..."
sudo ntpdate 0.europe.pool.ntp.org >/dev/null 2>&1

# ########################################################################################################## #
#                                                 Aur Helper                                                 #
# ########################################################################################################## #

# AUR Package Manager (trizen)
# https://github.com/trizen/trizen
trizenexists=`pacman -Qs trizen`
if [ ! "$trizenexists" ]; then
    git clone https://aur.archlinux.org/trizen.git /tmp/git-trizen
    cd /tmp/git-trizen
    makepkg --noconfirm -si
    cd $scriptdir
    rm -r -f /tmp/git-trizen
fi

# ########################################################################################################## #
#                                                  X Server                                                  #
# ########################################################################################################## #

if lspci -v | grep -A1 -e VGA -e 3D | grep -q "Intel"; then
    pacinstall xf86-video-intel mesa lib32-mesa
    # Problems with some intel chips (https://wiki.archlinux.de/title/Intel)
    sudo sed -i 's/MODULES=()/MODULES=(intel_agp i915)/g' /etc/mkinitcpio.conf
    sudo mkinitcpio -p linux
elif lspci -v | grep -A1 -e VGA -e 3D | grep -q "NVIDIA"; then
    pacinstall nvidia nvidia-utils nvidia-settings lib32-nvidia-utils
elif lspci -v | grep -A1 -e VGA -e 3D | grep -q "AMD"; then
    pacinstall xf86-video-amdgpu mesa lib32-mesa
elif lspci -v | grep -A1 -e VGA -e 3D | grep -q "ATI"; then
    pacinstall xf86-video-ati mesa lib32-mesa
fi

pacinstall xorg-server xorg-apps xorg-xinit

# Tap to click
pacinstall xf86-input-synaptics
[ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
    Identifier "libinput touchpad catchall"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
    # Enable left mouse button by tapping
    Option "Tapping" "on"
EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

# Close TCP Port 6000
[ -f "/usr/bin/startx" ] && sed -i 's/defaultserverargs=""/defaultserverargs="-nolisten tcp"/' /usr/bin/startx

# ########################################################################################################## #
#                                                   LightDM                                                  #
# ########################################################################################################## #

# GTK+ greeter for LightDM
pacinstall lightdm-gtk-greeter
# Settings editor for the LightDM GTK+ Greeter
pacinstall lightdm-gtk-greeter-settings
# A nested X server that runs as an X application
pacinstallxorg-server-xephyr

sudo mkdir -p /usr/share/xsessions
sudo mkdir -p /usr/share/pixmaps/

# LightDM config
echo "[Desktop Entry]
Encoding=UTF-8
Name=Dynamic Window Manager
Comment=Runs the window manager defined by xsession script
Icon=dmw
Type=XSession
Exec=dwm" > /usr/share/xsessions/dwm.desktop
echo "[greeter]
theme-name = Arc-Dark
icon-theme-name = Sardi-Arc
font-name = Inconsolata Nerd Font Medium 13
background = /usr/share/pixmaps/lightdm-background.jpg
clock-format =  %a %d.%b  %R
" > /etc/lightdm/lightdm-gtk-greeter.conf

# TODO: enable lightdm

# ########################################################################################################## #
#                                                     Zsh                                                    #
# ########################################################################################################## #

box "Zsh"

# Install Oh My Zsh
if [ ! -d "/home/$(whoami)/.local/share/oh-my-zsh" ]; then
   export ZSH="/home/$(whoami)/.local/share/oh-my-zsh"
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi

# Make zsh the default shell for the user.
sudo chsh -s /bin/zsh $(whoami)
mkdir -p "/home/$(whoami)/.cache/zsh/"

# Fish-like autosuggestions for zsh
pacinstall zsh-autosuggestions
# Powerlevel10k is a theme for Zsh. It emphasizes speed, flexibility and out-of-the-box experience
pacinstall zsh-theme-powerlevel10k
# Additional completion definitions for Zsh
pacinstall zsh-completions
# Optimized and extended zsh-syntax-highlighting
aurinstall zsh-fast-syntax-highlighting

# TODO: Add zsh-fast-syntax-highlighting to the .zshrc
# TODO: Add zsh-autosuggestions to the .zshrc
# TODO: Add zsh-theme-powerlevel10k to the .zshrc
# TODO: Add zsh-completions to the .zshrc

# ########################################################################################################## #
#                                                  Dotfiles                                                  #
# ########################################################################################################## #

box "Dotfiles"

# Install the dotfiles in the user's home directory
info "Downloading and installing config files..."
[ -z "$repobranch" ] && branch="master" || branch="$repobranch"
dir=$(mktemp -d)
[ ! -d "/home/$(whoami)" ] && mkdir -p "/home/$(whoami)"
sudo chown "$(whoami)":wheel "$dir" "/home/$(whoami)"
git clone --recursive -b "$branch" --depth 1 --recurse-submodules "$dotfilesrepo" "$dir"
cp -rfT "$dir" "/home/$(whoami)"
rm -f "/home/$(whoami)/README.md" #"/home/$(whoami)/LICENSE" "/home/$(whoami)/FUNDING.yml"

# make git ignore deleted LICENSE & README.md files
git update-index --assume-unchanged "/home/$(whoami)/README.md" #"/home/$(whoami)/LICENSE" "/home/$(whoami)/FUNDING.yml"

# ########################################################################################################## #
#                                            Misc program configs                                            #
# ########################################################################################################## #

box "Misc program configs"

# Coloring in nano
pacinstall nano
[ -f "/etc/nanorc" ] && sudo sed -i -e '/# include "\/usr\/share\/nano\/\*\.nanorc/s/^# //' /etc/nanorc

# System beep
sudo rmmod pcspkr
sudo bash -c 'echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf'

# dbus UUID must be generated for Artix runit.
sudo dbus-uuidgen > /var/lib/dbus/machine-id

# Use system notifications for Brave on Artix
sudo bash -c 'echo "export \$(dbus-launch)" > /etc/profile.d/dbus.sh'

# ########################################################################################################## #
#                                                   Cleanup                                                  #
# ########################################################################################################## #

unset password

# ########################################################################################################## #
#                                                  Finished                                                  #
# ########################################################################################################## #

box "Installation finished, please reboot"