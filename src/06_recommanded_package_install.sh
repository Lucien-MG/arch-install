#!/bin/bash

SCRIPT_PATH=$(pwd)

if [ -f "./03_base_install.sh" ]; then                                          
    echo "arch-chroot"                                                          
    cp $SCRIPT_PATH/$0 /mnt/                                                    
    arch-chroot /mnt ./$0                                                       
    exit                                                                        
fi

echo "#### Arch linux install: script 6, package install ####"

NETWORK_P="networkmanager"
SYSTEM_P="udev acpid hdparm lsb-release exfat-utils dosfstools cups laptop-detect"
AMDU_P=" amd-ucode "
INTELU_P=" intel-ucode "
LAPTOP_P="tlp acpi_call tp_smapi x86_energy_perf_policy"
SYSTEMADMIN_P="syslog-ng mc mtools dialog git"
COMPTOOLS_P="zip unzip p7zip"
SOUND_P="alsa-utils"
FOOMATIC_P="cups foomatic-db foomatic-db-ppds foomatic-db-gutenprint-ppds"
FOOMATIC_P2="foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint"
MULTIMEDIA_P="gst-plugins-base gst-plugins-good gst-plugins-bad gst-libav"
MULTIMEDIA_P2="gst-plugins-ugly"
VIM_P="vim"
ZSH_P="zsh"

read -p "Install and setup network manager ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $NETWORK_P
    systemctl enable NetworkManager
fi

read -p "Install system utils ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then

    PROC=$(cat /proc/cpuinfo | grep GenuineIntel)

    if [[ $PROC -eq "" ]]; then
        $SYSTEM_P=$SYSTEM_P$AMDU_P
    else
        $SYSTEM_P=$SYSTEM_P$INTELU_P
    fi

    pacman -Syu $SYSTEM_P

    read -p "Are you on an ssd ? [Y/n]" ANSWER

    if [[ $ANSWER =~ ^[Yy]$ ]]; then
        systemctl enable fstrim.service fstrim.timer
        echo "Trim enabled weekly."
    fi

    laptop-detect

    if [[ $? -eq 0 ]]; then
        echo "Laptop detected."
        pacman -Syu $LAPTOP_P

        systemctl enable tlp.service tlp-sleep.service
        echo "Laptop packages installed."
    fi
fi

read -p "Install system admin utils ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $SYSTEMADMIN_P
fi

read -p "Install compression tools ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $COMPTOOLS_P
fi

read -p "Install sound manager ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $SOUND_P
    alsamixer
    alsactl store
fi

read -p "Install printer drivers ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $FOOMATIC_P $FOOMATIC_p2
fi

read -p "Install multimedia libs ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $MULTIMEDIA_P $MULTIMEDIA_P2
fi

read -p "Install vim ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $VIM_P 
fi

read -p "Install zsh ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $ZSH_P 
fi

echo "#### script 06 terminated ####"
