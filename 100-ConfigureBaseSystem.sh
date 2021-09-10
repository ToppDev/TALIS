#!/bin/bash

# This script automates the installation of artix linux
# https://wiki.artixlinux.org/Main/Installation#Configure_the_base_system

# ########################################################################################################## #
#                                              Necessary things                                              #
# ########################################################################################################## #

pacman --noconfirm --needed -Sy curl base-devel git ntp zsh || error "This script only works as root user, on an Arch-based distribution and you have to be connected to the internet!"
sed -i '/# %wheel\tALL=(ALL) ALL/s/^..//' /etc/sudoers || error "etc/sudoers file does not exist. Please install 'sudo' manually first"

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
done

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

# Prompts user for a name fot the user account
# @return $username
readUsername() {
    read -p "Please enter a name for the user account: " username
    while ! echo "$username" | grep -q "^[a-z_][a-z0-9_-]*$"; do
        read -p "Invalid username. Please enter a name for the user account: " username
    done
}

# Prompts user for a password
# @param $1 username to request password for
# @return $password
readPassword() {
    read -p "Please enter a password for user '$1': " password
    read -p "Retype password: " password2
    while ! [ "$password" = "$password2" ]; do
        unset password2
        read -p "Passwords do not match. Please enter a password for user '$1': " password
        read -p "Retype password: " password2
    done
    unset password2
}

# Creates the specified user or modifies if already exist
# @param $1 username to create
createUser() {
    echo "Creating user $1"
    useradd -m -g wheel -s /bin/zsh "$1" >/dev/null 2>&1 ||
        usermod -a -G wheel "$1" && mkdir -p /home/"$1" && chown "$1":wheel /home/"$1"
    # Additional groups
    gpasswd -a $1 uucp >/dev/null 2>&1 # For serial usb reading
}

# Sets the password for the specified user
# @param $1 username to create
# @param $2 password for the user
setPassword() {
    echo "$1:$2" | chpasswd
}

# Read and set new password for root
readPassword root
setPassword "root" "$password" || error "Error setting root password"

# Read username and create a user
readUsername
createUser "$username" || error "Error creating user '$username'"

# Read and set new password for the user
readPassword "$username"
setPassword "$username" "$password" || error "Error setting user password"

# Clean up
unset password rootPassword

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
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default

# ########################################################################################################## #
#                                              Reboot the system                                             #
# ########################################################################################################## #

echo "##############################################"
echo "#               Script finished              #"
echo "#                                            #"
echo "# Reboot and enter into the new installation #"
echo "#                                            #"
echo "# exit                                       #"
echo "# exit                                       #"
echo "# umount -R /mnt                             #"
echo "# reboot                                     #"
echo "#                                            #"
echo "##############################################"