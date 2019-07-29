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

ls ../partition-sample/
    
read -p "Which partitionning do you want ? " PARTITIONNING
    
/bin/bash ../partition-sample/$PARTITIONNING

echo "#### script 2 terminated ####"
