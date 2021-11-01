#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #


# Prompts user for a username
# @return $name
readUsername() {
    read -p "Please enter a username: " name
    while ! echo "$name" | grep -q "^[a-z_][a-z0-9_-]*$"; do
        echo "Username not valid"
        read -p "Please enter a username: " name
    done
}

# Prompts user for a password
# @return $password
readPassword() {
    echo "Please enter a password: "
    read -s password
    echo -e "\nRetype password: "
    read -s password2
    while ! [ "$password" = "$password2" ]; do
        unset password2
        echo -e "\nPasswords do not match. Please enter a password: "
        read -s password
        echo -e "\nRetype password: "
        read -s password2
    done
    echo -e "\n"
    unset password2
}

# Creates or modifies th specified user
createUser() {
    local username="$1"

    echo "Adding user \"$username\"..."
    useradd -m -g wheel -s /bin/bash "$username" >/dev/null 2>&1 \
        || usermod -a -G wheel "$username" \
            && mkdir -p /home/"$username" \
            && chown "$username":wheel /home/"$username" \
            && chsh -s /bin/bash "$username"
    # Additional groups
    gpasswd -a $username wheel # Sudo permissions
    gpasswd -a $username uucp # Accessing virtual serial ports (e.g. ttyUSB)
}

# Sets the password for the specified user
setPassword() {
    local username="$1" # Username to set password for
    local password="$2" # Password to set

    echo "$username:$password" | chpasswd
}

# Check if the specified user exists
usercheck() {
    local username="$1" # Username to check

    if id -u "$username" >/dev/null 2>&1; then
        echo -e -n "${C_ORANGE}WARNING${C_NO}: "
        echo -e "The user \`$username\` already exists on this system."
        echo -e "\\nTALIS can install for a user already existing, but it will ${C_LIGHT_RED}overwrite${C_NO} any conflicting settings/dotfiles on the user account."
        echo -e "TALIS will ${C_LIGHT_RED}not${C_NO} overwrite your user files, documents, videos, etc., so don't worry about that, but only continue if you don't mind your settings being overwritten."
        echo -e "Note also that TALIS will change $username's password to the one you just gave.\\n"
        local abort_script
        while [ "$abort_script" != "n" ] && [ "$abort_script" != "N" ] && [ "$abort_script" != "y" ] && [ "$abort_script" != "Y" ]; do
            read -p "Abort script execution? (y/N) " abort_script
            [ -z "$abort_script" ] && abort_script="n"
        done
        [ "$abort_script" == "y" ] || [ "$abort_script" == "Y" ] && exit 1
    fi
}
