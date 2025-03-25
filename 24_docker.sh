source config.sh
source helper.sh

# this allows to substitute in iptables-nft. Needed for kubectl and friends
if pacman -Q iptables ; then
  pacman -Rdd --noconfirm iptables
fi

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  docker arch-install-scripts lxc haveged \
  "bind" docker-compose docker-buildx \
  bridge-utils lua-alt-getopt ca-certificates \
  iptables-nft kubeadm kubelet kubectl helm

usermod -a -G docker ${USERNAME}

if [[ -z ${DOCKERSTORAGEPATH} ]]; then
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
enable_service docker.service

update-ca-trust

# set up .bashrc with some aliases
add_alias "dockerps"  "docker ps --format \"table {{.Names}}\\t{{.Image}}\\t{{.Ports}}\\t{{.Status}}\""

