source config.sh

# set up Hostname
if [ ! -f /etc/hostname ]; then
  echo ${HOSTNAME} > /etc/hostname
fi

# set up locale stuff, keyboard, time etc
# set up avalaible system locales
sed -i /etc/locale.gen \
  -e 's/^#\(en_CA.UTF-8 UTF-8\)/\1/' \
  -e 's/^#\(fr_CA.UTF-8 UTF-8\)/\1/' \
  -e 's/^#\(de_DE.UTF-8 UTF-8\)/\1/' \
  -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/'
if ! grep -q 'C.UTF8 UTF-8' /etc/locale.gen; then
  echo -e "C.UTF-8 UTF-8" >> /etc/locale.gen
fi
locale-gen

# set main locale settings for this machine
cat > /etc/locale.conf << EOLOCALE
LANG=${LOCALELC}
LANGUAGE=${LOCALEFALLBACK}
LC_TIME=${LOCALELC}
LC_COLLATE=${LOCALECOLLATE}
EOLOCALE

# DON'T do that on RaspberryPi or other SoC deivces
if ! test -f /boot/config.txt && ! test -L /etc/localtime ; then
  # set the timezone and make sure system uses UTC
  ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
  hwclock --systohc --utc
fi

# -----------------------------------------------------
# SETTING UP THE MAIN USER
# -----------------------------------------------------

if ! grep -q ${USERNAME} /etc/passwd ; then
  useradd --gid users \
    --create-home \
    --skel /etc/skel \
    --password ${USERPASS} \
    --shell /bin/bash \
    ${USERNAME}
fi
mkdir -p /home${USERNAME}/{.config,.local,.cache}

# reset the password to be sure
echo -e "${USERPASS}\n${USERPASS}" | (passwd -q ${USERNAME})

# Add useful groups for main user
usermod -a -G wheel,network,input,video,audio,storage,power,users ${USERNAME}

# reset root password
echo -e "${ROOTPASS}\n${ROOTPASS}" | (passwd -q root)

# set up .bashrc with some aliases
if ! grep -q 'alias ls=' /home/${USERNAME}/.bashrc ; then
  echo "alias ls='ls --color=auto'"         >> /home/${USERNAME}/.bashrc
fi
if ! grep -q 'alias ll=' /home/${USERNAME}/.bashrc ; then
  echo "alias ll='ls --color=auto -l'"         >> /home/${USERNAME}/.bashrc
fi
if ! grep -q 'alias lla=' /home/${USERNAME}/.bashrc ; then
  echo "alias lla='ls --color=auto -l -a'"         >> /home/${USERNAME}/.bashrc
fi

chown -R ${USERNAME}:users /home/${USERNAME}

