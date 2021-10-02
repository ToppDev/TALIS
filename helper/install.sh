#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #

# Install the specified package
installpkg() {
    if [ $(whoami) = "root" ]; then
        pacman -S --noconfirm --needed $@
    else
        sudo pacman -S --noconfirm --needed $@
    fi
}

# Install the specified package from the AUR
installaur() {
    yay -S --noconfirm --needed $@
}

# Downloads or resets the dotfiles to the ones from the repository
putdotfiles() {
    # Should be run after repodir is created and var is set.

    local repo="$1"   # URL to the repository
    local branch      # Branch to download
    [ -z "$2" ] && branch="master" || branch="$2"

    progname="$(basename "$repo" .git)"
    dir="$repodir/$progname"

    info "Downloading Dotfiles..."

    git clone --bare --branch "$branch" $repo $dir
    git --git-dir=$dir --work-tree=/home/$(whoami)/ -f checkout
}

# ########################################################################################################## #

# Installs $1 manually. Used only for AUR helper here.
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
manualinstall() {
    # Should be run after repodir is created and var is set.
    info "Installing \`$1\`"
    mkdir -p "$repodir/$1"
    git clone --depth 1 "https://aur.archlinux.org/$1.git" "$repodir/$1" >/dev/null 2>&1 ||
        { cd "$repodir/$1" || return 1 ; git pull --force origin master;}
    cd "$repodir/$1"
    sudo -u "$(whoami)" -D "$repodir/$1" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
}

# Installs all needed programs from main repo.
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
maininstall() {
    info "Installing \`$1\` ($n of $total). $1 $2"
    installpkg "$1"
}

aurinstall() { \
    info "Installing \`$1\` ($n of $total) from the AUR. $1 $2"
    installaur "$1"
}

# Downloads a gitrepo and installs the target
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
gitmakeinstall() {
    local repo="$1"    # URL to the repository
    local comment="$2" # Comment to echo

    progname="$(basename "$repo" .git)"
    dir="$repodir/$progname"
    info "Installing \`$progname\` ($n of $total) via \`git\` and \`make\`. $(basename "$repo") $comment"
    git clone --depth 1 "$repo" "$dir" >/dev/null 2>&1 || { cd "$dir" || return 1 ; git pull --force origin master;}
    # Spawn subshell
    (cd "$dir" && make >/dev/null 2>&1 && sudo make install >/dev/null 2>&1)
}

# Install the specified pip package
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
pipinstall() { \
    info "Installing the Python package \`$1\` ($n of $total). $1 $2"
    [ -x "$(command -v "pip")" ] || installpkg python-pip >/dev/null 2>&1
    yes | pip install "$1"
}

# Installs all packages defined in the provided progs file
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
installationloop() {
    ([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" | sed '/^#/d' > /tmp/progs.csv
    total=$(wc -l < /tmp/progs.csv)
    while IFS=, read -r tag program comment; do
        n=$((n+1))
        echo "$comment" | grep -q "^\".*\"$" && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"

        if [ -f "$scriptdir/package/$program/hooks/pre.sh" ]; then
            info "Executing pre-installation hook for \`$program\`"
            sh "$scriptdir/package/$program/hooks/pre.sh"
        fi

        case "$tag" in
            "A") aurinstall "$program" "$comment" ;;
            "G") gitmakeinstall "$program" "$comment" ;;
            "P") pipinstall "$program" "$comment" ;;
            *) maininstall "$program" "$comment" ;;
        esac

        if [ -f "$scriptdir/package/$program/hooks/post.sh" ]; then
            info "Executing post-installation hook for \`$program\`"
            sh "$scriptdir/package/$program/hooks/post.sh"
        fi
    done < /tmp/progs.csv
}