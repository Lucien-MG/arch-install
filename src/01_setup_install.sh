#!/bin/bash -
#title          :
#author         :Lucien Martin Gaffé
#date           :
#version        :
#usage          :
#notes          :
#bash_version   :
#===========================================================================

# BEGIN

echo ""
echo "#### Setup Archlinux install script ####"

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
    echo "Keyboard setup fail."
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
if ping -q -c 1 -W 3 google.com >/dev/null; then
    echo "The network is up."
else
    echo "The network is down."
    read -p "Do you want to connect to internet through wi-fi ? [Y/n]: " DIALOG_ANSWER
    if [[ $DIALOG_ANSWER =~ ^[Yy]$ ]]; then
        wifi-menu
    else
        echo "Impossible to perform the installation without internet."
        echo "EXIT"
        exit
    fi
fi

# Update the system clock 
timedatectl set-ntp true

timedatectl status

echo "Time for you to partition your disk."

echo "#### End setup Archlinux script ####"
echo ""

# END
