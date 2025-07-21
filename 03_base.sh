source config.sh
source helper.sh

if [ x$(uname -m) == x"aarch64" ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    archlinuxarm-keyring mkinitcpio
fi
if [ x$(uname -m) == x"x86_64" ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    archlinux-keyring mkinitcpio vbetool
fi

# packers, helpers, sound etc ...
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wpa_supplicant wireless_tools net-tools openssh \
  dosfstools exfatprogs e2fsprogs ntfs-3g btrfs-progs \
  smartmontools nfs-utils cifs-utils gptfdisk \
  rsync whois nmap wget curl traceroute iperf \
  htop btop bmon iotop-c powertop libcap sysstat \
  zip unzip unrar 7zip man-pages man-db lsof pv \
  cpupower acpi tlp acpi_call upower \
  wol dmidecode rng-tools mc fbset \
  pwgen mlocate sudo tmux fakeroot \
  efibootmgr efivar \
  pacman-contrib arch-install-scripts \
  neovim

enable_service sshd
enable_service systemd-timesyncd
enable_service tlp
usermod -a -G locate ${USERNAME}

echo "Setup hardware random number generator"
sed -i 's:^.*\(RNGD_OPTS=\).*:\1"-o /dev/random -r /dev/hwrng":' /etc/conf.d/rngd
enable_service rngd

# don't have makepkg build *-debug packages by default
sed -i /etc/makepkg.conf \
  -e "s|purge debug lto|purge !debug lto|" \
  -e 's|^.*MAKEFLAGS.*$|MAKEFLAGS="--jobs=$(nproc)"|'

add_export "SSH_AUTH_SOCK" '${XDG_RUNTIME_DIR}/ssh-agent.socket'
enable_service ssh-agent.service ${USERNAME}

if [ ! -f /etc/sudoers.d/${USERNAME} ]; then
  # user sudo access
  echo "${USERNAME} ALL=(ALL:ALL) ALL" > /etc/sudoers.d/${USERNAME}
fi

add_alias "s"      "sudo"
add_alias "g"      "grep --color=auto"

add_alias "v"      "nvim"
add_alias "nv"     "nvim"
add_alias "nvd"    "nvim -d"
add_alias "nvdiff" "nvim -d"

add_dotfiles ".config/nvim" ".vim" ".vimrc"

setcap 'cap_net_admin+eip' /usr/bin/iotop
