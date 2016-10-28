pacman -S --needed --noconfirm dhcpcd
INTERFACE=$(ip link | grep 'state UP' | cut -d " " -f2 | tr -d ":\n" | sed "s/..//")

systemctl enable dhcpcd@${INTERFACE}.service
