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
    echo "Optional arguments:"
    echo "  -p | --progs     Dependency and programs csv (local file or url) (Default: ./progs.csv)"
    echo "  -d | --dotfiles  Dotfiles repository. Empty to do nothing. (Default: Empty)"
    echo "  --dotbranch      Branch of the Dotfiles repository (Default: main)"
    echo "  --privaterepo    Private script repository (Default: Empty)"
    echo "  --privatebranch  Branch of the private script repository (Default: main)"
    echo "  -h               Show this message"
    exit 1
}

# NOTE: This requires GNU getopt.  On Mac OS X and FreeBSD, you have to install this
# separately; see below. (see https://stackoverflow.com/a/7948533)
TEMP=$(getopt -o hp:d: --long progs:,dotfiles:,dotbranch:,privaterepo:,privatebranch: \
              -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around '$TEMP': they are essential!
eval set -- "$TEMP"

while true; do
  case "$1" in
    -h ) usage ;;
    -p | --progs ) progsfile="$2"; shift 2 ;;
    -d | --dotfiles ) dotfilesrepo="$2"; shift 2 ;;
    --dotbranch ) dotfilesbranch="$2"; shift 2 ;;
    --privaterepo ) privaterepo="$2"; shift 2 ;;
    --privatebranch ) privatebranch="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

[ -z "$progsfile" ] && progsfile="$scriptdir/progs.csv"
[ -z "$dotfilesbranch" ] && dotfilesbranch="main"
[ -z "$privatebranch" ] && privatebranch="main"

git config credential.helper >> /dev/null || git config --global credential.helper 'cache --timeout=3600'

if [ ! -z "$dotfilesrepo" ]; then
  git ls-remote "$dotfilesrepo" -b $dotfilesbranch | grep -q $dotfilesbranch || error "The remote repository \"$dotfilesrepo\" on branch \"$dotfilesbranch\" can't be accessed."
fi

if [ ! -z "$privaterepo" ]; then
  git ls-remote "$privaterepo" -b $privatebranch | grep -q $privatebranch || error "The remote repository \"$privaterepo\" on branch \"$privatebranch\" can't be accessed."
fi

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
#                                                  Dotfiles                                                  #
# ########################################################################################################## #

if [ ! -z "$dotfilesrepo" ]; then
  box "Installing Dotfiles"

  # Install the dotfiles in the user's home directory
  putdotfiles "$dotfilesrepo" "$dotfilesbranch"

  [ -f $HOME/.config/shell/profile ] && source $HOME/.config/shell/profile
fi

# ########################################################################################################## #
#                                            Package installation                                            #
# ########################################################################################################## #

installationloop

# ########################################################################################################## #
#                                                  Dotfiles                                                  #
# ########################################################################################################## #

if [ ! -z "$dotfilesrepo" ]; then
  box "Resetting Dotfiles"

  # Reset the dotfiles in the user's home directory
  putdotfiles "$dotfilesrepo" "$dotfilesbranch"
fi

mkdir -p "/home/$(whoami)/Downloads"
mkdir -p "/home/$(whoami)/Documents"
mkdir -p "/home/$(whoami)/Pictures"
mkdir -p "/home/$(whoami)/Videos"

# ########################################################################################################## #
#                                               Private script                                               #
# ########################################################################################################## #

if [ ! -z "$privaterepo" ]; then
  box "Storing TALIS private script in user folder"

  if [ ! -d $repodir/TALIS-private ]; then
    git clone $privaterepo $repodir/TALIS-private -b $privatebranch
  else
    git --git-dir "$repodir/TALIS-private/.git" --work-tree "$repodir/TALIS-private" pull
  fi

  info "Executing TALIS private restore script"

  sh $repodir/TALIS-private/restore.sh
fi

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

box "Sudo config"
# Remove the previous 'NOPASSWD ALL' and set new permissions
sudoperms "Defaults !tty_tickets" \
          "%wheel ALL=(ALL) ALL" \
          "%users ALL=(ALL) NOPASSWD: /usr/bin/halt,/usr/bin/shutdown,/usr/bin/reboot,/usr/bin/poweroff" \
          "%users ALL=(ALL) NOPASSWD: /usr/bin/bluetooth on,/usr/bin/bluetooth off" \
          "%wheel ALL=(ALL) NOPASSWD: /usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/loadkeys" \
          "%wheel ALL=(ALL) NOPASSWD: /usr/bin/pacman -Sy,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/pacman -Syyu --noconfirm"


# ########################################################################################################## #
#                                                   Cleanup                                                  #
# ########################################################################################################## #

[ -f $HOME/.zshrc ] && rm $HOME/.zshrc
[ -f $HOME/.wget-hsts ] && rm $HOME/.wget-hsts
[ -f $HOME/.bash_history ] && rm $HOME/.bash_history
[ -f $HOME/.bash_logout ] && rm $HOME/.bash_logout
[ -f $HOME/.bash_profile ] && rm $HOME/.bash_profile
[ -f $HOME/.bashrc ] && rm $HOME/.bashrc

# ########################################################################################################## #
#                                                  Finished                                                  #
# ########################################################################################################## #

box "Post Installation Configuration finished"