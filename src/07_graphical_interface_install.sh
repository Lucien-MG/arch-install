#!/bin/bash

SCRIPT_PATH=$(pwd)

if [ -f "./03_base_install.sh" ]; then
    echo "arch-chroot"
    cp $SCRIPT_PATH/$0 /mnt/
    arch-chroot /mnt ./$0
    exit
fi

echo "#### Arch linux install: script 7, graphical install ####"

XORG_P="xorg-server xorg-xinit xorg-apps xorg-twm xterm xorg-xclock"
INPUT_P="xf86-input-mouse xf86-input-keyboard"
USER_P="xdg-user-dirs"
OPENGL_P="mesa"
FONT_P="ttf-bitstream-vera ttf-liberation gnu-free-fonts ttf-dejavu"
VIRTUALBOX_P="xf86-video-vesa virtualbox-guest-utils"

INTEL_GRAPH_P="xf86-video-intel vulkan-intel"
AMD_GRAPH_P="xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon"
NVIDIA_GRAPH_P="nvidia"

gnome="gnome gdm gdm3setup"
cinnamon="cinnamon lightdm-gtk-greeter lightdm-gtk-greeter-settings"
xfce="xfce4 lightdm-gtk-greeter lightdm-gtk-greeter-settings"
mate="mate lightdm-gtk-greeter lightdm-gtk-greeter-settings"

gnome_setup="gdm.service"
cinnamon_setup="lightdm.service"
xfce_setup="lightdm.service"
mate_setup="lightdm.service"

DESK_ENVS_NAME=('gnome' 'cinnamon' 'xfce' 'mate')
DESK_ENVS=("${gnome}" "${cinnamon}" "${xfce}" "${mate}")
DESK_SETUPS=("${gnome_setup}" "${cinnamon_setup}" "${xfce_setup}" "${mate_setup}")

read -p "Do you want a graphical interface ? [Y/n] " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $XORG_P $INPUT_P $USER_P $FONT_P $OPENGL_P
else
    exit
fi

read -p "Are you in a virtual machine ? [Y/n] " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $VIRTUALBOX_P
    systemctl enable vboxservice
fi

read -p "Install intel video driver ? [Y/n] " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $INTEL_GRAPH_P
fi

read -p "Install amd video driver ? [Y/n] " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $AMD_GRAPH_P
fi

read -p "Install nvidia video driver ? [Y/n] " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    pacman -Syu $NVIDIA_GRAPH_P
fi                               

COUNT=0

for DESK_ENV in ${DESK_ENVS_NAME[@]}
do
    echo "${COUNT}/ ${DESK_ENV}"
    COUNT=$(($COUNT+1))
done

read -p "Choose your desktop environment: " NB_DESK

# Install the environment
DESK_ENV_SELECTED=${DESK_ENVS[$NB_DESK]}
pacman -Syu $DESK_ENV_SELECTED

# Enable display manager
DESK_SETUP_SELECTED=${DESK_SETUPS[$NB_DESK]}
systemctl enable $DESK_SETUP_SELECTED

# Set fr keyboard for x11
# localectl set-x11-keymap fr

echo "#### script 7 terminated ####"
