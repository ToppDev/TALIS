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

# Install Oh My Zsh
if [ ! -d "/home/$(whoami)/.local/share/oh-my-zsh" ]; then
    # export ZSH     Changes the installation location
    # --unattended   Won't change the default shell and won't run zsh when the installation has finished

    export ZSH="/home/$(whoami)/.local/share/oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
    rm -f /home/$(whoami)/.zshrc.pre-oh-my-zsh* >/dev/null 2>&1
    rm -f /home/$(whoami)/.shell.pre-oh-my-zsh* >/dev/null 2>&1
fi

# Make zsh the default shell for the user.
sudo chsh -s /bin/zsh $(whoami)
mkdir -p "/home/$(whoami)/.cache/zsh/"

# Fish-like autosuggestions for zsh
pacinstall zsh-autosuggestions
# Powerlevel10k is a theme for Zsh. It emphasizes speed, flexibility and out-of-the-box experience
pacinstall zsh-theme-powerlevel10k
# Additional completion definitions for Zsh
pacinstall zsh-completions
# Optimized and extended zsh-syntax-highlighting
aurinstall zsh-fast-syntax-highlighting


# TODO: Add zsh-fast-syntax-highlighting to the .zshrc
# TODO: Add zsh-autosuggestions to the .zshrc
# TODO: Add zsh-theme-powerlevel10k to the .zshrc
# TODO: Add zsh-completions to the .zshrc