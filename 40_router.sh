source config.sh
source helper.sh


# set up ethernet NIC to connect to switch
cat > /etc/systemd/network/ether.network << EONEWEITER
[Match]
Type=ether

[Network]
Address=${ROUTER_IPv4}
Address=${ROUTER_IPv6}
IgnoreCarrierLoss=5s

EONEWEITER

# allow kernel to forward packages
cat >  /etc/sysctl.d/30-ipforward.conf << EOSYSCTLFWD
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
net.ipv6.conf.all.forwarding = 1
EOSYSCTLFWD

# setup iptables to perform the routing
if pacman -Q iptables-nft > /dev/null 2>&1 > /dev/null; then
  # nftables based setup
  nft add table inet nat
  nft add chain inet nat postrouting '{ type nat hook postrouting priority srcnat ; }'
  nft add rule inet nat postrouting oifname ${ROUTER_IF_EXTERN} masquerade
  nft add rule inet filter forward ct state related,established accept
  nft add rule inet filter forward iifname ${ROUTER_IF_INTERN} oifname ${ROUTER_IF_EXTERN} accept
else
  # iptables based setup
  iptables -t nat -A POSTROUTING -o ${ROUTER_IF_EXTERN} -j MASQUERADE
  iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  iptables -A FORWARD -i ${ROUTER_IF_INTERN} -o ${ROUTER_IF_EXTERN} -j ACCEPT


# setup dnsmasq as DHCP/DNS server for the everything connected to ${ROUTER_IF_INTERN}
pacman -S openresolv --needed --noconfirm ${PACMANEXTRAFLAGS} dnsmasq
cat > /etc/dnsmasq.conf << "EODNSMASQCONF"
# make dnsmasq listen for requests only on intern0 (our LAN)
interface=${ROUTER_IF_INTERN}
# optionally disable the DHCP functionality of dnsmasq and use systemd-networkd instead
#no-dhcp-interface=${ROUTER_IF_INTERN}

# add a domain to simple hostnames in /etc/hosts
expand-hosts
# allow fully qualified domain names for DHCP hosts (needed when "expand-hosts" is used)
local=/home.arpa/
domain=home.arpa

# defines a DHCP-range for the LAN:
# from 10.0.0.2 to .255 with a subnet mask of 255.255.255.0 and a
# DHCP lease of 1 hour (change to your own preferences)
dhcp-range=${ROUTER_IPv4_RANGE}

conf-file=/etc/dnsmasq-conf.conf
resolv-file=/etc/dnsmasq-resolv.conf
EODNSMASQCONF

# allow for DHCP packages to flow
iptables -I INPUT -p udp --dport 67 -i ${ROUTER_IF_INTERN} -j ACCEPT
iptables -I INPUT -p udp --dport 53 -s ${ROUTER_IPv4} -j ACCEPT
iptables -I INPUT -p tcp --dport 53 -s ${ROUTER_IPv4} -j ACCEPT

# disable and remove systemd-resolvconf and install openresolv

systemctl disable sytemd-resolved
yes | pacman -S openresolv --needed ${PACMANEXTRAFLAGS}   # prompts for conflicting systemd-resolvconf removal

# this redirects DNS requests to localhost where dnsmasq is running which will answer those requests
cat > /etc/resolvconf.conf << EORESOLVCONDCONF
# If you run a local name server, you should uncomment the below line and
# configure your subscribers configuration files below.
# Use the local name server
name_servers="::1 127.0.0.1"
resolv_conf_options="trust-ad"

# Write out dnsmasq extended configuration and resolv files
dnsmasq_conf=/etc/dnsmasq-conf.conf
dnsmasq_resolv=/etc/dnsmasq-resolv.conf
EORESOLVCONDCONF

systemctl enable dnsmasq.service

# since the external interface here is assumingly wlan0 which is (as per 01_network.sh) configured by iwd
# let iwd tell openresolf about the DNS Server it has picked up from it's external requests
sed -i /etc/iwd/main.conf \
    -e "s/^\(NameResolvingService\)=.*$/\1=resolvconf"

