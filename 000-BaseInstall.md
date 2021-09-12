This manual describes the needed commands for a new [Artix](https://artixlinux.org/)/[Arch](https://archlinux.org/) Linux installation from USB

For further information read
- [artix Installation](https://wiki.artixlinux.org/Main/Installation)
- [arch Installation guide](https://wiki.archlinux.org/title/Installation_guide)

## Installation medium

### Aquire an installation image

Download an up-to-date image from the links below
- [Artix Linux](https://artixlinux.org/download.php): artix-base-runit-x86_64.iso
- [Arch Linux](https://archlinux.org/download/): archlinux-x86_64.iso

### Prepare an installation medium

The preferred medium is an [USB flash drive](https://wiki.archlinux.org/title/USB_flash_installation_medium)

#### On Linux Systems:

Find out the name of your USB drive
```
lsblk
```

Copy the iso to the USB stick, replacing `/dev/sdx` with your drive, e.g. `/dev/sdb`. (Do not append a partition number, so do not use something like `/dev/sdb1`):
```
dd bs=4M if=path/to/archlinux-version-x86_64.iso of=/dev/sdx conv=fsync oflag=direct status=progress
```

### Boot into the usb stick

Restart your computer and select the bootable usb drive from the boot menu (F12 / F2 / Del)

## Login
ArchLinux will automatically log you in as `root`. On Artix login with the information below.
```
Username: root
Password: artix
```

## Set the keyboard layout

To check the available layout types:
```
ls -R /usr/share/kbd/keymaps
```
Load the preferred layout
```
loadkeys de
```

## Discover Legacy Bios/UEFi
If the following command returns something, you are using UEFI
```bash
ls /sys/firmware/efi/efivars/
```

## Connect to the internet
### Check for internet connection
```bash
ping artixlinux.org
```
If this fails follow the [ArchLinux wiki](https://wiki.archlinux.org/title/Installation_guide#Connect_to_the_internet)

## Partition the disk
If reinstalling linux you have to first turn off the old swap partition (in this example `/dev/sda2`)
```bash
swapoff /dev/sda2
```
Then repartition the drive (in this example `/dev/sda` is used)
```bash
# List available disks (or use fdisk -l)
lsblk

# Create new partition
fdisk /dev/sda
    p          # Print the partition table
    d          # Delete previous partitions
    n, +1G,    # Create EFI partition
    n, +18G,   # Create Swap partition
    n, Enter   # Create Linux filesystem
    t, 1, 1    # Assign the type to 'EFI System'
    t, 2, 19   # Assign the type to 'Linux swap'
    w          # write table to disk and exit

# Make the file system (Legacy Bios would have a ext4 EFI partition):
mkfs.fat -F 32 -n BOOT /dev/sda1     # EFI
mkswap -L SWAP /dev/sda2             # Swap
mkfs.ext4 -L ROOT /dev/sda3          # Root

# Mount the partitions
mount -L ROOT /mnt                   # Root
mkdir -p /mnt/boot
mount -L BOOT /mnt/boot              # EFI
swapon -L SWAP                       # Swap
```

## Install base system
On ArchLinux use `pacstrap`, `genfstab` and `arch-chroot`
```
# Install base system
basestrap /mnt base base-devel runit elogind-runit linux linux-firmware vim git bash-completion

# Generate an fstab file
fstabgen -U /mnt >> /mnt/etc/fstab

# Change root into the new system
artix-chroot /mnt

# Select mirror (put Europe/Berlin entries to the top)
vim /etc/pacman.d/mirrorlist
```