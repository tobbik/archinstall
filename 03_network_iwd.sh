source config.sh

pacman -S --needed --noconfirm \
  iwd systemd-resolvconf wireless-regdb

cat >> "/etc/systemd/network/wlan.network" << EONETCFG
[Match]
Type=wlan

[Network]
DHCP=yes
IgnoreCarrierLoss=3s
DNSSEC=false

[DHCPv4]
UseDomains=true
RouteMetric=600

[IPv6AcceptRA]
UseDomains=true
RouteMetric=600
EONETCFG

cat >> "/etc/systemd/network/ether.network" << EONETCFG
[Match]
Type=ether

[Network]
DHCP=yes
DNSSEC=false

[DHCPv4]
UseDomains=true
RouteMetric=100

[IPv6AcceptRA]
UseDomains=true
RouteMetric=100
EONETCFG

mkdir /etc/iwd  &&  cat > /etc/iwd/main.conf << EOIWDCONF
[General]
EnableNetworkConfiguration=True

[Network]
EnableIPv6=True
NameResolvingService=systemd
EOIWDCONF

rm -f /etc/resolv.conf
ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

systemctl enable iwd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

