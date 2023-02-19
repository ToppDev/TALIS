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

# Install the toolchain
rustup default stable

rustup component add rust-src
rustup component add rust-analyzer
rustup component add clippy
rustup component add rustfmt

# Install cargo subcommands
cargo install cargo-update # Update all installed via: cargo install-update -a
cargo install cargo-watch  # Run command when file changes: cargo watch [-x command]...