source config.sh

if pacman -Q openresolv ; then
  pacman -Rdd openresolv
fi

pacman -S --needed --noconfirm \
  iwd systemd-resolvconf wireless-regdb

if test x${NETWORK_TYPE} = x"WLAN" || test x${NETWORK_TYPE} = x"BOTH"; then
  NW_TYPE=wlan NW_IGN_CARR_LOSS=5s NW_ROUTEMETRIC=600 envsubst \
    < template.network \
    > "/etc/systemd/network/wlan.network"
fi

if test x${NETWORK_TYPE} = x"ETHER" || test x${NETWORK_TYPE} = x"BOTH"; then
  NW_TYPE=ether NW_IGN_CARR_LOSS=5s NW_ROUTEMETRIC=100 envsubst \
    < template.network  \
    > "/etc/systemd/network/ether.network"
fi

mkdir /etc/iwd && cat > /etc/iwd/main.conf << EOIWDCONF
[General]
EnableNetworkConfiguration=True

[Network]
EnableIPv6=True
NameResolvingService=systemd
EOIWDCONF

if [ ! -L /etc/resolv.conf ]; then
  rm -f /etc/resolv.conf
  ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
fi

systemctl enable iwd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

