source config.sh
source helper.sh

if ! grep -Pzoq "CacheServer.*\nInclude.*mirrorlist" /etc/pacman.conf && [[ ! -z ${PACOLOCOCACHESERVER} ]]; then
  sed -E "/(options)/! s|^\[.*\]$|\0\nCacheServer = ${PACOLOCOCACHESERVER}|" \
      -i /etc/pacman.conf
fi

# these re-locations are useful, if you like to set-up an RO-mounted root (/) directory
if [[ ! -z ${PACMANSERVICEDIR} ]]; then
  echo "moving pacman service files to ${PACMANSERVICEDIR}"
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
  pacman -U   --needed --noconfirm ${RUNDIR}/packages/*.pkg.tar.*
  rm -f ${RUNDIR}/*.pkg.tar.*
fi

pacman -Su --noconfirm ${PACMANEXTRAFLAGS}

