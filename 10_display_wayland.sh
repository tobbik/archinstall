source config.sh
source helper.sh

OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"
sudo --user ${USERNAME} mkdir -p ${AURBUILDDIR}

# everything Xorg and Terminals and command line
pacman -S --needed --noconfirm \
  mesa libva-mesa-driver mesa-vdpau mesa-demos \
  wayland greetd greetd-tuigreet wl-clipboard dunst mako jq \
  wf-recorder wayvnc grim slurp \
  swaylock swayidle swaybg polkit-gnome brightnessctl kanshi \
  fuzzel bemenu-wayland wlsunset \
  foot foot-terminfo \
  mpv libmpdclient pipewire-jack scdoc \
  xorg-xwayland wlroots wayland-protocols gtk-layer-shell \
  glfw

# this depends heavily on 07_dev_base.sh having been executed
handle_aur_pkg ${USERNAME} ${AURBUILDDIR} labwc

cd ${OLDDIR}

GREETER_CMD="tuigreet --time --issue --user-menu --user-menu-min-uid 1000 --remember --remember-user-session --asterisks"

# use the labwc compositor for wlgreet
sed -i /etc/greetd/config.toml \
  -e "s:^command.*:command = \"${GREETER_CMD}\":" \
  -e "s:^user.*:user = ${USERNAME}:"

enable_service( greetd.service )
enable_service( foot-server.service, ${USERNAME} )
enable_service( ssh-agent.service, ${USERNAME} )

