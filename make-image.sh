FILENAME=disk.img
MNT=`pwd`/mnt
dd if=/dev/zero of=$FILENAME bs=512 count=50000
# This creates one partition, makes it type 'c  W95 FAT32 (LBA)' and activates it (Boot flag).
echo -e "n\np\n1\n2048\n49999\na\nt\nc\nw\n" | fdisk $FILENAME
LOOP0=`losetup -f`
sudo losetup $LOOP0 disk.img
LOOP1=`losetup -f`
sudo losetup $LOOP1 disk.img -o 1048576 # mount partition 1
sudo mkdosfs $LOOP1
sudo mkdir -p $MNT
sudo mount $LOOP1 $MNT
sudo grub-install --root-directory=$MNT --no-floppy --modules="normal part_msdos ext2 multiboot" $LOOP0
sudo cp grub.cfg $MNT/boot/grub/grub.cfg
cd init
sudo ./make-init.sh
cd ..
sudo cp init/init.bin $MNT/init.bin
sudo umount $MNT
sudo losetup -d $LOOP0
sudo losetup -d $LOOP1
rm -rf $MNT
sync
