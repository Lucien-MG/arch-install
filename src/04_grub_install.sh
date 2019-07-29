#!/bin/bash -                                                                   
#title          :04_grub_install.sh                                             
#author         :Lucien Martin Gaffé                                            
#date           :29/07/2019                                                     
#version        :0.1.0                                                          
#usage          :                                                               
#notes          :                                                               
#bash_version   :4.0+                                                           
#=========================================================================== 

SCRIPT_PATH=$(pwd)

echo "#### Arch linux install: script 4, grub install ####"
                                                                                
if [ -f "./03_base_install.sh" ]; then                                          
    echo "arch-chroot"                                                          
    cp $SCRIPT_PATH/$0 /mnt/                                                    
    arch-chroot /mnt ./$0                                                       
    exit                                                                        
fi    

echo "Grub install"
if [ -d "/sys/firmware/efi/efivars" ]; then
    echo "Install grub in uefi mode..."
    grub-install --target=x86_64-efi --boot-directory=/boot --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
    
    mkdir -p /boot/efi/EFI/boot
    cp /boot/efi/EFI/arch_grub/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
else
    echo "Install grub in bios mode..."
    grub-install --no-floppy --recheck /dev/sda
fi

echo "#### script 4 terminated ####"
