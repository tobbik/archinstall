source config.sh

pacman -S --needed --noconfirm dhcpcd

# configure dhcpcd to report hostname to dns server
sed -i "s:#\(hostname\):\1:" /etc/dhcpcd.conf
sed -i "s:#\(clientid\):\1:" /etc/dhcpcd.conf
sed -i "s:duid:#\0:" /etc/dhcpcd.conf

systemctl enable dhcpcd@${INTERFACE}.service
