#!/bin/bash -                                                                   
#title          :05_config_install.sh                                             
#author         :Lucien Martin Gaffé                                            
#date           :29/07/2019                                                     
#version        :0.1.0                                                          
#usage          :                                                               
#notes          :                                                               
#bash_version   :4.0+                                                           
#=========================================================================== 

SCRIPT_PATH=$(pwd)

echo "### Begin configuration Archlinux install script ###"

if [ -f "./03_base_install.sh" ]; then
    echo "arch-chroot"
    cp $SCRIPT_PATH/$0 /mnt/
    arch-chroot /mnt ./$0
    exit
fi

LANG_ARRAY=("us" "fr")
LANG_CODE_ARRAY=("en_US.UTF-8" "fr_FR.UTF-8")

# The user indicate his time zone
echo "Configuration of your time zone"

ls /usr/share/zoneinfo/
read -p "Choose a region: " REGION

ls /usr/share/zoneinfo/$REGION/
read -p "Choose a city: " CITY

# The time zone is linked in /etc/localtime 
echo "Generate time zone config ..."

ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc

echo "Time zone setup."

echo "Configuration of your localisation"
echo "(Choose your language and keyboard)"

COUNT=0

for L in ${LANG_ARRAY[@]}
do
    echo "$COUNT/ ${L}"
    COUNT=$(($COUNT+1))
done

read -p "Choose your language: " NB_LANG

LANG_CODE=${LANG_CODE_ARRAY[$NB_LANG]}

echo "LANG=${LANG_CODE}" >> /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf

sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen

if ! [ $COUNT -eq 0 ]; then
    sed -i "s/#${LANG_CODE} UTF-8/${LANG_CODE} UTF-8/g" /etc/locale.gen
fi

echo "KEYMAP=fr-latin1" >> /etc/vconsole.conf
echo "FONT=lat9w-16" >> /etc/vconsole.conf

echo "Generating traduction..."

locale-gen

echo "Traduction generated."

# The user give some network configuration
echo "Network configuration"

read -p "Choose a host name for your machine: " HOSTNAME
mkdir /etc/$HOSTNAME

echo "127.0.0.1    localhost" >> /etc/hosts
echo "::1          localhost" >> /etc/hosts
echo "127.0.1.1    ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts

echo "Generating initramfs..."

mkinitcpio -p linux

echo "Grub configuration"

os-prober
grub-mkconfig -o /boot/grub/grub.cfg

echo "Give a root password:"
passwd

read -p "Activiate sudo group (wheel) ? [Y/n] " SUDO_ACTIV

if [[ SUDO_ACTIV =~ ^[Yy]$ ]];then
    sed -i "s/#  %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers
fi

echo "### End configuration Arch linx install script ###"

SCRIPT_PATH=$(pwd)
echo $SCRIPT_PATH

rm $SCRIPT_PATH/$0
