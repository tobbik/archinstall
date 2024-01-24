source config.sh

pacman -S --needed --noconfirm \
  qemu-base virt-manager qemu-guest-agent \
  virt-viewer libvirt \
  dnsmasq qemu-desktop qemu-tools

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --needed --noconfirm \
    virtualbox libguestfs edk2-ovmf
fi

systemctl enable libvirtd
usermod -a -G kvm ${USERNAME}
usermod -a -G libvirt ${USERNAME}
