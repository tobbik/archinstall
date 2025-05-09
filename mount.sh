source config.sh

mount  "${DISKROOTDEVPATH}" /mnt
mkdir  /mnt/{boot,home}
if [ x"${BOOTMNGR}" == x"xbootldr" ]; then
  mkdir  /mnt/efi
  mount  "${DISKESPDEVPATH}" /mnt/efi
fi
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
