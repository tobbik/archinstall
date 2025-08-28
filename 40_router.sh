source config.sh
source helper.sh

if [ x"${ROUTER_DNS}" == x"openresolv" ]; then
  # install dnsmasq and openresolv (which conflicts with systemd-resolvconf)
  systemctl disable --now systemd-resolved.service
  rm /etc/resolv.conf
  yes | pacman -S --needed ${PACMANEXTRAFLAGS} openresolv dnsmasq   # prompts for systemd-resolvconf removal

  # since the external interface here is assumingly wlan0 which is (as per 01_network.sh) configured
  # by iwd let iwd tell openresolv about the DNS Server it has picked up from it's external requests
  sed -i /etc/iwd/main.conf \
      -e "s/^\(NameResolvingService\)=.*$/\1=resolvconf/"

  # this redirects DNS requests to localhost where dnsmasq is running which will answer those requests
cat > /etc/resolvconf.conf << EORESOLVCONDCONF
# If you run a local name server, you should uncomment the below line and
# configure your subscribers configuration files below.
# Use the local name server
name_servers="::1 127.0.0.1"
resolv_conf_options="trust-ad"

# Write out dnsmasq extended configuration and resolv files
dnsmasq_conf=/home/dnsmasq/dnsmasq-conf.conf
dnsmasq_resolv=/home/dnsmasq/dnsmasq-resolv.conf
EORESOLVCONDCONF

  LOCAL_DNSMASQ_FILE_CONFIG="conf-file=/home/dnsmasq/dnsmasq-conf.conf"
  LOCAL_RESOLVE_FILE_CONFIG="resolv-file=/home/dnsmasq/dnsmasq-resolv.conf"

  resolvconf -u
fi

if [ x"${ROUTER_DNS}" == x"systemd-resolved" ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} dnsmasq
  LOCAL_DNSMASQ_FILE_CONFIG=
  LOCAL_RESOLVE_FILE_CONFIG="resolv-file=/run/systemd/resolve/resolv.conf"

  sed -i /etc/systemd/resolved.conf \
      -e "s/^.*#.*DNSStubListener.*=.*$/DNSStubListener=no/"
fi

# setup dnsmasq as DHCP/DNS server for the everything connected to ${ROUTER_IF_INTERN}
cat > /etc/dnsmasq.conf << EODNSMASQCONF
# relocate that for RO file-systems
dhcp-leasefile=/home/dnsmasq/dnsmasq.leases
# make dnsmasq listen for requests only on intern0 (our LAN)
interface=${ROUTER_IF_INTERN}
# optionally disable the DHCP functionality of dnsmasq and use systemd-networkd instead
#no-dhcp-interface=${ROUTER_IF_INTERN}

# add a domain to simple hostnames in /etc/hosts
expand-hosts
# allow fully qualified domain names for DHCP hosts (needed when "expand-hosts" is used)
local=/${ROUTER_DOMAIN}/
domain=${ROUTER_DOMAIN}

# defines a DHCP-range for the LAN:
# from 10.0.0.2 to .255 with a subnet mask of 255.255.255.0 and a
# DHCP lease of 1 hour (change to your own preferences)
dhcp-range=${ROUTER_IPv4_RANGE}

${LOCAL_DNSMASQ_FILE_CONFIG}
${LOCAL_RESOLVE_FILE_CONFIG}
EODNSMASQCONF

mkdir -p /home/dnsmasq && chown dnsmasq:dnsmasq /home/dnsmasq

# set up ethernet NIC to connect to switch (which connects cluster clients)
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
if pacman -Q iptables-nft > /dev/null 2>&1; then
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
  # allow for DHCP packages to flow
  iptables -I INPUT -p udp --dport 67 -i ${ROUTER_IF_INTERN} -j ACCEPT
  iptables -I INPUT -p udp --dport 53 -s ${ROUTER_IPv4} -j ACCEPT
  iptables -I INPUT -p tcp --dport 53 -s ${ROUTER_IPv4} -j ACCEPT

  # save these iptables.rules
  iptables-save -f /etc/iptables/iptables.rules

  enable_service iptables.service
fi

enable_service dnsmasq.service

