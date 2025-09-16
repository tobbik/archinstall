source config.sh

mount  PARTLABEL=ARCHROOT /mnt
if [ x"${BOOTMNGR}" == x"xbootldr" ]; then
  mkdir  /mnt/efi
  mount  "${DISKESPDEVPATH}" /mnt/efi
fi
mkdir  /mnt/{boot,home}
mount  PARTLABEL=ARCHBOOT /mnt/boot
mount  PARTLABEL=ARCHHOME /mnt/home
swapon -L ARCHSWAP

#mkdir /mnt/mnt
#mkdir /mnt/mnt/{storage1,storage2,data,datafast,ext001}
#mount -L storage1 /mnt/mnt/storage1 # sdc, WD red 2TB
#mount -L storage2 /mnt/mnt/storage2 # sdd, WD red 2TB
#mount -L data     /mnt/mnt/data     # sdb, Seagate 2TB
#mount -L datafast /mnt/mnt/datafast # sda, SSD, Seagate Barracuda 2TB
#mount -L 001T7    /mnt/mnt/ext001   # sde, SSD, Samsung T7
