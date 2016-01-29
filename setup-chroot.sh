#!/bin/bash

cd "$(dirname "$0")"
source config.sh

for moduleName in ${MODULES[@]}; do
	echo "Executing ${moduleName}"
	source "${moduleName}"
done


if [ "${BOOTMNGR}" == "grub" ]; then
	grub-install --recheck /dev/sda
	#hack for misnamed devices -> grub bug?
	grub-mkconfig -o /boot/grub/grub.cfg.mkc
	mv /boot/grub/grub.cfg.mkc /boot/grub/grub.cfg
fi

if [ "${BOOTMNGR}" == "refind-efi" ]; then
	refind-install
fi
