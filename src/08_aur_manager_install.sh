#!/bin/bash

SCRIPT_PATH=$(pwd)

if [ -f "./03_base_install.sh" ]; then                                          
    echo "arch-chroot"                                                          
    cp $SCRIPT_PATH/$0 /mnt/                                                    
    arch-chroot /mnt ./$0                                                       
    exit                                                                        
fi   

if [ $(id -u) = 0 ]; then
    echo "This script can't be execute as root."
    exit
fi

WRAPPERS=('trizen' 'pacaur' 'yay')

read -p "Do you want to install a pacman wrapper ? [Y/n]: " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    
    if ! [ -x "($command -v git)" ]; then
        echo "Git must be install to perform this action."
        exit
    fi

    COUNT=0

    for WRAP in ${WRAPPERS[@]}
    do
        echo "${COUNT}/ ${WRAP}"
        COUNT=$(($COUNT+1))
    done

    read -p "Choose a pacman wrapper: " NB_WRAPPER

    WRAPPER=${WRAPPERS[$NB_WRAPPER]}
    git clone https://aur.archlinux.org/$WRAPPER ~/$WRAPPER

    cd ~/$WRAPPER
    makepkg -si
    cd
fi
