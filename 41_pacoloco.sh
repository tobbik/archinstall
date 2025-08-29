source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} pacoloco

echo "Backup original pacoloco.yaml config file"
cp -v /etc/pacoloco.yaml /etc/pacoloco-orig.yaml

if [[ ! -z ${PACOLOCODATADIR} ]]; then
  echo "Define ${PACOLOCODATADIR} as cache directory and add US mirror"
  sed -i /etc/pacoloco.yaml \
      -e "s|^.*cache_dir.*$|cache_dir: ${PACOLOCODATADIR}|" \
      -e "s|http.*lty.*|https://america.mirror.pkgbuild.com|"
fi

enable_service pacoloco.service
