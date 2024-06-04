echo "Installing Totoro Linux London 06.2024"
echo "What is your root partition (/dev/XXXX)?"
read ROOTTOTORO
echo "What is your boot partition (/dev/XXXX)?"
read BOOTTOTORO
echo "What do you want your username to be?"
read USER
echo "What do you want your passwod to be?"
read PSSWD
echo 
if [ -z "$ROOTTOTORO" ]
then
	echo "You have not set your ROOTTOTORO!"

else
if [ -z "$BOOTTOTORO" ]
then
	echo "You have not set your BOOTTOTORO!"

else	
	if [ -z "$USER" ]
 	then
  	echo "You have not set your USERNAME!"
 	else
  	if [ -z "$PSSWD" ]
   	then
    	echo "You have not set your PSSWD!"
 	else
	echo "Making Filesystems..."
	mkfs.ext4 $ROOTTOTORO
 	mkfs.fat -F32 $BOOTTOTORO
  	echo "DONE!"
  	echo "Mounting Filesystems..."
  	mount $ROOTTOTORO /mnt
   	mount $BOOTTOTORO /mnt/boot --mkdir
    	echo "DONE!"
     	echo "Installing Base System..."
    	pacstrap -K /mnt linux linux-firmware base base-devel
     	echo "MAKING USER"
 	arch-chroot /mnt useradd $USER
  	arch-chroot /mnt passwd $USER < $PSSWD
	arch-chroot /mnt chown +R $USER:$USER /home/$USER
 	arch-chroot /mnt usermod -a -G alex wheel
  	wget https://raw.githubusercontent.com/nowcat123/toroto-linux/master/sudoers -o /mnt/etc/sudoers
   	echo "DONE!"
    	
     	echo "Installing Extra Packages..."
     	wget https://raw.githubusercontent.com/nowcat123/toroto-linux/master/packages.txt -o /mnt/packages.txt
      	arch-chroot /mnt pacman -S - < packages.txt
       	echo "DONE!"
	echo "INSTALLING BOOTLOADER!"
     	arch-chroot /mnt bootctl install
      	echo "DONE!"
       	echo "GENERATING FSTAB"
	genfstab /mnt > /mnt/etc/fstab
	echo "CONFIGURING BOOTLOADER!"
 	echo "title Totoro Linux London" >> /mnt/boot/loader/entries/arch.conf
  	echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/arch.conf
   	echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/arch.conf
    	echo "options root=$ROOTTOTORO rw" >> /mnt/boot/loader/entries/arch.conf
     	echo "" > /mnt/boot/loader/loader.conf
      	echo "timeout 3" >> /mnt/boot/loader/loader.conf
   	echo "default arch.conf" >> /mnt/boot/loader/loader.conf
    	echo "DONE!"
     	echo "BOOTLOADER CHECK!"
      	bootctl list
      	if [ -f /mnt/boot/loader/entries/arch.conf
       	echo "BOOTLOADER GOOD!"
	else
 	echo "BAD BOOTLOADER! ABORTING! Did you not set the boot partitions to be an EFI System Partition?"
  	echo "RERUN THE SCRIPT WITH THE BOOT PARTITON SET TO AN EFI SYSTEM PARTITION!"
  	exit
  	fi
     	echo "Enabling Display Manager"
      	arch-chroot /mnt systemctl enable gdm
       	echo "DONE!"
	echo "Enabling Network Manager"
 	arch-chroot /mnt systemctl enable NetworkManager
  	echo "DONE"
   	echo "INSTALLATION COMPLETED! YOU CAN NOW SAFELY REBOOT YOUR COMPUTER!"
    	
fi
fi
fi
fi

