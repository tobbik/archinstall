source config.sh

# this allows to substitute in iptables-nft. Needed for kubectl and friends
if pacman -Q iptables ; then
  pacman -Rdd --noconfirm iptables
fi

pacman -S --needed --noconfirm \
  docker arch-install-scripts lxc haveged \
  docker-compose \
  bridge-utils lua-alt-getopt ca-certificates \
  iptables-nft kubeadm kubelet kubectl

usermod -a -G docker ${USERNAME}

if [ -z ${DOCKERSTORAGEPATH+x} ]; then
  DOCKERSTORAGEPATH=/home/${USERNAME}/docker
  sudo --user ${USERNAME} mkdir -p ${DOCKERSTORAGEPATH}
fi

mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/my_config.conf << EODOCKERCONF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd \\
         -H fd:// \\
         --exec-opt native.cgroupdriver=cgroupfs \\
         --storage-driver overlay2 \\
         --data-root ${DOCKERSTORAGEPATH}
EODOCKERCONF

#systemctl daemon-reload
systemctl enable docker.service

update-ca-trust

# set up .bashrc with some aliases
cat >> /home/${USERNAME}/.bashrc << EOBASHRC

alias dockerps='docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Ports}}\\t{{.Status}}"'
EOBASHRC