#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# This script automates the installation of artix linux
# https://wiki.artixlinux.org/Main/Installation#Configure_the_base_system

# ########################################################################################################## #
#                                               Helper scripts                                               #
# ########################################################################################################## #

scriptdir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source "$scriptdir/helper/color.sh"
source "$scriptdir/helper/log.sh"
source "$scriptdir/helper/user.sh"
source "$scriptdir/helper/sudo.sh"
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

box "Add users"

# Read and set new password for root
info "First we change the root password"
readPassword root || error "Error reading the root password"
setPassword "root" "$password" || error "Error setting root password"
unset password

info "Then we create a new user"
readUsername || error "Could not read the username"
readPassword $name || error "Could not read the password"

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
pacman -S --noconfirm --needed networkmanager networkmanager-runit
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default >/dev/null 2>&1

# Log the output from wpa_supplicant to syslog instead of stdout
sed -i 's/Exec=.*/Exec=\/usr\/bin\/wpa_supplicant -u -s/g' /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service

# ########################################################################################################## #
#                                             Syslog replacement                                             #
# ########################################################################################################## #

box "Syslog replacement"

# Runit has a different type of logging, which relies on creating log scripts
# However there are a lot of programs not respecting this, so you need a syslog replacement
pacman -S --noconfirm --needed socklog
ln -s /etc/runit/sv/socklog /etc/runit/runsvdir/default >/dev/null 2>&1

# ########################################################################################################## #
#                                                TALIS scripts                                               #
# ########################################################################################################## #

[ ! -f $repodir/TALIS ] && git clone https://github.com/ToppDev/TALIS.git $repodir/TALIS

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
echo -e"# Execute the script ${C_ORANGE}020-PostInstallationConfig.sh${C_LIGHT_GREEN} #"
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