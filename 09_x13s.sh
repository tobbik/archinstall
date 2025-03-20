source config.sh
source build_aur_pkg.sh

pacman -S ${PACMANFLAGS} \
  xmlto docbook-xsl inetutils uboot-tools vboot-utils dtc rmtfs

cat >> /etc/pacman.conf << EOF

# remove after installing your own kernel!!!
[x13s]
Server = https://lecs.dev/repo
EOF

curl        -O https://lecs.dev/repo/public.asc
pacman-key  --add public.asc
pacman-key  --lsign 9FD0B48BBBD974B80A3310AB6462EE0B8E382F3F

pacman -Sy
pacman -Rdd --noconfirm linux-firmware linux-aarch64
pacman -S   ${PACMANFLAGS} x13s-firmware linux-x13s linux-x13s-headers

# .. used on the Thinkpad X13s
AUR_PACKAGES=(
  qmic-git
  qrtr-git
  pd-mapper-git
)

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done
