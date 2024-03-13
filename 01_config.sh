source config.sh

# set up Hostname
if [ ! -f /etc/hostname ]; then
  echo ${HOSTNAME} > /etc/hostname
fi


# set up locale stuff, keyboard, time etc
if [ ! -f /etc/locale.conf ]; then
  cat > /etc/locale.conf << EOLOCALE
LANG=${LOCALELC}
LC_TIME="${LOCALELC}"
LC_COLLATE="C"
EOLOCALE

  # set up avalaible system locales
  sed -i /etc/locale.gen \
    -e 's/^#\(C.UTF-8 UTF-8\)/\1/' \
    -e 's/^#\(en_CA.UTF-8 UTF-8\)/\1/' \
    -e 's/^#\(fr_CA.UTF-8 UTF-8\)/\1/' \
    -e 's/^#\(de_DE.UTF-8 UTF-8\)/\1/' \
    -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/'
  locale-gen
fi

# DON'T do that on RaspberryPi or other SoC deivces
if ! test -f /boot/config.txt && ! test -L /etc/localtime ; then
  # set the timezone and make sure system uses UTC
  ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
  hwclock --systohc --utc
fi


