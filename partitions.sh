# this creates 3 partitions on /dev/sda
# the first is UEFI /boot  512MB big
# the second is     /      28GB big
# the third is      /home  445GB big
#the reminder is swap
#
DISKNAME=/dev/sda

# wipe entire disk
#gdisk ${DISKNAME} << EOGWIPE
#x
#z
#Y
#Y
#EOGWIPE

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

mkfs.vfat     -F32 -n XBOOTLDR "${DISKNAME}5"
y | mkfs.ext4      -L ARCHROOT "${DISKNAME}6"
y | mkfs.ext4      -L ARCHHOME "${DISKNAME}7"
mkswap             -L ARCHSWAP "${DISKNAME}8"

mount  "${DISKNAME}6" /mnt
mkdir  /mnt/{efi,boot,home}
mount  "${DISKNAME}1" /mnt/efi
mount  "${DISKNAME}5" /mnt/boot
mount  "${DISKNAME}7" /mnt/home
swapon "${DISKNAME}8"

#mkdir /mnt/mnt
#mkdir /mnt/mnt/data1
#mount /dev/sdc1 /mnt/mnt/data1
#mkdir /mnt/mnt/data2
#mount /dev/sdd1 /mnt/mnt/data2

#mkdir /mnt/mnt/datafast
#mount /dev/sda1 /mnt/mnt/datafast
