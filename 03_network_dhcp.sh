pacman -S --needed --noconfirm dhcpcd
INTERFACE=$(ip link | cut -d " " -f2 | tr -d ":\n" | sed "s/..//")

systemctl enable dhcpcd@${INTERFACE}.service
