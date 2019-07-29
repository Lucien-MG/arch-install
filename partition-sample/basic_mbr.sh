#!/bin/bash

(
echo o # Create a new empty DOS partition table
echo n # Add a new partion
echo p # Primary partition
echo 1 # Partition number
echo   # First sector
echo   # Last sector 
echo w # Write changes
) | sudo fdisk /dev/sda

read -p "Do you want to mount the partitions ? [Y/n] " ANSWER

if [[ ANSWER =~ ^"Yy"$ ]];then
    umount -R /mnt
    mount /dev/sda1 /mnt
fi
