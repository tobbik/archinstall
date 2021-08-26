#!/bin/bash

cd "$(dirname "$0")"
RUNDIR=$(pwd)

source config.sh

for moduleName in ${MODULES[@]}; do
	echo "Executing ${moduleName}"
	cd ${RUNDIR}
	source "${moduleName}"
done

# flatten all permissions
chown -R ${USERNAME}:users /home/${USERNAME}

if [ "${BOOTMNGR}" == "grub" ]; then
	grub-install --recheck /dev/sda
	# hack for misnamed devices -> grub bug?
	grub-mkconfig -o /boot/grub/grub.cfg.mkc
	mv /boot/grub/grub.cfg.mkc /boot/grub/grub.cfg
fi

if [ "${BOOTMNGR}" == "refind" ]; then
	refind-install
fi
