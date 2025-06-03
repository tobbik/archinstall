source config.sh
source helper.sh

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
    --no-create-home \
    --password ${USERPASS} \
    --shell /bin/bash \
    ${USERNAME}
fi

[ -d ${USERHOME} ] || mkdir ${USERHOME}
for C_FILE in /etc/skel/.* /etc/skel/* ; do
  C_FILE_NAME=$(basename ${C_FILE})
  echo "Testing for file: ${USERHOME}/${C_FILE_NAME}"
  [ -f "${USERHOME}/${C_FILE_NAME}" ] || cp -v "/etc/skel/${C_FILE_NAME}" "${USERHOME}/${C_FILE_NAME}"
done

mkdir -p ${USERHOME}/{.config,.local/bin,.cache}
add_export "PATH" '${PATH}:${HOME}/.local/bin'

# reset the password to be sure
echo "${USERNAME}:${USERPASS}" | chpasswd

# Add useful groups for main user
usermod -a -G wheel,network,input,video,audio,storage,power,users ${USERNAME}

# reset root password
echo "root:${ROOTPASS}" | chpasswd

# set up .bashrc with some aliases
add_alias "ls"  "ls --color=auto"
add_alias "ll"  "ls --color=auto -l"
add_alias "la"  "ls --color=auto -a"
add_alias "lla" "ls --color=auto -l -a"

[ -d ${AURBUILDDIR} ] || mkdir -p ${AURBUILDDIR}
cp -avr ${RUNDIR}/pkgbuilds/* ${AURBUILDDIR}/

chown -R ${USERNAME}:users ${USERHOME}

