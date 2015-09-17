useradd --gid users \
  --groups wheel,http,postgres,network,video,audio,storage,power,wireshark,git \
  --create-home \
  --password $USERPASS \
  --shell /bib/bash \
  $USERNAME

# reset the password to be sure
echo -e "${USERPASS}\n${USERPASS}" | (passwd -q arch)

# set root password
echo -e "${ROOTPASS}\n${ROOTPASS}" | (passwd -q root)

