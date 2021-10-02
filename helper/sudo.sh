#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #

# Set sudoers settings and clear old ones added by this script
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
sudoperms() {
    if [ $(whoami) = "root" ]; then
        sed -i "/#TALIS/d" /etc/sudoers
        for perm in "$@"; do
            echo "$perm #TALIS" >> /etc/sudoers
        done
    else
        # Temporary entry to not loose sudo right in the process
        sudo sh -c "echo '%wheel ALL=(ALL) NOPASSWD: ALL #TMP' >> /etc/sudoers"

        sudo sed -i "/#TALIS/d" /etc/sudoers
        for perm in "$@"; do
            sudo sh -c "echo '$perm #TALIS' >> /etc/sudoers"
            # Temporary entry to not loose sudo right in the process (has to always stand at the end)
            sudo sh -c "echo '%wheel ALL=(ALL) NOPASSWD: ALL #TMP' >> /etc/sudoers"
        done

        # Remove Temporary sudo rights
        sudo sed -i "/#TMP/d" /etc/sudoers
    fi
}