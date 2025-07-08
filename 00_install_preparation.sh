source config.sh
source helper.sh

if ! grep -q 'CacheServer' /etc/pacman.conf && [[ ! -z ${PACOLOCOCACHESERVER} ]]; then
  sed -i /etc/pacman.conf \
      -e "s|^Include.*/etc/pacman.d/mirrorlist$|CacheServer = ${PACOLOCOCACHESERVER}\n\0|"
fi

# these re-locations are useful, if you like to set-up an RO-mounted root (/) directory
if [[ ! -z ${PACMANSERVICEDIR} ]]; then
  echo "moving pacman service files to https://codeberg.org/mogwai/widevine.git"
  mkdir -p ${PACMANSERVICEDIR}/cache
  mv /var/log/pacman.log ${PACMANSERVICEDIR}/
  mv /etc/pacman.d/gnupg ${PACMANSERVICEDIR}/
  mv -v /var/cache/pacman/pkg/*  ${PACMANSERVICEDIR}/cache/
  sed -i /etc/pacman.conf \
      -e "s:^#\(CacheDir *\).*:\1 = ${PACMANSERVICEDIR}/cache:" \
      -e "s:^#\(LogFile *\).*:\1 = ${PACMANSERVICEDIR}/pacman.log:" \
      -e "s:^#\(GPGDir *\).*:\1 = ${PACMANSERVICEDIR}/gnupg:"
fi

pacman -Sy --noconfirm ${PACMANEXTRAFLAGS}

if [[ ! -z ${REMOVABLES} ]]; then
  pacman -Rdd --noconfirm ${REMOVABLES}
  pacman -U   --needed --noconfirm ${RUNDIR}/*.pkg.tar.*
  rm -f ${RUNDIR}/*.pkg.tar.*
fi

pacman -Su --noconfirm ${PACMANEXTRAFLAGS}

