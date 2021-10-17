# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)

## Installation

- First follow the instructions in `000-BaseInstall.md`
- Still on the stick after changing into the newly installed file system, run the following
    ```
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ToppDev/TALIS/main/010-InstallOnStick.sh)"
    ```
- Reboot the system and login into the installed system as the user you created
- Then execute the script
    ```
    sh ~/.local/src/TALIS/100-PostInstallationConfig.sh -r https://github.com/ToppDev/dotfiles.git
    ```
- If you have personal scripts to execute afterwards this can be done via (replace the URL with your own)
    ```
   sh ~/.local/src/TALIS/200-PersonalConfig.sh -r <PRIVATE-REPO>
   ```
   It simply puts your private repo into the folder `~/.local/src` and then executes the script `private.sh` within it.

## What is TALIS?

TALIS is a script collection to automatically install and configure an Artix or Arch Linux environment.

## Acknowledgements

Some ideas and code was taken from other projects. Credits for those go to

* Luke Smith ([LARBS](https://github.com/LukeSmithxyz/LARBS))