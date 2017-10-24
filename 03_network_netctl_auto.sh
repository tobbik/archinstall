pacman -S --needed --noconfirm netctl dhcpcd
INTERFACE=$(ip link | grep 'state UP' | cut -d " " -f2 | tr -d ":\n" | sed "s/://")
ESSID=$(iwconfig | grep '${INTERFACE}' | cut -d '"' -f2)

cat > /etc/netctl/${INTERFACE}_${ESSID} << EONETCTL
Description='A dhcp wireless ethernet connection'
Interface=${INTERFACE}
Connection=wireless
IP=dhcp
#DHCPClient=dhcpcd
#DHCPReleaseOnStop=no
## for DHCPv6
#IP6=dhcp
#DHCP6Client=dhclient
## for IPv6 autoconfiguration
#IP6=stateless
Security=wpa
ESSID=${ESSID}
Key=${WL_KEY}
Priority=4
EONETCTL

systemctl enable netctl-auto@{$INTERFACE}.service
