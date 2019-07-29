#!/bin/bash

read -p "Proceed to install ? [Y/n] " M_INSTALL_ANSWER

if [[ $M_INSTALL_ANSWER =~ ^[Yy]$ ]]; then

    source 01_setup_install.sh

    source 02_partition_install.sh

    source 03_base_install.sh

    source 034_grub_install.sh

    source 04_config_install.sh

    source 05_recommanded_package_install.sh

    source 06_graphical_interface_install.sh

    source 07_create_user_install.sh

    echo "Remove the installation media."
    reboot
fi 
