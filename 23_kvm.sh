source config.sh
source helper.sh

pacman -S --needed --noconfirm \
  qemu-base virt-manager qemu-guest-agent \
  virt-viewer libvirt \
  dnsmasq qemu-desktop qemu-tools

if [ $(uname -m) = 'x86_64' ]; then
  # libgestfs forces vim back into the fold
  pacman -S --needed --noconfirm \
    virtualbox libguestfs edk2-ovmf
fi

enable_service libvirtd

# wait until it shows up in /etc/group
sleep 3
usermod -a -G kvm,libvirt,libvirt-qemu ${USERNAME}
