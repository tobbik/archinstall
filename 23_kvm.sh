source config.sh

pacman -S --needed --noconfirm \
 virtualbox qemu virt-manager qemu-guest-agent libguestfs \
 virt-viewer libvirt edk2-ovmf \
 dnsmasq qemu-desktop qemu-tools

systemctl enable libvirtd
usermod -a -G kvm ${USERNAME}
usermod -a -G libvirt ${USERNAME}