source config.sh
source build_aur_pkg.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  xmlto docbook-xsl inetutils uboot-tools vboot-utils dtc rmtfs qrtr-git

# ... used on the Thinkpad X13s
AUR_PACKAGES=(
  qmic-git
  pd-mapper-git
)

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done
