source config.sh

pacman -S --needed --noconfirm netctl dhcpcd

# configure dhcpcd to report hostname to dns server
sed -i "s:#\(hostname\):\1:" /etc/dhcpcd.conf
sed -i "s:#\(clientid\):\1:" /etc/dhcpcd.conf
sed -i "s:duid:#\0:" /etc/dhcpcd.conf

cat > /etc/netctl/${INTERFACE}_dhcp << EONETCTL
Description='A basic dhcp ethernet connection'
Interface=${INTERFACE}
Connection=ethernet
IP=dhcp
#DHCPClient=dhcpcd
#DHCPReleaseOnStop=no
## for DHCPv6
#IP6=dhcp
#DHCP6Client=dhclient
## for IPv6 autoconfiguration
#IP6=stateless
EONETCTL

netctl enable ${INTERFACE}_dhcp
