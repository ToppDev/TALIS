#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# Some parts of this script have been adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)

# ########################################################################################################## #
#                                               Helper scripts                                               #
# ########################################################################################################## #

export scriptdir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

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
    echo "  -p: Dependencies and programs csv (local file or url)"
    echo "Optional arguments:"
    echo "  -h: Show this message"
    exit 1
}

while getopts ":a:r:b:p:h" flag; do
    case "${flag}" in
        h) usage ;;
        r) dotfilesrepo=${OPTARG} ;;
        b) repobranch=${OPTARG} ;;
        p) progsfile=${OPTARG} ;;
        *) printf "Invalid option: -%s\\n" "$OPTARG" && exit 1 ;;
    esac
done

[ -z "$dotfilesrepo" ] && echo -e "Dotfiles repository is required. Please specify -r\\n" && usage
[ -z "$repobranch" ] && repobranch="main"
[ -z "$progsfile" ] && progsfile="https://raw.githubusercontent.com/ToppDev/TALIS/main/progs.csv"

git ls-remote "$dotfilesrepo" -b $repobranch | grep -q $repobranch || error "The remote repository \"$dotfilesrepo\" on branch \"$repobranch\" can't be accessed."

# ########################################################################################################## #
#                                              Check Arch distro                                             #
# ########################################################################################################## #

check_arch_internet

export repodir="/home/$(whoami)/.local/src"

# ########################################################################################################## #
#                                            User root permissions                                           #
# ########################################################################################################## #

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.
sudoperms "%wheel ALL=(ALL) NOPASSWD: ALL"

# ########################################################################################################## #
#                                                 Aur Helper                                                 #
# ########################################################################################################## #

manualinstall yay-bin || error "Failed to install AUR helper."

# ########################################################################################################## #
#                                               Windows Manager                                              #
# ########################################################################################################## #

# TODO: Install dwm here

# Fallback display manager
#installpkg xfce4 xfce4-goodies


# ########################################################################################################## #
#                                            Package installation                                            #
# ########################################################################################################## #

installationloop

# ########################################################################################################## #
#                                                  Dotfiles                                                  #
# ########################################################################################################## #

box "Dotfiles"

# Install the dotfiles in the user's home directory
putdotfiles "$dotfilesrepo" "$repobranch"

mkdir -p "/home/$(whoami)/Downloads"
mkdir -p "/home/$(whoami)/Documents"
mkdir -p "/home/$(whoami)/Pictures"

# ########################################################################################################## #
#                                            Misc program configs                                            #
# ########################################################################################################## #

box "Misc program configs"

# System beep
sudo rmmod pcspkr >/dev/null 2>&1
sudo sh -c "echo 'blacklist pcspkr' > /etc/modprobe.d/nobeep.conf"


# ########################################################################################################## #
#                                                 Sudo config                                                #
# ########################################################################################################## #

# Remove the previous 'NOPASSWD ALL' and set new permissions
sudoperms "%wheel ALL=(ALL) ALL" \
          "%users ALL=(ALL) NOPASSWD: /usr/bin/halt,/usr/bin/shutdown,/usr/bin/reboot,/usr/bin/poweroff" \
          "%users ALL=(ALL) NOPASSWD: /usr/bin/bluetooth on,/usr/bin/bluetooth off" \
          "%wheel ALL=(ALL) NOPASSWD: /usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/loadkeys" \
          "%wheel ALL=(ALL) NOPASSWD: /usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/pacman -Syyu --noconfirm"

# ########################################################################################################## #
#                                                  Finished                                                  #
# ########################################################################################################## #

box "Post Installation Configuration finished"