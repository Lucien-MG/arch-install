#!/bin/bash

(
echo o      # Create a new empty GPT partition table
echo y      # accept to create partition table
echo n      # Add a new partion
echo 1      # Partition number
echo        # First sector
echo +128M  # Last sector
echo        # Linux filesystem 
echo n      # Add a new partition
echo 2      # Partition number
echo        # First sector
echo        # Last sector
echo        # Linux filesystem
echo w      # Write changes
echo y      # Accept
) | gdisk /dev/sda

read -p "Do you want to format the partitions ? [Y/n] " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]];then
    echo "Formating partition..."
    mkfs.ext4 /dev/sda2
    mkfs.fat -F32 /dev/sda1
    echo "Partition formated."
fi

read -p "Do you want to mount the partitions ? [Y/n] " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]];then
    echo "Mounting partition..."
    umount -R /mnt
    mount /dev/sda2 /mnt
    mkdir -p /mnt/boot/efi
    mount /dev/sda1 /mnt/boot/efi
    echo "Partition mounted."
fi
