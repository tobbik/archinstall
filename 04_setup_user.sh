useradd --gid users \
  --groups wheel,http,postgres,network,video,audio,storage,power,wireshark,git,docker \
  --create-home \
  --password $USERPASS \
  --shell /bin/bash \
  $USERNAME

sed -i "s/^\(root .*\)$/\1\n${USERNAME} ALL=(ALL) ALL/" /etc/sudoers

# reset the password to be sure
echo -e "${USERPASS}\n${USERPASS}" | (passwd -q ${USERNAME})

# set root password
echo -e "${ROOTPASS}\n${ROOTPASS}" | (passwd -q root)
