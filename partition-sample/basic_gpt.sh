#!/bin/bash

(
echo o # Create a new empty DOS partition table
echo n # Add a new partion
echo p # Primary partition
echo 1 # Partition number
echo   # First sector
echo +128M  # Last sector
echo n
echo p
echo 2
echo 
echo 
echo w # Write changes
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
    mount /dev/sda1 /mnt
    echo "Partition mounted."
fi
