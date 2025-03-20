source config.sh
source helper.sh

if [ x$(uname -m) == x"aarch64" ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    archlinuxarm-keyring mkinitcpio
fi
if [ x$(uname -m) == x"x86_64" ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    archlinux-keyring mkinitcpio vbetool 7zip
fi

if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  AUDIOPACKAGES="pipewire wireplumber pipewire-audio \
  pipewire-alsa pipewire-pulse pipewire-jack \
  helvum"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  AUDIOPACKAGES="pulseaudio pulseaudio-alsa \
    pulseaudio-bluetooth pulseaudio-jack"
fi

# packers, helpers, sound etc ...
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wpa_supplicant wireless_tools net-tools openssh \
  dosfstools exfatprogs e2fsprogs ntfs-3g \
  rsync whois nmap wget curl traceroute iperf \
  htop btop bmon iotop-c powertop \
  zip unzip unrar man-pages man-db lsof \
  cpupower acpi tlp acpi_call \
  smartmontools nfs-utils cifs-utils \
  wol dmidecode rng-tools mc \
  pwgen mlocate linux-firmware \
  sudo tmux fakeroot \
  efibootmgr efivar pacman-contrib \
  ${AUDIOPACKAGES} mpd mpd yt-dlp aria2 atomicparsley python-mutagen \
  alsa-tools alsa-utils alsa-plugins pamixer \
  python-pycryptodome python-pycryptodomex \
  python-websockets python-brotli python-brotlicffi \
  python-xattr python-pyxattr python-secretstorage

enable_service sshd
enable_service systemd-timesyncd
usermod -a -G locate ${USERNAME}

echo "Setup hardware random number generator"
sed -i 's:^.*\(RNGD_OPTS=\).*:\1"-o /dev/random -r /dev/hwrng":' /etc/conf.d/rngd
enable_service rngd

# fix a slightly overzealous preset
sed -i /etc/makepkg.conf \
  -e "s:purge debug lto:purge !debug lto:"

add_export "SSH_AUTH_SOCK" '${XDG_RUNTIME_DIR}/ssh-agent.socket'
enable_service ssh-agent.service ${USERNAME}

if [ ! -f /etc/sudoers.d/${USERNAME} ]; then
  # user sudo access
  echo "${USERNAME} ALL=(ALL:ALL) ALL" > /etc/sudoers.d/${USERNAME}
fi

add_alias "s" "sudo"

add_dotfiles ".config/mpd"
mkdir -p /home/${USERNAME}/.config/mpd/playlists

# setup user audio base configs
if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  cp -avr /usr/share/pipewire /home/${USERNAME}/.config/
  enable_service pipewire-pulse.service ${USERNAME}
  enable_service wireplumber.service ${USERNAME}
  sed -i /home/${USERNAME}/.config/mpd/mpd.conf \
      -e "s:^# pipewire$:\0\naudio_output {\n  type    \"pipewire\"\n  name    \"PipeWire Sound Server\"\n}\n:"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  cp -avr /etc/pulse /home/${USERNAME}/.config/
fi

enable_service mpd.service ${USERNAME}
