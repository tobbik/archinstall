source config.sh
source helper.sh

pacman -S --needed -noconfirm ${PACMANEXTRAFLAGS} pacoloco

mv /etc/pacoloco.yaml /etc/pacoloco-orig.yaml

cat >> /etc/pacoloco.yaml << EOPACOLOCOYAML
cache_dir: ${PACOLOCODATADIR}
port: 9129
download_timeout: 3600 ## downloads will timeout if not completed after 3600 sec, 0 to disable timeout
purge_files_after: 2592000 ## purge file after 30 days
# set_timestamp_to_logs: true ## uncomment to add timestamp, useful if pacoloco is being ran through docker

repos:
  archlinux:
    urls: ## add or change official mirror urls as desired, see https://archlinux.org/mirrors/status/
      - https://america.mirror.pkgbuild.com
      - http://mirrors.kernel.org/archlinux
  archlinux_aarch64:
    url: http://us.ca.mirror.archlinuxarm.org
EOPACOLOCOYAML
