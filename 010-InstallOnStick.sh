#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
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
installpkg efibootmgr

# Install Linux-LTS
installpkg linux-lts

# Install ucode (Processor manufacturer stability and security updates to the processor microcode)
if grep -q "AMD" /proc/cpuinfo; then
    installpkg amd-ucode
elif grep -q "Intel" /proc/cpuinfo; then
    installpkg intel-ucode
fi

if is_archlinux; then
    installpkg dosfstools gptfdisk

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
elif is_artixlinux; then
    installpkg grub

    # Install the GRUB
    if [ "$(ls -A /sys/firmware/efi/efivars)" ]; then # UEFI systems
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
    else # BIOS systems
        grub-install --recheck /dev/sda
    fi

    # Set the default options
    sed -i -e '/#GRUB_DISABLE_SUBMENU=/s/^.//' /etc/default/grub
    sed -i "/GRUB_DEFAULT=/c\GRUB_DEFAULT='Artix Linux, with Linux linux'" /etc/default/grub
    # With submenu entries this would have to be:
    # sed -i "/GRUB_DEFAULT=/c\GRUB_DEFAULT='Advanced options for Artix Linux>Artix Linux, with Linux linux'" /etc/default/grub

    # Generate the GRUB conig
    grub-mkconfig -o /boot/grub/grub.cfg
else
    error "System not supported"
fi

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

# NetworkManager
installpkg networkmanager wget git inetutils

if is_archlinux; then
    systemctl enable NetworkManager
elif is_artixlinux; then
    installpkg networkmanager-runit
    ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default >/dev/null 2>&1

    # Log the output from wpa_supplicant to syslog instead of stdout
    sed -i 's/Exec=.*/Exec=\/usr\/bin\/wpa_supplicant -u -s/g' /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service
else
    error "System not supported"
fi
# ########################################################################################################## #
#                                             Syslog replacement                                             #
# ########################################################################################################## #

if is_artixlinux; then
    box "Syslog replacement"

    # Runit has a different type of logging, which relies on creating log scripts
    # However there are a lot of programs not respecting this, so you need a syslog replacement
    installpkg socklog
    ln -s /etc/runit/sv/socklog /etc/runit/runsvdir/default >/dev/null 2>&1
fi

# ########################################################################################################## #
#                                           Repositories & Keyring                                           #
# ########################################################################################################## #

box "Repositories & Keyring"

# Make pacman colorful and add eye candy on the progress bar
grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# Reinstall Keyrings
info "Refreshing Arch Keyring..."
pacman --noconfirm -S gnupg archlinux-keyring

if is_artixlinux; then
    pacman --noconfirm -S artix-archlinux-support artix-keyring
fi

if is_archlinux; then
    # Enable 32-bit support
    sed -i '/#\[multilib\]/,+1{/#\[multilib\]/ n; s/^#//}' /etc/pacman.conf # Remove comment in next line after '#[multilib]'
    sed -i '/#\[multilib\]/s/^.//' /etc/pacman.conf                         # Remove comment at start of line '#[multilib]'
elif is_artixlinux; then
    # Enable 32-bit support
    sed -i '/#\[lib32\]/,+1{/#\[lib32\]/ n; s/^#//}' /etc/pacman.conf # Remove comment in next line after '#[lib32]'
    sed -i '/#\[lib32\]/s/^.//' /etc/pacman.conf                      # Remove comment at start of line '#[lib32]'

    # Add Arch repositories
    if ! grep -q -o "\[[^]]*extra\]" /etc/pacman.conf; then
        echo "" >> /etc/pacman.conf
        echo "[extra]" >> /etc/pacman.conf
        echo "Include = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf
    fi
    if ! grep -q -o "\[[^]]*community\]" /etc/pacman.conf; then
        echo "" >> /etc/pacman.conf
        echo "[community]" >> /etc/pacman.conf
        echo "Include = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf
    fi
    if ! grep -q -o "\[[^]]*multilib\]" /etc/pacman.conf; then
        echo "" >> /etc/pacman.conf
        echo "[multilib]" >> /etc/pacman.conf
        echo "Include = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf
    fi
else
    error "System not supported"
fi

# Reset the Keychain
rm -r /etc/pacman.d/gnupg
pacman-key --init
if is_archlinux; then
    pacman-key --populate archlinux
elif is_artixlinux; then
    pacman-key --populate archlinux artix
else
    error "System not supported"
fi
# Update package database
pacman -Sy

# ########################################################################################################## #
#                                               Necessary Tools                                              #
# ########################################################################################################## #

box "Necessary Tools"

installpkg curl base-devel git ntp

# Use all cores for compilation
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf
sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$(nproc)"' -z -)/g' /etc/makepkg.conf

info "Synchronizing time..."
ntpdate 0.europe.pool.ntp.org

# ########################################################################################################## #
#                                              Update mirrorlist                                             #
# ########################################################################################################## #

box "Updating mirrorlist (this can take a while)"

installpkg reflector rsync

reflector --verbose -l 200 --sort rate --save /etc/pacman.d/mirrorlist

# ########################################################################################################## #
#                                                TALIS scripts                                               #
# ########################################################################################################## #

box "Storing TALIS repo in user folder"

[ ! -d $repodir/TALIS ] && sudo -u "$name" git clone https://github.com/ToppDev/TALIS.git $repodir/TALIS

# ########################################################################################################## #
#                                            User root permissions                                           #
# ########################################################################################################## #

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.
sudoperms "%wheel ALL=(ALL) NOPASSWD: ALL"

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
