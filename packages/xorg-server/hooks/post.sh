#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #
#                                               Helper scripts                                               #
# ########################################################################################################## #

packagedir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/.."

source "$scriptdir/helper/color.sh"
source "$scriptdir/helper/log.sh"
source "$scriptdir/helper/install.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"

# ########################################################################################################## #
#                                                   Script                                                   #
# ########################################################################################################## #

# Driver installation
if lspci -v | grep -A1 -e VGA -e 3D | grep -q "Intel"; then
    installpkg xf86-video-intel mesa lib32-mesa vulkan-intel lib32-vulkan-intel
    # Problems with some intel chips (https://wiki.archlinux.de/title/Intel)
    sudo sed -i 's/MODULES=()/MODULES=(intel_agp i915)/g' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
elif lspci -v | grep -A1 -e VGA -e 3D | grep -q "NVIDIA"; then
    installpkg nvidia nvidia-utils nvidia-settings lib32-nvidia-utils
    sudo sh -c "echo 'options nvidia-drm modeset=1' > /etc/modprobe.d/nvidia.conf"
elif lspci -v | grep -A1 -e VGA -e 3D | grep -q "AMD"; then
    installpkg xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
elif lspci -v | grep -A1 -e VGA -e 3D | grep -q "ATI"; then
    installpkg xf86-video-ati mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
fi

# Vulkan Installable Client Driver (ICD) Loader
installpkg vulkan-icd-loader lib32-vulkan-icd-loader

# Touchpad support
if xinput list | grep -q "Touchpad"; then
    installpkg xf86-input-synaptics
fi

# Config files
sudo cp $packagedir/xinitrc.d/* /etc/X11/xinit/xinitrc.d/
sudo cp $packagedir/xorg-conf/* /etc/X11/xorg.conf.d/

# Close TCP Port 6000
[ -f "/usr/bin/startx" ] && sudo sed -i 's/defaultserverargs=""/defaultserverargs="-nolisten tcp"/' /usr/bin/startx