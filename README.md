# ToppDev's Artix/Arch Linux Installation Scripts (TALIS)

## Installation

- First follow the instructions in 000-BaseInstall.md
- Still on the stick after changing into the newly installed file system, run the following
    ```
    cd /tmp
    curl -LO https://raw.githubusercontent.com/ToppDev/TALIS/main/100-ConfigureBaseSystem.sh
    chmod +x 100-ConfigureBaseSystem.sh
    ./100-ConfigureBaseSystem.sh
    ```
- Reboot the system and login into the installed system as root user