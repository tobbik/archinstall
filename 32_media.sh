source config.sh

pacman -S --needed --noconfirm \
  avidemux-cli avidemux-qt \
  vlc xine-ui smplayer mplayer \
  live-media mpg123 libmtp libdvdcss twolame libnfs \
  kid3-qt yt-dlp aria2 libmatroska

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --needed --noconfirm \
    easytag
fi
