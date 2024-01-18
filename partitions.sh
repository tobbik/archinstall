# this creates 3 partitions on /dev/sda
# the first is UEFI /boot  512MB big
# the second is     /      30GB big
# the third is      /home  772GB big
#the reminder is swap
#
DISKNAME=/dev/sda

#fdisk -u ${DISKNAME} << EOFDISK
#n
#p
#
#
#+512M
#n
#p
#
#
#+20G
#n
#p
#
#
#+430G
#n
#p
#
#
#
#w
#EOFDISK

gdisk ${DISKNAME} << EOGDISK
n
1

+512M
EF00
n
2

+28G
8304
n
3

+445G
8302
n
4


8200
c
1
EFI
c
2
ARCHROOT
c
3
ARCHHOME
c
4
ARCHSWAP
w
EOGDISK

mkfs.vfat -F32 "${DISKNAME}1"
mkfs.ext4 -L ARCHROOT "${DISKNAME}2"
mkfs.ext4 -L ARCHHOME "${DISKNAME}3"
mkswap    -L ARCHSWAP "${DISKNAME}4"

#mount  "${DISKNAME}2" /mnt
#mkdir  /mnt/boot
#mount  "${DISKNAME}1" /mnt/boot
#mkdir  /mnt/home
#mount  "${DISKNAME}3" /mnt/home
#swapon "${DISKNAME}4"

#mkdir /mnt/mnt
#mkdir /mnt/mnt/data1
#mount /dev/sdc1 /mnt/mnt/data1
#mkdir /mnt/mnt/data2
#mount /dev/sdd1 /mnt/mnt/data2

#mkdir /mnt/mnt/datafast
#mount /dev/sda1 /mnt/mnt/datafast
