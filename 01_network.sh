source config.sh
source helper.sh

if pacman -Q openresolv > /dev/null 2>&1; then
  pacman -Rdd openresolv
fi

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  iwd systemd-resolvconf wireless-regdb

if [ ! -f /etc/iwd/main.conf ]; then
  [ ! -d /etc/iwd ] && mkdir /etc/iwd
  cat > /etc/iwd/main.conf << EOIWDCONF
[General]
ControlPortOverNL80211=${ControlPortOverNL80211}
EnableNetworkConfiguration=True

[Network]
EnableIPv6=True
NameResolvingService=systemd
EOIWDCONF
fi

if test x${NETWORKTYPE} = x"ether" || test x${NETWORKTYPE} = x"both"; then
  if [[ -z ${ETHER_INTERFACE} ]]; then
    ETHER_INTERFACE=$(ip addr show dynamic | grep ': e[^ ]*: <' | cut -d' ' -f2 | tr -d ':')
  fi
  echo "configuring wired ethernet interface <${ETHER_INTERFACE}> for systemd-networkd"
  if [ ! -f /etc/systemd/network/${ETHER_INTERFACE}.network ]; then
    ./gen_nw.sh ${ETHER_INTERFACE}
  fi
fi

if test x${NETWORKTYPE} = x"wlan" || test x${NETWORKTYPE} = x"both"; then
  if [[ -z ${WLAN_INTERFACE} ]]; then
    WLAN_INTERFACE=$(ip addr show dynamic | grep ': w[^ ]*: <' | cut -d' ' -f2 | tr -d ':')
  fi
  echo "configuring wireless interface <${WLAN_INTERFACE}> for systemd-networkd"
  if [ ! -f /etc/systemd/network/${WLAN_INTERFACE}.network ]; then
    ./gen_nw.sh ${WLAN_INTERFACE}
  fi
  enable_service iwd.service
fi

if [ ! -L /etc/resolv.conf ]; then
  rm -f /etc/resolv.conf
  ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
fi

enable_service systemd-networkd.service systemd-resolved.service

