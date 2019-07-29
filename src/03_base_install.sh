#!/bin/bash -
#title          :
#author         :Lucien Martin Gaffé
#date           :
#version        :
#usage          :
#notes          :
#bash_version   :
#===========================================================================

# Minimal Installation
# Install arch base
# Add ntfs-3g and os-prober to detect windows in dual-boot case
# Add laptop-detect to know if tlp is necessary
# Add bash completion 
BASE_PACKAGES="base base-devel pacman-contrib bash-completion"
GRUB_PACKAGES="grub efibootmgr os-prober ntfs-3g"

read -p "Do you want to install arch linux base ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacstrap /mnt $BASE_PACKAGES $GRUB_PACKAGES
else
    echo "Install stoped"
    exit
fi

if [ $? -eq 0 ]; then
    echo "Arch linux base installed"
else
    echo "Installation failed."
    echo "Is the partition mount on /mnt ?"
    exit
fi

# Generate an fstab file.
# The fstab file can be used to define how disk partitions,
# various other block devices, or remote filesystems should be mounted
# into the filesystem.
echo "Generating fstab..."

genfstab -U /mnt >> /mnt/etc/fstab

if [ $? -eq 0 ]; then
    echo "fstab generated"
else
    echo "failed to generate fstab"
fi
