#!/bin/sh
# ToppDev's Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #

aurinstall() {
    info "Installing \`$*\` from the AUR"
    trizen -S --noconfirm --noedit --needed $@
}

pacinstall() {

    info "Installing \`$*\`"
    if [ $(whoami) = "root" ]; then
        pacman -S --noconfirm --needed $@
    else
        sudo pacman -S --noconfirm --needed $@
    fi
}