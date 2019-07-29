#!/bin/bash

read -p "Proceed to install ? [Y/n] " M_INSTALL_ANSWER

if [[ $M_INSTALL_ANSWER =~ ^[Yy]$ ]]; then

    source 01_setup_install.sh

    source 02_partition_install.sh

    source 03_base_install.sh

    source 04_grub_install.sh

    source 05_config_install.sh

    source 06_recommanded_package_install.sh

    source 07_graphical_interface_install.sh

    source 08_create_user_install.sh

    echo "Remove the installation media."

    read -p "Installation finished, do you want to reboot ? [Y/n]" M_REBOOT

    if [[ $M_REBOOT =~ ^[Yy]$ ]]
        reboot
    fi
fi 
