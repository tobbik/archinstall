#!/bin/bash

OLDDIR=$(pwd)

wget https://fl.us.mirror.archlinuxarm.org/aarch64/core/archlinuxarm-keyring-20240419-1-any.pkg.tar.xz
cd /
tar -xvJf ${OLDDIR}/archlinuxarm-keyring-20240419-1-any.pkg.tar.xz  usr/share/pacman/keyrings/archlinuxarm-revoked
tar -xvJf ${OLDDIR}/archlinuxarm-keyring-20240419-1-any.pkg.tar.xz  usr/share/pacman/keyrings/archlinuxarm-trusted
tar -xvJf ${OLDDIR}/archlinuxarm-keyring-20240419-1-any.pkg.tar.xz  usr/share/pacman/keyrings/archlinuxarm.gpg
mv usr/share/pacman/keyrings/archlinuxarm* /usr/share/keyrings/
cd ${OLDDIR}

apt update
apt install neovim git tig htop arch-install-scripts archlinux-keyring pacman-package-manager lm-sensors systemd-container

# source updated /etc/pacman.conf
cat > /etc/pacman.conf << "EOFPACMANCONF"
#
# /etc/pacman.conf
#
# See the pacman.conf(5) manpage for option and repository directives

#
# GENERAL OPTIONS
#
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir     = /home/pacman/cache
#LogFile      = /home/pacman/pacman.log
#GPGDir       = /home/pacman/gnupg
#HookDir     = /etc/pacman.d/hooks/
HoldPkg     = pacman glibc
#XferCommand = /usr/bin/curl -L -C - -f -o %o %u
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
Architecture = aarch64

# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
#IgnorePkg =
#IgnoreGroup =

#NoUpgrade   =
#NoExtract   =

# Misc options
#UseSyslog
#Color
#NoProgressBar
CheckSpace
#VerbosePkgLists
ParallelDownloads = 5
#DownloadUser = alpm
DisableSandbox

# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required

# NOTE: You must run `pacman-key --init` before first using pacman; the local
# keyring can then be populated with the keys of all official Arch Linux ARM
# packagers with `pacman-key --populate archlinuxarm`.


[core]
Server = http://mirror.archlinuxarm.org/$arch/$repo

[extra]
Server = http://mirror.archlinuxarm.org/$arch/$repo

[alarm]
Server = http://mirror.archlinuxarm.org/$arch/$repo

[aur]
Server = http://mirror.archlinuxarm.org/$arch/$repo

EOFPACMANCONF

pacman-key --init
pacman-key --populate archlinuxarm

cp config.sh config_org.sh
mv t14s_config.sh config.sh

pacman -Sy

bash format.sh
bash mount.sh

#pacstrap /mnt base base-devel mkinitcpio archlinuxarm-keyring

