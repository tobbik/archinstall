pacman -S --needed --noconfirm netctl dhcpcd
INTERFACE=$(ip link | grep 'state UP' | cut -d " " -f2 | tr -d ":\n" | sed "s/://")

systemctl enable netctl-auto@{$INTERFACE}.service
