source config.sh

# set up Hostname
echo $HOSTNAME > /etc/hostname

# set up locale stuff, keyboard, time etc
cat > /etc/locale.conf << EOLOCALE
LANG=${LOCALELC}
LC_TIME="${LOCALELC}"
LC_COLLATE="C"
EOLOCALE

# DON'T do that on RaspberryPi or other SoC deivces
if [ ! -f /boot/boot.src ]; then
  # set the timezone and make sure system uses UTC
  ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
  hwclock --systohc --utc
fi

# set up avalaible system locales
sed -e 's/^#\(en_CA.UTF-8 UTF-8\)/\1/' \
    -e 's/^#\(fr_CA.UTF-8 UTF-8\)/\1/' \
    -e 's/^#\(de_DE.UTF-8 UTF-8\)/\1/' \
    -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/' -i /etc/locale.gen
locale-gen

