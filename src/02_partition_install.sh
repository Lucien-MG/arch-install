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

echo "This script give you partition sample to help"
echo "you to partition your disk."
echo "You just need to choose the partition sample"
echo "and answer to question."
echo "But, if you to partition by yourself just answer no to"
echo "the next question and mount your partition on /mnt to"
echo "continue to use the script."

read -p "Do you want to use partition script ? " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then

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
else
    exit
fi

echo "#### script 2 terminated ####"
