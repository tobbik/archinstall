source config.sh

# ---------------------------------------------------------------       systemd-boot
if [ "x${BOOTMNGR}" == "xsystemd" ]; then
  pacman -S --needed --noconfirm efibootmgr
  UUIDROOT=$(blkid -s UUID -o value /dev/sda2)
  ESP_PATH=/EFI/Linux
  FULL_PATH="/efi${ESP_PATH}"
  mkdir -p /efi/loader/entries ${FULL_PATH}

  cp /etc/mkinitcpio.d/linux.preset /root/installer/logs/linux.preset.bak

  cat > /etc/mkinitcpio.d/linux.preset << EOLPRESETHEADER
# mkinitcpio preset file for the 'linux' package
ESP_DIR=${FULL_PATH}

EOLPRESETHEADER

  cat >> /etc/mkinitcpio.d/linux.preset << 'EOLPRESET'
#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="${ESP_DIR}/vmlinuz-linux"
[[ -e /boot/intel-ucode.img ]] && cp -af /boot/intel-ucode.img "${ESP_DIR}"
[[ -e /boot/amd-ucode.img ]]   && cp -af /boot/amd-ucode.img   "${ESP_DIR}"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
default_image="${ESP_DIR}/initramfs-linux.img"
#default_uki="${ESP_DIR}/arch-linux.efi"
#default_options="--splash=/usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="${ESP_DIR}/initramfs-linux-fallback.img"
#fallback_uki="${ESP_DIR}/arch-linux-fallback.efi"
#fallback_options="-S autodetect --cmdline /etc/kernel/fallback_cmdline"
EOLPRESET

  cat > /efi/loader/loader.conf << EOUBOOTLOAD
default       arch
timeout       6
console-mode  max
editor        no
EOUBOOTLOAD

cat > /efi/loader/entries/arch.conf << EOARCHCONF
title   Arch Linux
linux   ${ESP_PATH}/vmlinuz-linux
initrd  ${ESP_PATH}/intel-ucode.img
initrd  ${ESP_PATH}/initramfs-linux.img
options root=UUID=${UUIDROOT} ro
EOARCHCONF

cat > /efi/loader/entries/arch-fallback.conf << EOARCHFBCONF
title   Arch Linux (fallback initramfs)
linux   ${ESP_PATH}/vmlinuz-linux
initrd  ${ESP_PATH}/intel-ucode.img
initrd  ${ESP_PATH}/initramfs-linux-fallback.img
options root=UUID=${UUIDROOT} single ro
EOARCHFBCONF

fi


# ---------------------------------------------------------------       grub
if [ "x${BOOTMNGR}" == "xgrub" ]; then
  pacman -S --needed --noconfirm grub
fi

# ---------------------------------------------------------------       refind
if [ "x${BOOTMNGR}" == "xrefind" ]; then
  pacman -S --needed --noconfirm refind
fi


# ---------------------------------------------------------------       efistub
if [ "x${BOOTMNGR}" == "xefistub" ]; then
  pacman -S --needed --noconfirm efibootmgr
  UUIDROOT=$(blkid -s UUID -o value /dev/sda2)
  ESPPATH=/efi/EFI/Arch
  echo -e "ro root=UUID=${UUIDROOT}" > /etc/kernel/cmdline
  echo -e "ro root=UUID=${UUIDROOT} single" > /etc/kernel/fallback_cmdline
  mkdir -p ${ESPPATH}

  cp /etc/mkinitcpio.d/linux.preset /root/installer/logs/linux.preset.bak

  cat > /etc/mkinitcpio.d/linux.preset << EOLPRESET
# mkinitcpio preset file for the 'linux' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"
ALL_microcode=(/boot/*-ucode.img)

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux.img"
default_uki="${ESPPATH}/arch-linux.efi"
default_options="--splash=/usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-fallback.img"
fallback_uki="${ESPPATH}/arch-linux-fallback.efi"
fallback_options="-S autodetect --cmdline /etc/kernel/fallback_cmdline"
EOLPRESET

fi


# UGLY-HACK remove and re-install linux kernel to have it pickup the vmlinuz location
pacman -Rdd --noconfirm linux
pacman -S   --noconfirm linux
