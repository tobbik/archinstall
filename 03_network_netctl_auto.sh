pacman -S --needed --noconfirm netctl dhcpcd

systemctl enable netctl-auto@{$INTERFACE}.service
