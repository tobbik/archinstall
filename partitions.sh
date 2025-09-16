# this creates 4 partitions on ${DISKBASEDEVPATH}
# #1. is ESP    /boot   512MB
# #2. is ROOT   /       32GB             8304
# #3. is HOME   /home   444GB            8302
# #4. is SWAP   <swap>  remainder        8200
#
#        EFI   /efi     1GB              EA00

source config.sh

ENABLE_GPT=""

if [ x"$1" == x"wipe" ]; then
  # wipe entire disk
  gdisk ${DISKBASEDEVPATH} << EOGWIPE
x
z
Y
Y
EOGWIPE
  ENABLE_GPT="Y"
fi

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
ARCHBOOT
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
${ENABLE_GPT}
EOGDISK
