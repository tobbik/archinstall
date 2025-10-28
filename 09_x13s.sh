source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  linux-firmware linux-firmware-qcom \
  xmlto docbook-xsl inetutils uboot-tools vboot-utils dtc rmtfs qrtr-git

# ... used on the Thinkpad X13s
AUR_PACKAGES=(
  qmic-git
  pd-mapper-git
)

install_aur_packages "${AUR_PACKAGES[@]}"
