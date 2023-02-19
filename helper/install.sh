#!/bin/sh
# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #

export aurhelper="yay"

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
    $aurhelper -S --noconfirm --needed $@
}

# Downloads or resets the dotfiles to the ones from the repository
putdotfiles() {
    # Should be run after repodir is created and var is set.

    local repo="$1"   # URL to the repository
    local branch      # Branch to download
    [ -z "$2" ] && branch="master" || branch="$2"

    progname="$(basename "$repo" .git)"
    dir="/home/$(whoami)/.local/share/$progname"

    info "Downloading Dotfiles..."

    [ -d $dir ] && rm -rf "$dir"
    git clone --bare --branch "$branch" "$repo" "$dir"
    git --git-dir="$dir" --work-tree=/home/$(whoami)/ checkout -f
    # Somehow git does not track the remote, because the fetch line is missing in the config
    git --git-dir="$dir" --work-tree=/home/$(whoami)/ config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    # Set the default push upstream target to 'origin'
    git --git-dir="$dir" --work-tree=/home/$(whoami)/ push --set-upstream origin $branch
    # make git ignore deleted LICENSE & README.md files
    rm -f "/home/$(whoami)/README.md" "/home/$(whoami)/LICENSE"
    git --git-dir="$dir" --work-tree=/home/$(whoami)/ update-index --assume-unchanged "/home/$(whoami)/README.md" "/home/$(whoami)/LICENSE"
}

# ########################################################################################################## #

# Installs $1 manually. Used only for AUR helper here.
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
manualinstall() {
    info "Manually installing \`$1\` ($n of $total) from the AUR - $2"
    if pacman -Qs $1 >> /dev/null; then
        mkdir -p "/tmp/TALIS/$1"
        git clone --depth 1 "https://aur.archlinux.org/$1.git" "/tmp/TALIS/$1" >/dev/null 2>&1 ||
            { cd "/tmp/TALIS/$1" || return 1 ; git pull --force origin master;}
        cd "/tmp/TALIS/$1"
        sudo -u "$(whoami)" -D "/tmp/TALIS/$1" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
    else
        echo "  $1 is already installed. There is nothing to do."
    fi
}

# Installs all needed programs from main repo.
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
maininstall() {
    info "Installing \`$1\` ($n of $total) - $2"
    installpkg "$1"
}

aurinstall() { \
    info "Installing \`$1\` ($n of $total) from the AUR - $2"
    installaur "$1"
}

# Downloads a gitrepo and installs the target
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
gitmakeinstall() {
    local repo="$1"    # URL to the repository
    local comment="$2" # Comment to echo

    progname="$(basename "$repo" .git)"
    dir="$repodir/$progname"
    info "Installing \`$progname\` ($n of $total) via \`git\` and \`make\` - $comment"
    git clone --depth 1 "$repo" "$dir" >/dev/null 2>&1 || { cd "$dir" || return 1 ; git pull --force origin master;}
    # Spawn subshell
    (cd "$dir" && make >/dev/null 2>&1 && sudo make install >/dev/null 2>&1)
}

# Install the specified pip package
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
pipinstall() { \
    info "Installing the Python package \`$1\` ($n of $total) - $2"
    [ -x "$(command -v "pip")" ] || installpkg python-pip >/dev/null 2>&1
    yes | pip install "$1"
}

# Installs all packages defined in the provided progs file
# Adapted from LARBS by Luke Smith (https://github.com/LukeSmithxyz/LARBS)
installationloop() {
    ([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" > /tmp/progs.csv
    sed -i '/^#/d' /tmp/progs.csv
    total=$(wc -l < /tmp/progs.csv)
    while IFS=, read -r tag program comment; do
        n=$((n+1))
        echo "$comment" | grep -q "^\".*\"$" && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"

        if [ -f "$scriptdir/packages/$program/hooks/pre.sh" ]; then
            info "Executing pre-installation hook for \`$program\`"
            sh "$scriptdir/packages/$program/hooks/pre.sh"
        fi

        if [ -f "$scriptdir/packages/$program/hooks/install.sh" ]; then
            info "Installing \`$program\` ($n of $total) - $comment"
            sh "$scriptdir/packages/$program/hooks/install.sh"
        else
            case "$tag" in
                "A") aurinstall "$program" "$comment" ;;
                "G") gitmakeinstall "$program" "$comment" ;;
                "P") pipinstall "$program" "$comment" ;;
                "M") manualinstall "$program" "$comment" ;;
                *) maininstall "$program" "$comment" ;;
            esac
        fi

        if [ -f "$scriptdir/packages/$program/hooks/post.sh" ]; then
            info "Executing post-installation hook for \`$program\`"
            sh "$scriptdir/packages/$program/hooks/post.sh"
        fi
    done < /tmp/progs.csv
}