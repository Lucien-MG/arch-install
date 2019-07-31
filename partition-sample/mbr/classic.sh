# Create a new empty DOS partition table

read -p "Do you want an auto size selection for your partition ? [Y/n] " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then
    ROOT_S="6G"
    SWAP_S="1G"
    HOME_S=""
else 
    echo "Choose the size by yourself:"
    echo "Give size with this format: size{K,M,G,T,P}"
    read -p "Choose the size of swap: " SWAP_S
    read -p "Choose the size of root: " ROOT_S

    read -p "Do you want that the home part fulfill the disk? [Y/n] " ANSWER

    if [[ $ANSWER =~ ^[Yy] ]]; then
        HOME_S=""
    else
        read -p "Choose the size of home: " HOME_S
        HOME_S=+$HOME_S
    fi
fi

(
echo o      # Create a new dos partition
echo n      # Add a new partition                                                      
echo p      # Primary partition                                                      
echo 1      # Partition number                                                       
echo        # First sector                                                           
echo +512M  # Last sector
echo n      # Add a new partition
echo p      # Primary partition
echo 2      # Partition Number
echo        
echo "+${SWAP_S}"
echo n
echo p
echo 3
echo 
echo "+${ROOT_S}"
echo n
echo p
echo 
echo "${HOME_s}"
echo w      # Write changes                                                          
) | fdisk /dev/sda

read -p "Do you want to format the partitions ? [Y/n] " ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]];then                                                 
    echo "Formating partition..."                                               
    mkfs.ext4 /dev/sda1
    mkswap /dev/sda2
    mkfs.ext4 /dev/sda3
    mkfs.ext4 /dev/sda4
    echo "Partition formated."                                                  
fi                                                                              

read -p "Do you want to mount the partitions ? [Y/n] "ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]];then                                                 
   echo "Mounting partition..."                                                
   umount -R /mnt      
   mount /dev/sda3 /mnt
   mkdir -p /mnt/boot
   mount /dev/sda1 /mnt/boot
   mkdir -p /mnt/home
   mount /dev/sda4 /mnt/home
   swapon /dev/sda2
   echo "Partition mounted."                                                   
fi            
