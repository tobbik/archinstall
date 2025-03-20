source config.sh

pacman -S --needed -noconfirm ${PACMANEXTRAFLAGS} \
  avidemux-cli avidemux-qt guvcview \
  xine-ui smplayer mplayer \
  live-media mpg123 libmtp libdvdcss twolame libnfs \
  kid3-qt libmatroska easytag

