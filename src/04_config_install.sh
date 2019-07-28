#!/bin/bash

SCRIPT_PATH=$(pwd)

echo "### Begin configuration Archlinux install script ###"

if [ -f "./03_base_install.sh" ]; then
    echo "arch-chroot"
    cp $SCRIPT_PATH/$0 /mnt/
    arch-chroot /mnt ./$0
    exit
fi

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

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf

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

echo "Generating initramfs..."

mkinitcpio -p linux

echo "Grub install"

if [ -d "/sys/firmware/efi/efivars" ]; then
    echo "Install grub in uefi mode..."
    grub-install --target=x86_64-efi --efi-directory=/boot/efi
    --bootloader-id=arch_grub --recheck

    mkdir /boot/efi/EFI/boot
    cp /boot/efi/EFI/arch_grub/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
else
    echo "Install grub in bios mode..."
    grub-install --no-floppy --recheck /dev/sda
fi    

echo "Grub configuration"

os-prober
grub-mkconfig -o /boot/grub/grub.cfg

echo "Give a root password:"
passwd

echo "### End configuration Arch linx install script ###"

SCRIPT_PATH=$(pwd)
echo $SCRIPT_PATH

rm $SCRIPT_PATH/$0
