This manual describes the needed commands for a new [Arch](https://archlinux.org/) Linux installation from USB

For further information read
- [arch Installation guide](https://wiki.archlinux.org/title/Installation_guide)

## Installation medium

### Aquire an installation image

Download an up-to-date image: [archlinux-YYYY.MM.DD-x86_64.iso](https://archlinux.org/download/):

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
ArchLinux will automatically log you in as `root`

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
ping archlinux.org
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
gdisk /dev/sda
    p              # Print the partition table
    d              # Delete previous partitions
    n, +1G,   EF00 # Create EFI partition
    n, +18G,  8200 # Create Swap partition
    n, Enter, 8300 # Create Linux filesystem
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
```
# Install base system
pacstrap /mnt base base-devel linux linux-firmware vim git bash-completion

# Generate an fstab file
genfstab -U /mnt >> /mnt/etc/fstab

# Change root into the new system
arch-chroot /mnt

# Select mirror (put Europe/Berlin entries to the top)
vim /etc/pacman.d/mirrorlist
```