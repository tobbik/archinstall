source config.sh

OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"
sudo --user ${USERNAME} mkdir -p ${AURBUILDDIR}
cd ${AURBUILDDIR}

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
  glfw-wayland

# this depends heavily on having 07_dev_base.sh executed before hand
PACKAGES=(
  labwc
)

for PKG in ${PACKAGES[@]}; do
  echo "_______________################# Creating ${PKG} #######################"
  cd ${AURBUILDDIR}
  curl ${BASEURL}/${PKG}.tar.gz -O && sudo --user ${USERNAME} tar xzf ${PKG}.tar.gz
  rm ${PKG}.tar.gz && cd ${PKG}
  sed -i "s:^\(arch=.*\)):\1 'aarch64'):" PKGBUILD
  sudo --user ${USERNAME} makepkg
  pacman -U --needed --noconfirm ${PKG}-*$(uname -m).pkg.tar.*
  rm -rf src pkg
done

cd ${OLDDIR}

GREETER_CMD="tuigreet --time --issue --user-menu --user-menu-min-uid 1000 --remember --remember-user-session --asterisks --cmd labwc"

# use the labwc compositor for wlgreet
sed \
  -e "s:^command.*:command = \"${GREETER_CMD}\":" \
  -e "s:^user.*:user = ${USERNAME}:" \
  -i /etc/greetd/config.toml

systemctl enable greetd.service
sudo --user ${USERNAME} systemctl --user enable foot-server.service

