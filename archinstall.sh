#!/bin/bash

cd "$(dirname "$0")"

echo $$ > /tmp/archinstall.pid

source config.sh
source helper.sh

mkdir -p /root/installer/logs

INSTALLER_START_SECS=${SECONDS}

# these re-locations are useful, if you like to set-up an RO-mounted root (/) directory
if [[ ! -z ${PACMANSERVICEDIR} ]]; then
  mkdir -p ${PACMANSERVICEDIR}/cache
  mv /var/log/pacman.log ${PACMANSERVICEDIR}/
  mv /etc/pacman.d/gnupg ${PACMANSERVICEDIR}/
  mv /var/cache/pacman/pkg/*  ${PACMANSERVICEDIR}/cache/
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

# installing the individual modules
for moduleName in ${MODULES[@]}
do
  echo -e "\n\n      >>>>>>>>>>>   EXECUTING ${moduleName} <<<<<<<<<<<<\n"
  cd ${RUNDIR}
  run_module "${moduleName}" "/root/installer/logs"
done

# flatten all permissions
chown -R ${USERNAME}:users ${USERHOME}  /root/installer

cp -v ${USERHOME}/.bashrc /root/

INSTALLER_ELAPSED_SECS=$((${SECONDS} - ${INSTALLER_START_SECS}))
echo "INSTALLER Time Taken:  $(date -u -d @"${INSTALLER_ELAPSED_SECS}" +'%-Mm %Ss')" >> \
     /root/installer/logs/progress.log
