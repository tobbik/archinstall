source config.sh
source helper.sh

OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"
sudo --user ${USERNAME} mkdir -p ${AURBUILDDIR}

# everything Xorg and Terminals and command line
pacman -S --needed --noconfirm \
  mesa libva-mesa-driver mesa-vdpau mesa-demos \
  wayland ly wl-clipboard dunst mako jq \
  wf-recorder wayvnc grim slurp \
  swaylock swayidle swaybg wlsunset \
  polkit-gnome brightnessctl kanshi \
  fuzzel bemenu-wayland \
  foot foot-terminfo \
  mpv libmpdclient pipewire-jack scdoc \
  xorg-xwayland wlroots wayland-protocols gtk-layer-shell

# this depends heavily on 07_dev_base.sh having been executed
handle_aur_pkg ${USERNAME} ${AURBUILDDIR} labwc

sed -i /etc/ly/config.ini \
  -e "s:.*save.*true.*:save = true:"

enable_service ly.service
enable_service foot-server.service, ${USERNAME}
enable_service ssh-agent.service, ${USERNAME}

