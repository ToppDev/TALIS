# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)

## Installation

- First follow the instructions in `000-BaseInstall.md`
- Still on the stick after changing into the newly installed file system, run the following
    ```
    cd /tmp
    git clone https://github.com/ToppDev/TALIS.git
    cd TALIS
    sh 010-InstallOnStick.sh
    ```
- Reboot the system and login into the installed system as the user you created
- Then execute the script `100-PostInstallationConfig.sh`
- If you have personal scripts to execute afterwards this can be done via `200-PersonalConfig.sh`

## What is TALIS?

TALIS is a script collection to automatically install and configure an Artix or Arch Linux environment.

This script is a merge between my own installation scripts and the scripts from [LARBS](https://github.com/LukeSmithxyz/LARBS) by Luke Smith.
