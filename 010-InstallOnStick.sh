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
source "$scriptdir/helper/user.sh"
source "$scriptdir/helper/sudo.sh"
source "$scriptdir/helper/install.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"

# ########################################################################################################## #
#                                       Check Arch distro and root user                                      #
# ########################################################################################################## #

check_arch_root_internet

# ########################################################################################################## #
#                                              Set system clock                                              #
# ########################################################################################################## #

box "Set system clock"

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# ########################################################################################################## #
#                                                Localization                                                #
# ########################################################################################################## #

box "Localization"

# Generate locale
sed -i -e '/#de_DE/s/^.//' /etc/locale.gen
sed -i -e '/#en_US/s/^.//' /etc/locale.gen
sed -i -e '/#en_DK/s/^.//' /etc/locale.gen
locale-gen

# Set the locale systemwide
while [ "$language" != "de" ] && [ "$language" != "en" ]; do
    read -p "Please specify the machine language (de/en): " language
    if [ "$language" = "de" ]; then
        echo LANG=de_DE.UTF-8 > /etc/locale.conf
        echo LANGUAGE=de_DE:de >> /etc/locale.conf
    elif [ "$language" = "en" ]; then
        echo LANG=en_US.UTF-8 > /etc/locale.conf
        echo LC_TIME=en_DK.UTF-8 >> /etc/locale.conf
        echo LANGUAGE=en_US:en_GB:en >> /etc/locale.conf
    fi
done

# ########################################################################################################## #
#                                                 Boot loader                                                #
# ########################################################################################################## #

box "Boot loader"

# Install dependencies
pacinstall efibootmgr dosfstools gptfdisk linux-lts

# Install ucode (Processor manufacturer stability and security updates to the processor microcode)
if grep -q "AMD" /proc/cpuinfo; then
    pacinstall amd-ucode
elif grep -q "Intel" /proc/cpuinfo; then
    pacinstall intel-ucode
fi

# Initramfs erzeugen
mkinitcpio -p linux

# Install EFI boot entry
bootctl install

# Config Arch Linux
echo "title Arch Linux" > /boot/loader/entries/arch-uefi.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch-uefi.conf
if grep -q "AMD" /proc/cpuinfo; then
    echo "initrd /amd-ucode.img" >> /boot/loader/entries/arch-uefi.conf
elif grep -q "Intel" /proc/cpuinfo; then
    echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch-uefi.conf
fi
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch-uefi.conf
echo "options root=LABEL=ROOT rw resume=LABEL=SWAP" >> /boot/loader/entries/arch-uefi.conf
# Config Arch Linux (LTS)
echo "title Arch Linux LTS" > /boot/loader/entries/arch-uefi-lts.conf
echo "linux /vmlinuz-linux-lts" >> /boot/loader/entries/arch-uefi-lts.conf
if grep -q "AMD" /proc/cpuinfo; then
    echo "initrd /amd-ucode.img" >> /boot/loader/entries/arch-uefi-lts.conf
elif grep -q "Intel" /proc/cpuinfo; then
    echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch-uefi-lts.conf
fi
echo "initrd /initramfs-linux-lts.img" >> /boot/loader/entries/arch-uefi-lts.conf
echo "options root=LABEL=ROOT rw resume=LABEL=SWAP" >> /boot/loader/entries/arch-uefi-lts.conf
# Config Arch Linux (fallback)
echo "title Arch Linux Fallback" > /boot/loader/entries/arch-uefi-fallback.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch-uefi-fallback.conf
if grep -q "AMD" /proc/cpuinfo; then
    echo "initrd /amd-ucode.img" >> /boot/loader/entries/arch-uefi-fallback.conf
elif grep -q "Intel" /proc/cpuinfo; then
    echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch-uefi-fallback.conf
fi
echo "initrd /initramfs-linux-fallback.img" >> /boot/loader/entries/arch-uefi-fallback.conf
echo "options root=LABEL=ROOT rw resume=LABEL=SWAP" >> /boot/loader/entries/arch-uefi-fallback.conf
# Config Loader
echo "default arch-uefi.conf" > /boot/loader/loader.conf
echo "timeout 4" >> /boot/loader/loader.conf
echo "editor no" >> /boot/loader/loader.conf
echo "#console-mode keep" >> /boot/loader/loader.conf

# ########################################################################################################## #
#                                                 Add user(s)                                                #
# ########################################################################################################## #

box "Add users"

# Read and set new password for root
info "First we change the root password"
readPassword || error "Error reading the root password"
setPassword "root" "$password" || error "Error setting root password"
unset password

info "Then we create a new user"
readUsername || error "Could not read the username"

usercheck $name

readPassword || error "Could not read the password"

createUser "$name" || error "Error while creating the user"
setPassword "$name" "$password" || error "Error while setting the user password"

# Create directoy to download git files to
export repodir="/home/$name/.local/src"
mkdir -p "$repodir"
chown -R "$name":wheel "$(dirname "$repodir")"

# ########################################################################################################## #
#                                            User root permissions                                           #
# ########################################################################################################## #

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.
sudoperms "%wheel ALL=(ALL) NOPASSWD: ALL"

# ########################################################################################################## #
#                                            Network configuration                                           #
# ########################################################################################################## #

box "Network configuration"

# Network hostname
read -p "Please type the hostname for this machine: " hostname
echo $hostname > /etc/hostname

# Hosts
echo "# Static table lookup for hostnames." > /etc/hosts
echo "# See hosts(5) for details." >> /etc/hosts
echo "" >> /etc/hosts
echo "#<IP-Address> <hostname.domain>     <hostname>" >> /etc/hosts
echo "127.0.0.1     localhost.localdomain localhost" >> /etc/hosts
echo "::1           localhost.localdomain localhost" >> /etc/hosts
echo "127.0.1.1     $hostname.localdomain $hostname" >> /etc/hosts

# NetworkManager
pacinstall networkmanager wget git inetutils
systemctl enable NetworkManager

# ########################################################################################################## #
#                                                TALIS scripts                                               #
# ########################################################################################################## #

box "Storing TALIS repo in user folder"

[ ! -d $repodir/TALIS ] && sudo -u "$name" git clone https://github.com/ToppDev/TALIS.git $repodir/TALIS

# ########################################################################################################## #
#                                              Update mirrorlist                                             #
# ########################################################################################################## #

box "Updating mirrorlist (this can take a while)"

pacinstall reflector

reflector --verbose -l 200 --sort rate --save /etc/pacman.d/mirrorlist

# ########################################################################################################## #
#                                              Reboot the system                                             #
# ########################################################################################################## #

echo -e "$C_LIGHT_GREEN"
echo "####################################################"
echo "#               Script finished                    #"
echo "#                                                  #"
echo "# Reboot and enter into the new installation       #"
echo "# as the user you just created.                    #"
echo "#                                                  #"
echo -e "# Execute the script ${C_ORANGE}100-PostInstallationConfig.sh${C_LIGHT_GREEN} #"
echo "# after login. It can be found under               #"
echo "# ~/.local/src/TALIS                               #"
echo "#                                                  #"
echo "####################################################"
echo "#                                                  #"
echo "# exit                                             #"
echo "# umount -R /mnt                                   #"
echo "# reboot                                           #"
echo "#                                                  #"
echo "####################################################"
echo -e "$C_NO"