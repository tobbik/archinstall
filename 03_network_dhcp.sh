pacman -S --needed --noconfirm dhcpcd

systemctl enable dhcpcd@${INTERFACE}.service
