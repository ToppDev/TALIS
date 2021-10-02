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
#                                           Repositories & Keyring                                           #
# ########################################################################################################## #

box "Repositories & Keyring"

# Make pacman colorful and add eye candy on the progress bar
sudo grep -q "^Color" /etc/pacman.conf || sudo sed -i "s/^#Color$/Color/" /etc/pacman.conf
sudo grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# Reinstall Keyrings
info "Refreshing Arch Keyring..."
sudo pacman --noconfirm -S gnupg archlinux-keyring

if is_artixlinux; then
    sudo pacman --noconfirm -S artix-archlinux-support artix-keyring
fi

if is_archlinux; then
    # Enable 32-bit support
    sudo sed -i '/#\[multilib\]/,+1{/#\[multilib\]/ n; s/^#//}' /etc/pacman.conf # Remove comment in next line after '#[multilib]'
    sudo sed -i '/#\[multilib\]/s/^.//' /etc/pacman.conf                         # Remove comment at start of line '#[multilib]'
elif is_artixlinux; then
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
else
    error "System not supported"
fi

# Reset the Keychain
sudo rm -r /etc/pacman.d/gnupg
sudo pacman-key --init
if is_archlinux; then
    sudo pacman-key --populate archlinux
elif is_artixlinux; then
    sudo pacman-key --populate archlinux artix
else
    error "System not supported"
fi
# Update package database
sudo pacman -Sy

# ########################################################################################################## #
#                                               Necessary Tools                                              #
# ########################################################################################################## #

box "Necessary Tools"

installpkg curl base-devel git ntp

# Use all cores for compilation
sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$(nproc)"' -z -)/g' /etc/makepkg.conf

info "Synchronizing time..."
sudo ntpdate 0.europe.pool.ntp.org

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
putgitrepo "$dotfilesrepo" "$repodir" "$repobranch"

xdg-user-dirs-update --force
rmdir "/home/$(whoami)/Desktop" >/dev/null 2>&1
rmdir "/home/$(whoami)/Music" >/dev/null 2>&1
rmdir "/home/$(whoami)/Public" >/dev/null 2>&1
rmdir "/home/$(whoami)/Templates" >/dev/null 2>&1
rmdir "/home/$(whoami)/Videos" >/dev/null 2>&1

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