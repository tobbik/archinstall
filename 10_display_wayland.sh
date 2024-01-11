source config.sh

PKGSDIR="/home/${USERNAME}/pkgs"
OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"
sudo --user ${USERNAME} mkdir -p ${PKGSDIR}
cd ${PKGSDIR}


# everything Xorg and Terminals and command line
pacman -S --needed --noconfirm \
  wayland greetd wl-clipboard dunst mako jq \
  wf-recorder wayvnc grim slurp \
  swaylock swayidle polkit-gnome \
  fuzzel bemenu-wayland \
  foot foot-terminfo \
  mpv \
  xorg-xwayland wlroots seatd \
  meson scdoc \
  awesome-terminal-fonts ttf-font-awesome


systemctl enable greetd.service

PACKAGES=(
  greetd-wlgreet
  labwc
  labwc-menu-generator-git
  labwc-tweaks-git
  sfwbar
  yambar
  wlsunset
  wlr-randr
  wlopm
)

# needed to build yambar
sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 5BBD4992C116573F
# needed for wlr-randr
sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 0FDE7BE0E88F5E48

for PKG in ${PACKAGES[@]}; do
  echo "Creating ${PKG}"
  cd ${PKGSDIR}
  curl ${BASEURL}/${PKG}.tar.gz --output - | tar xz
  chown -R ${USERNAME}:users ${PKG}
  cd ${PKGSDIR}/${PKG}
  sudo --user ${USERNAME} makepkg
  pacman -U --needed --noconfirm ${PKG}-*.pkg.tar.zst
  rm -rf src pkg
done

cd ${OLDDIR}

# use the labwc compositor for wlgreet
sed \
  -e 's:^command.*:command = "labwc --config-dir /etc/greetd/labwc:' \
  -e "s:^user.*:user = ${USERNAME}:" \
  -i /etc/greetd/config.toml

# set up a kiosk style labwc compositor for use with wlgreet
mkdir -p /etc/greetd/labwc
echo -e "wlgreet --command labwc\n\nexit\n" > /etc/greetd/labwc/autostart
echo -e "XCURSOR_THEME=Adwaita\nXCURSOR_SIZE=24\nXKB_DEFAULT_LAYOUT=us\n" > /etc/greetd/labwc/environment
echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<openbox_menu>\n <menu id=\"root-menu\" label=\"root-menu\"> </menu>\n</openbox_menu>" > /etc/greetd/labwc/menu.xml
echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<labwc_config>\n</labwc_config>" > /etc/greetd/labwc/rc.xml
