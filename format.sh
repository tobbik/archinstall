source config.sh

mkfs.vfat       -F32 -n XBOOTLDR "${DISKBOOTDEVPATH}"
yes | mkfs.ext4      -L ARCHROOT "${DISKROOTDEVPATH}"
yes | mkfs.ext4      -L ARCHHOME "${DISKHOMEDEVPATH}"
mkswap               -L ARCHSWAP "${DISKSWAPDEVPATH}"
