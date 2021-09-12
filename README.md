# ToppDev's Artix Linux Installation Scripts (TALIS)

## Installation

- First follow the instructions in 000-BaseInstall.md
- Still on the stick after changing into the newly installed file system, run the following
    ```
    cd /tmp
    curl -LO https://raw.githubusercontent.com/ToppDev/TALIS/main/010-InstallOnStick.sh
    chmod +x 010-InstallOnStick.sh
    sh 010-InstallOnStick.sh
    ```
- Reboot the system and login into the installed system as root user