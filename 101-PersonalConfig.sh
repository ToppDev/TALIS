#!/bin/sh
# ToppDev's Artix Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #
#                                               Helper scripts                                               #
# ########################################################################################################## #

scriptdir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source "$scriptdir/helper/color.sh"
source "$scriptdir/helper/log.sh"
source "$scriptdir/helper/user.sh"
source "$scriptdir/helper/install.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"

# ########################################################################################################## #
#                                              Check Arch distro                                             #
# ########################################################################################################## #

check_arch_internet

# ########################################################################################################## #
#                                            Options and Variables                                           #
# ########################################################################################################## #

# Print the usage message
usage() {
    echo "Required arguments:"
    echo "  -r: Dotfiles repository (local file or url)"
    echo "Optional arguments:"
    echo "  -p: Dependencies and programs csv (local file or url)"
    echo "  -a: AUR helper (must have pacman-like syntax)"
    echo "  -h: Show this message"
    exit 1
}

while getopts ":a:r:b:p:h" flag; do
    case "${flag}" in
        h) usage ;;
        r) dotfilesrepo=${OPTARG} && git ls-remote "$dotfilesrepo" >/dev/null || exit 1 ;;
        b) repobranch=${OPTARG} ;;
        p) progsfile=${OPTARG} ;;
        a) aurhelper=${OPTARG} ;;
        *) printf "Invalid option: -%s\\n" "$OPTARG" && exit 1 ;;
    esac
done

[ -z "$dotfilesrepo" ] && echo -e "Dotfiles repository is required. Please specify -r\\n" && usage
[ -z "$progsfile" ] && progsfile="https://raw.githubusercontent.com/ToppDev/TALIS/main/progs.csv"
[ -z "$aurhelper" ] && aurhelper="yay"
[ -z "$repobranch" ] && repobranch="main"

# ########################################################################################################## #
#                                                fstab & mount                                               #
# ########################################################################################################## #

# Mount NAS
pacinstall cifs-utils ntfs-3g
sudo mkdir -p /mnt/audiobooks
sudo mkdir -p /mnt/books
sudo mkdir -p /mnt/thomas
sudo mkdir -p /mnt/p
sudo mkdir -p /mnt/video
if [ ! -f "/etc/cifs-cred-truenas" ]; then
    readUsername || error "Could not read the username"
    readPassword || error "Could not read the password"

    sudo bash -c 'echo "username='$name'" > /etc/cifs-cred-truenas'
    sudo bash -c 'echo "password='$password'" >> /etc/cifs-cred-truenas'
    sudo chmod 600 /etc/cifs-cred-truenas
    unset name password
fi

# Fstab editing
userid=`id -u "$(whoami)"`
groupid=`getent group users | awk -F: '{printf "%d", $3}'`
# p_boot=`lsblk | grep /boot$ | awk -F: '{printf "%s", substr($1,3,4)}'`
p_data=`lsblk | grep sdb`
sudo bash -c 'echo "# <file system>             <mount point>   <type>      <options>                       <dumb>  <pass>" > /etc/fstab'
sudo bash -c 'echo "LABEL=p_arch                /               ext4        rw,defaults,noatime,discard     0       1" >> /etc/fstab'
sudo bash -c 'echo "LABEL=EFIBOOT               /boot           vfat        rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro 0 2" >> /etc/fstab'
sudo bash -c 'echo "LABEL=p_swap                none            swap        defaults,noatime,discard        0       0" >> /etc/fstab'
sudo bash -c 'echo "# NAS folder audiobooks" >> /etc/fstab'
sudo bash -c 'echo "//192.168.1.10/audiobooks   /mnt/audiobooks cifs        rw,uid='$userid',gid='$groupid',noauto,x-systemd.automount,x-systemd.mount-timeout=20,_netdev,credentials=/etc/cifs-cred-truenas 0 0" >> /etc/fstab'
sudo bash -c 'echo "# NAS folder books" >> /etc/fstab'
sudo bash -c 'echo "//192.168.1.10/books        /mnt/books      cifs        rw,uid='$userid',gid='$groupid',noauto,x-systemd.automount,x-systemd.mount-timeout=20,_netdev,credentials=/etc/cifs-cred-truenas 0 0" >> /etc/fstab'
sudo bash -c 'echo "# NAS folder thomas" >> /etc/fstab'
sudo bash -c 'echo "//192.168.1.10/thomas       /mnt/thomas     cifs        rw,uid='$userid',gid='$groupid',noauto,x-systemd.automount,x-systemd.mount-timeout=20,_netdev,credentials=/etc/cifs-cred-truenas 0 0" >> /etc/fstab'
sudo bash -c 'echo "# NAS folder private" >> /etc/fstab'
sudo bash -c 'echo "//192.168.1.10/p            /mnt/p          cifs        rw,uid='$userid',gid='$groupid',noauto,x-systemd.automount,x-systemd.mount-timeout=20,_netdev,credentials=/etc/cifs-cred-truenas 0 0" >> /etc/fstab'
sudo bash -c 'echo "# NAS folder video" >> /etc/fstab'
sudo bash -c 'echo "//192.168.1.10/video        /mnt/video      cifs        rw,uid='$userid',gid='$groupid',noauto,x-systemd.automount,x-systemd.mount-timeout=20,_netdev,credentials=/etc/cifs-cred-truenas 0 0" >> /etc/fstab'
if [ "$p_data" ]; then
    sudo mkdir -p /mnt/data
    sudo bash -c 'echo "# Data drive (HDD)" >> /etc/fstab'
    sudo bash -c 'echo "/dev/sdb1                   /mnt/data       ntfs        rw,uid='$userid',gid='$groupid',noauto,x-systemd.automount,x-systemd.mount-timeout=20,_netdev 0 0" >> /etc/fstab'
