#!/bin/sh
# ToppDev's Artix Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #

# Set sudoers settings and clear old ones added by this script
sudoperms() {
    if [ $(whoami) = "root" ]; then
        sed -i "/#TALIS/d" /etc/sudoers
        for perm in "$@"; do
            echo "$perm #TALIS" >> /etc/sudoers
        done
    else
        sudo sed -i "/#TALIS/d" /etc/sudoers
        for perm in "$@"; do
            sudo bash -c 'echo "$perm #TALIS" >> /etc/sudoers'
        done
    fi
}