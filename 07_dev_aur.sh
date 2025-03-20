source config.sh
source build_aur_pkg.sh

PACKAGES=(
  wrk
)

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done


