pacman -S --needed --noconfirm netctl dhcpcd

# configure dhcpcd to report hostname to dns server
sed -i "s:#\(hostname\):\1:" /etc/dhcpcd.conf
sed -i "s:#\(clientid\):\1:" /etc/dhcpcd.conf
sed -i "s:duid:#\0:" /etc/dhcpcd.conf

systemctl enable netctl-auto@{$INTERFACE}.service
