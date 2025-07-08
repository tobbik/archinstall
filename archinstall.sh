#!/bin/bash

cd "$(dirname "$0")"

echo $$ > /tmp/archinstall.pid

source config.sh
source helper.sh

INSTALLER_START_SECS=${SECONDS}

run_module "00_install_preparation.sh" ${INSTALLER_START_SECS} "/root/installer/logs"

# installing the individual modules
for moduleName in ${MODULES[@]}
do
  echo -e "\n\n      >>>>>>>>>>>   EXECUTING ${moduleName} <<<<<<<<<<<<\n"
  cd ${RUNDIR}
  run_module "${moduleName}" ${INSTALLER_START_SECS} "/root/installer/logs"
done

# flatten all permissions
chown -R ${USERNAME}:users ${USERHOME}  /root/installer

cp -v ${USERHOME}/.bashrc /root/

INSTALLER_ELAPSED_SECS=$((${SECONDS} - ${INSTALLER_START_SECS}))
echo "INSTALLER Time Taken:  $(date -u -d @"${INSTALLER_ELAPSED_SECS}" +'%-Mm %Ss')" >> \
     /root/installer/logs/progress.log
