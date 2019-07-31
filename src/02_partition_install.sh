#!/bin/bash -                                                                   
#title          :02_partition_install.sh                                            
#author         :Lucien Martin Gaffé                                            
#date           :29/07/2019                                                     
#version        :0.1.0                                                          
#usage          :                                                               
#notes          :                                                               
#bash_version   :4.0+                                                           
#===========================================================================

echo "#### Arch linux install: script 2, partition ####"

if [ -d "/sys/firmware/efi/efivars" ]; then 
    echo "GPT partition: "
    FOLDER_PART='gpt'
else 
    echo "MBR partition: "
    FOLDER_PART='mbr'
fi

ls ../partition-sample/$FOLDER_PART/ 
 
read -p "Which partitionning do you want ? " PARTITIONNING

/bin/bash ../partition-sample/$FOLDER_PART/$PARTITIONNING

echo "#### script 2 terminated ####"
