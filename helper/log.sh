#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #

# Prints the provided string and exits the script
error() {
    local msg="$1" # Error message

    echo -e "$C_LIGHT_RED$msg$C_NO" >&2
    exit 1
}

# Prints the provided string in info coloring
info() {
    local msg="$1" # Info message

    echo -e "$C_LIGHT_GREEN$msg$C_NO"
}

# Repeats the specified character n times
repeat() {
    local char="$1" # Character to repeat
    local n="$2" # Amount of times to repeat

    printf "$char"'%.s' $(eval "echo {1.."$(($n))"}");
}

# Prints the provided string in info coloring
box() {
    local msg="$1" # message
    local line_length="$2" # Length of the line

    [ -z "$line_length" ] && line_length=60

    local spaces=$(( ($line_length - ${#msg})/2 - 1 ))
    local add_space
    if [ $(( 2*spaces + ${#msg} + 2 )) -lt $line_length ]; then
        add_space=" "
    fi

    echo -e -n "$C_LIGHT_GREEN"
    repeat "#" $line_length
    printf "\\n#"
    repeat " " $spaces
    echo -n "$msg$add_space"
    repeat " " $spaces
    printf "#\\n"
    repeat "#" $line_length
    echo -e "$C_NO"
}