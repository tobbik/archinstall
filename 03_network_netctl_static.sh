pacman -S --needed --noconfirm netctl
DEVNAME=$(ip link | cut -d " " -f2 | tr -d ":\n" | sed "s/..//")

cat > /etc/netctl/${DEVNAME}_dhcp << EONETCTL
Description='A basic dhcp ethernet connection'
Interface=${DEVNAME}
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

netctl enable ${DEVNAME}_dhcp
