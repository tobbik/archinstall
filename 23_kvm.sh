source config.sh
source helper.sh

EXTRAPACKAGES=""

if [ $(uname -m) = 'x86_64' ]; then
  # libgestfs forces vim back into the fold
  EXTRAPACKAGES="virtualbox libguestfs edk2-ovmf"
fi

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  qemu-base virt-manager qemu-guest-agent \
  virt-viewer libvirt \
  dnsmasq qemu-desktop qemu-tools \
  ${EXTRAPACKAGES}

enable_service libvirtd.service

# wait until it shows up in /etc/group
sleep 3
usermod -a -G kvm,libvirt,libvirt-qemu ${USERNAME}
