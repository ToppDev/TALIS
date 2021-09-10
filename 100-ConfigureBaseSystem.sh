#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# This script automates the installation of artix linux
# https://wiki.artixlinux.org/Main/Installation#Configure_the_base_system

# ########################################################################################################## #
#                                                  Functions                                                 #
# ########################################################################################################## #

# Prints the privided string and exits the script
# @param $1 Error message
error() {
    printf "%s\n" "$1" >&2
    exit 1
}

# Prompts user for a password
# @param $1 username to request password for
# @return $password
readPassword() {
    stty -echo
    printf "Please enter a password for user '$1': "
    read password
    printf "\nRetype password: "
    read password2
    while ! [ "$password" = "$password2" ]; do
        unset password2
        printf "\nPasswords do not match. Please enter a password for user '$1': "
        read password
        printf "\nRetype password: "
        read password2
    done
    printf "\n"
    stty echo
    unset password2
}

# Sets the password for the specified user
# @param $1 username to create
# @param $2 password for the user
setPassword() {
    echo "$1:$2" | chpasswd
}

# ########################################################################################################## #
#                                              Set system clock                                              #
# ########################################################################################################## #

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# ########################################################################################################## #
#                                                Localization                                                #
# ########################################################################################################## #

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

# Install dependencies
pacman -S --noconfirm --needed grub efibootmgr # Dual boot would need: os-prober

# Install the GRUB
if [ "$(ls -A /sys/firmware/efi/efivars)" ]; then # UEFI systems
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
else # BIOS systems
    grub-install --recheck /dev/sda
fi

# Install ucode (Processor manufacturer stability and security updates to the processor microcode)
if grep -q "AMD" /proc/cpuinfo; then
    pacman -S --noconfirm --needed amd-ucode
elif grep -q "Intel" /proc/cpuinfo; then
    pacman -S --noconfirm --needed intel-ucode
fi

# Install Linux-LTS
pacman -S --noconfirm --needed linux-lts

# Set the default options
sed -i -e '/#GRUB_DISABLE_SUBMENU=/s/^.//' /etc/default/grub
sed -i "/GRUB_DEFAULT=/c\GRUB_DEFAULT='Artix Linux, with Linux linux'" /etc/default/grub
# With submenu entries this would have to be:
# sed -i "/GRUB_DEFAULT=/c\GRUB_DEFAULT='Advanced options for Artix Linux>Artix Linux, with Linux linux'" /etc/default/grub

# Generate the GRUB conig
grub-mkconfig -o /boot/grub/grub.cfg

# ########################################################################################################## #
#                                                 Add user(s)                                                #
# ########################################################################################################## #

# Read and set new password for root
readPassword root || error "Error reading the root password"
setPassword "root" "$password" || error "Error setting root password"
unset password

# ########################################################################################################## #
#                                            Network configuration                                           #
# ########################################################################################################## #

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
pacman -S --noconfirm --needed networkmanager networkmanager-runit
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default >/dev/null 2>&1

# Log the output from wpa_supplicant to syslog instead of stdout
sed -i 's/Exec=.*/Exec=\/usr\/bin\/wpa_supplicant -u -s/g' /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service

# ########################################################################################################## #
#                                             Syslog replacement                                             #
# ########################################################################################################## #

# Runit has a different type of logging, which relies on creating log scripts
# However there are a lot of programs not respecting this, so you need a syslog replacement
pacman -S --noconfirm --needed socklog
ln -s /etc/runit/sv/socklog /etc/runit/runsvdir/default >/dev/null 2>&1

# ########################################################################################################## #
#                                              Reboot the system                                             #
# ########################################################################################################## #

echo "##############################################"
echo "#               Script finished              #"
echo "#                                            #"
echo "# Reboot and enter into the new installation #"
echo "#                                            #"
echo "# exit                                       #"
echo "# umount -R /mnt                             #"
echo "# reboot                                     #"
echo "#                                            #"
echo "##############################################"