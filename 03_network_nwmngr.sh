source config.sh

pacman -S --needed --noconfirm \
  networkmanager network-manager-applet nm-connection-editor

systemctl enable NetworkManager.service
systemctl enable systemd-resolved
