source config.sh
source helper.sh

if pacman -Q openresolv ; then
  pacman -Rdd openresolv
fi

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  iwd systemd-resolvconf wireless-regdb

if test x${NETWORKTYPE} = x"ether" || test x${NETWORKTYPE} = x"both"; then
  if [ ! -f /etc/systemd/network/ether.network ]; then
    NW_TYPE=ether NW_IGN_CARR_LOSS=5s NW_ROUTEMETRIC=100 envsubst \
      < template.network  \
      > "/etc/systemd/network/ether.network"
  fi
fi

if test x${NETWORKTYPE} = x"wlan" || test x${NETWORKTYPE} = x"both"; then
  if [ ! -f /etc/systemd/network/wlan.network ]; then
    NW_TYPE=wlan NW_IGN_CARR_LOSS=5s NW_ROUTEMETRIC=600 envsubst \
      < template.network \
      > "/etc/systemd/network/wlan.network"
  fi
fi

if [ ! -f /etc/iwd/main.conf ]; then
  [ ! -d /etc/iwd ] && mkdir /etc/iwd
  cat > /etc/iwd/main.conf << EOIWDCONF
[General]
EnableNetworkConfiguration=True

[Network]
EnableIPv6=True
NameResolvingService=systemd
EOIWDCONF
fi

if [ ! -L /etc/resolv.conf ]; then
  rm -f /etc/resolv.conf
  ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
fi

enable_service iwd
enable_service systemd-networkd
enable_service systemd-resolved

