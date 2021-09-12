#!/bin/sh
# ToppDev's Arch Linux Installation Scripts (TALIS)
# by Thomas Topp <dev@topp.cc>
# License: GNU GPLv3

# ########################################################################################################## #
#                                               Helper scripts                                               #
# ########################################################################################################## #

scriptdir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source "$scriptdir/helper/color.sh"
source "$scriptdir/helper/log.sh"
source "$scriptdir/helper/checkArchRootInternet.sh"

# ########################################################################################################## #
#                                              Check Arch distro                                             #
# ########################################################################################################## #

check_arch_internet

export repodir="/home/$(whoami)/.local/src"

# ########################################################################################################## #
#                                            Options and Variables                                           #
# ########################################################################################################## #

# Print the usage message
usage() {
    echo "Required arguments:"
    echo "  -r: Private script repository (local file or url)"
    echo "Optional arguments:"
    echo "  -h: Show this message"
    exit 1
}

while getopts ":a:r:b:p:h" flag; do
    case "${flag}" in
        h) usage ;;
        r) repo=${OPTARG}  ;;
        b) repobranch=${OPTARG} ;;
        *) printf "Invalid option: -%s\\n" "$OPTARG" && exit 1 ;;
    esac
done

[ -z "$repo" ] && echo -e "Dotfiles repository is required. Please specify -r\\n" && usage
[ -z "$repobranch" ] && repobranch="main"

git ls-remote "$repo" -b $repobranch | grep -q $repobranch || error "The remote repository \"$repo\" on branch \"$repobranch\" can't be accessed."

# ########################################################################################################## #
#                                               Private script                                               #
# ########################################################################################################## #

box "Storing TALIS private script in user folder"

[ ! -d $repodir/TALIS-private ] && git clone $repo $repodir/TALIS-private -b $repobranch

git --git-dir= "$repodir/TALIS-private/.git" --work-tree "$repodir/TALIS-private" pull

box "Executing TALIS private script"

sh $repodir/TALIS-private/private.sh