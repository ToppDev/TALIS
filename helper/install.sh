#!/bin/sh
# ToppDev's Artix Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #

aurinstall() {
    for pkg in "$@"; do
        info "Installing \`$pkg\` from the AUR"
        trizen -S --noconfirm --noedit "$pkg"
    done
}

pacinstall() {
    for pkg in "$@"; do
        info "Installing \`$pkg\`"
        if [ $(whoami) = "root" ]; then
            pacman -S --noconfirm  "$pkg"
        else
            sudo pacman -S --noconfirm  "$pkg"
        fi
    done
}