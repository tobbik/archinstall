source config.sh

pacman -Rdd --noconfirm linux-aarch64 uboot-raspberrypi

pacman -S ${PACMANFLAGS} \
  linux-rpi linux-rpi-headers

# this moves things back to the RaspberryPi way instead of the generic
# archlinuxarm installation
if ! grep -q 'over_voltage' /boot/config.txt ; then
  cat >> /boot/config.txt << EOBOOTCFG
gpu_mem=64
arm_freq=1900
over_voltage=4
gpu_freq=600
dtoverlay=disable-wifi
dtoverlay=disable-bt
EOBOOTCFG
fi

sed -i 's: rw : ro :' /boot/cmdline.txt
if ! grep -q 'cgroup_' /boot/cmdline.txt ; then
  sed \
    -e 's:^\(root.*\)$:\1 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1 :' \
    -i /boot/cmdline.txt
fi

sed -e 's/mmcblk1/mmcblk0/g' -i /etc/fstab

