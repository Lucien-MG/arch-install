#!/bin/bash -
#title          :01_setup_install.sh
#author         :Lucien Martin Gaffé
#date           :29/07/2019
#version        :0.1.0
#usage          :
#notes          :
#bash_version   :4.0+
#===========================================================================

set -e

echo "#### Archlinux install: script 1, setup ####"

# Load keyboard
echo "Available Keyboard:"

# /usr/share/kbd/locale contain all available keyboards
ls /usr/share/kbd/locale
read -p "Choose your keyboard layout: " KEYBOARD

# Command loadkeys allow to change the keyboard
loadkeys $KEYBOARD

if [ $? -eq 0 ]; then
    echo "Keyboard setup."
else
    echo "Keyboard setup fail. Choose an existant keyboard."
fi

# Check if the machine is in EFI or CSM mode
# Folder efi exit only in mode EFI
if [ -d "/sys/firmware/efi/efivars" ]; then
    echo "EFI mode is enabled."
    echo "An efi partition will be required."
else
    echo "CSM mode is enabled."
fi

# Check if network is up
echo "Checking network..."

# ping -> -c nb = the number of request to send
#      -> -q = quiet output
#      -> -W nb = time to wait for a response
if ping -q -c 1 -W 5 google.com >/dev/null; then
    echo "The network is up."
else
    echo "The network is down."
    read -p "Do you want to connect to internet through wi-fi ? [Y/n] " DIALOG_ANSWER

    if [[ $DIALOG_ANSWER =~ ^[Yy]$ ]]; then
        wifi-menu
    else
        echo "Impossible to perform the installation without internet. EXIT."
        exit
    fi
fi

# Update the system clock
timedatectl set-ntp true

# Check the system clock
timedatectl status

echo "#### script 1 terminated ####"