fi
sudo bash -c 'echo -e "\n# defaults: rw, exec, auto, nouser, and relatime." >> /etc/fstab'
sudo bash -c 'echo -e "\n# You can not change linux permissions on an individual file on an ntfs partition since it has no linux permissions bits to change." >> /etc/fstab'
sudo bash -c 'echo "# Mounting an ntfs partition in Linux creates a \"view\" such that it appears as if it has Linux permissions but globally - all files have the same permissions." >> /etc/fstab'
sudo bash -c 'echo "# The \"users\" option turns the execute bit off on the mounted partition." >> /etc/fstab'
sudo bash -c 'echo "# \"fmask=111\" also turns off the execute bit on all files." >> /etc/fstab'
sudo bash -c 'echo "# \"umask=000\" makes all directories and files have permissions of rwx." >> /etc/fstab'

# ########################################################################################################## #
#                                                    Hosts                                                   #
# ########################################################################################################## #

sudo bash -c 'echo "" >> /etc/hosts'
sudo bash -c 'echo "192.168.1.81  archleft.localdomain   archleft" >> /etc/hosts'
sudo bash -c 'echo "192.168.1.80  archserver.localdomain archserver" >> /etc/hosts'

# ########################################################################################################## #
#                                                  X Server                                                  #
# ########################################################################################################## #

sudo cp $scriptdir/X11/20-keyboard.conf /etc/X11/xorg.conf.d/20-keyboard.conf

# ########################################################################################################## #
#                                               NetworkManager                                               #
# ########################################################################################################## #

if [[ $hostname = "LEGION" || $hostname = "CABAL" ]]; then
  # Save with:
  # sudo bash -c 'cp /etc/NetworkManager/system-connections/* /home/topas/.archinstall/NetworkManager/$(hostname)/'
  # sudo chown -R topas:users ~/.archinstall/NetworkManager/$(hostname)/
  cp $scriptdir/NetworkManager/$hostname/* /etc/NetworkManager/system-connections/
  chown -R root:root /etc/NetworkManager/system-connections/
  chmod 600 /etc/NetworkManager/system-connections/*
fi

# ########################################################################################################## #
#                                                  Programs                                                  #
# ########################################################################################################## #

# ------------------------------------------------- LightDM ------------------------------------------------ #
sudo cp $scriptdir/LightDM/$(hostname)/lightdm-background.jpg /usr/share/pixmaps/lightdm-background.jpg
sudo cp $scriptdir/LightDM/topas.png /usr/share/pixmaps/topas.png
sudo sed -i "s/Icon=.*/Icon=\/usr\/share\/pixmaps\/topas.png/g" /var/lib/AccountsService/users/topas

# ------------------------------------------------- Barrier ------------------------------------------------ #
mkdir -p ~/.config/Debauchee/
cp $scriptdir/Barrier/$(hostname)/* ~/.config/Debauchee/

# ------------------------------------------------- i3lock ------------------------------------------------- #
mkdir -p ~/Pictures
cp $scriptdir/i3lock/$(hostname)/i3lock.png ~/Pictures/



# # Extract ssh files
# pacinstall p7zip
# echo -n "Please type the password for the ssh.zip archive: "
# read -s ssharchive
# if [ $ssharchive ]; then
#    sudo -u $user mkdir -p /home/$user/.ssh
#    sudo -u $user 7z e -p$ssharchive $scriptdir/.ssh-$(echo $hostname | tr '[:upper:]' '[:lower:]').7z -o'/home/'$user'/.ssh'
#    chmod 700 /home/$user/.ssh 2> /dev/null
#    chmod 644 /home/$user/.ssh/authorized_keys 2> /dev/null
#    chmod 644 /home/$user/.ssh/known_hosts 2> /dev/null
#    chmod 644 /home/$user/.ssh/config 2> /dev/null
#    chmod 600 /home/$user/.ssh/id_rsa 2> /dev/null
#    chmod 644 /home/$user/.ssh/id_rsa.pub 2> /dev/null
# fi

# To encrypt sensitive files
# 7z a \
#   -t7z -m0=lzma2 -mx=9 -mfb=64 \
#   -md=32m -ms=on -mhe=on -p \
#    ssh-legion.7z *