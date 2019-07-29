#!/bin/bash

read -p "Proceed to install ? [Y/n] " M_INSTALL_ANSWER

if [[ $M_INSTALL_ANSWER =~ ^[Yy]$ ]]; then

    /bin/bash 01_setup_install.sh

    /bin/bash 02_partition_install.sh

    /bin/bash 03_base_install.sh

    /bin/bash 04_grub_install.sh

    /bin/bash 05_config_install.sh

    /bin/bash 06_recommanded_package_install.sh

    /bin/bash 07_graphical_interface_install.sh

    /bin/bash 08_create_user_install.sh

    echo "Remove the installation media."

    read -p "Installation finished, do you want to reboot ? [Y/n] " M_REBOOT

    if [[ $M_REBOOT =~ ^[Yy]$ ]]; then
        reboot
    fi
fi 
