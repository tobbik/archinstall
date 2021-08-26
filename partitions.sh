# this creates 3 partitions on /dev/sda
# the first is UEFI /boot  512MB big
# the second is     /      30GB big
# the third is      /home  772GB big
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

mkfs.vfat -F32 /dev/nvme0n1p1
mkfs.ext4 -L ARCHROOT /dev/nvme0n1p2
mkfs.ext4 -L ARCHHOME /dev/nvme0n1p3
mkswap    -L ARCHSWAP /dev/nvme0n1p4

#mount  /dev/nvme0n1p2 /mnt
#mkdir  /mnt/boot
#mount  /dev/nvme0n1p1 /mnt/boot
#mkdir  /mnt/home
#mount  /dev/nvme0n1p3 /mnt/home
#swapon /dev/nvme0n1p4

#mkdir /mnt/mnt
#mkdir /mnt/mnt/data1
#mount /dev/sdc1 /mnt/mnt/data1
#mkdir /mnt/mnt/data2
#mount /dev/sdd1 /mnt/mnt/data2

#mkdir /mnt/mnt/datafast
#mount /dev/sda1 /mnt/mnt/datafast
