# set up Hostname
echo $HOSTNAME > /etc/hostname

# set up locale stuff, keyboard, time etc
localectl set-locale LANG=${LOCALELC}
locale > /etc/locale.conf

# set the keyboard layout
localectl set-keymap --no-convert ${KEYBOARD}

# set the timezone and make sure system uses UTC
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc --utc

# set up avalaible system locales
sed -i 's/^#\(en_CA.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

