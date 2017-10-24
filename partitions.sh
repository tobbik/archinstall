# this creates 3 partitions on /dev/sda
# the first is UEFI /boot  512MB big
# the second is     /      20GB big
# the third is      /home  430GB big
#the reminder is swap

fdisk -u /dev/sda << EOFDISK
n
p


+512M
n
p


+20G
n
p


+430G
n
p



w
EOFDISK

mkfs.vfat -F32 /dev/sda1
mkfs.ext4      /dev/sda2
mkfs.ext4      /dev/sda3
mkswap         /dev/sda4

mount  /dev/sda2 /mnt
mkdir  /mnt/boot
mount  /dev/sda1 /mnt/boot
mkdir  /mnt/home
mount  /dev/sda3 /mnt/home
swapon /dev/sda4

