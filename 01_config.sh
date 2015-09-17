# set up Hostname
echo $HOSTNAME > /etc/hostname

# set up locale stuff, keyboard, time etc
cat > /etc/locale.conf << EOLOCALE
LANG=${LOCALELC}
LC_TIME="${LOCALELC}"
LC_COLLATE="C"
EOLOCALE

# set the timezone and make sure system uses UTC
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc --utc

# set up avalaible system locales
sed -i 's/^#\(en_CA.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

