# this creates 4 partitions on ${DISKBASEDEVPATH}
# #1. is ESP    /boot   512MB
# #2. is ROOT   /       32GB
# #3. is HOME   /home   444GB
# #4. is SWAP   <swap>  remainder

source config.sh

# wipe entire disk
#gdisk ${DISKBASEDEVPATH} << EOGWIPE
#x
#z
#Y
#Y
#EOGWIPE

gdisk ${DISKBASEDEVPATH} << EOGDISK
n
1

+512M
EF00
n
2

+32G
8304
n
3

+444G
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
p
w
EOGDISK

mkfs.vfat     -F32 -n EFI      "${DISKBOOTDEVPATH}"
y | mkfs.ext4      -L ARCHROOT "${DISKROOTDEVPATH}"
y | mkfs.ext4      -L ARCHHOME "${DISKHOMEDEVPATH}"
mkswap             -L ARCHSWAP "${DISKSWAPDEVPATH}"

mount  "${DISKROOTDEVPATH}" /mnt
mkdir  /mnt/{boot,home}
mount  "${DISKBOOTDEVPATH}" /mnt/boot
mount  "${DISKHOMEDEVPATH}" /mnt/home
swapon "${DISKSWAPDEVPATH}"

#mkdir /mnt/mnt
#mkdir /mnt/mnt/data1
#mount /dev/sdc1 /mnt/mnt/data1
#mkdir /mnt/mnt/data2
#mount /dev/sdd1 /mnt/mnt/data2

#mkdir /mnt/mnt/datafast
#mount /dev/sda1 /mnt/mnt/datafast
