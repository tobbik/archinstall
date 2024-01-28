source config.sh

cat >> "/etc/systemd/network/25-wireless.network" << EONETCFG
[Match]
Type=wlan

[Network]
DHCP=yes
IgnoreCarrierLoss=3s
DNSSEC=no

[DHCPv4]
UseDomains=true

[IPv6AcceptRA]
UseDomains=yes

EONETCFG

systemctl enable iwd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
