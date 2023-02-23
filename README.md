# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)

## Installation

- First follow the instructions in `000-BaseInstall.md`
- Still on the stick after changing into the newly installed file system, run the following
    ```
    cd /tmp
    git clone https://github.com/ToppDev/TALIS.git
    cd TALIS && ./010-InstallOnStick.sh
    ```
- Reboot the system and login into the installed system as the user you created
- Then execute the `100-PostInstallationConfig.sh` script. If you have personal scripts to execute this can be done via the `--privaterepo` option (replace the URL with your own)
    ```
    sh ~/.local/src/TALIS/100-PostInstallationConfig.sh --dotfiles="https://github.com/ToppDev/dotfiles.git" --privaterepo="https://github.com/ToppDev/TALIS-private.git"
    ```
   The private repo executes the script `restore.sh` within it.

## What is TALIS?

TALIS is a script collection to automatically install and configure an Artix or Arch Linux environment.

## Acknowledgements

Some ideas and code was taken from other projects. Credits for those go to

* Luke Smith ([LARBS](https://github.com/LukeSmithxyz/LARBS))