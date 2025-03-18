source config.sh

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S ${PACMANFLAGS} \
    dotnet-host dotnet-runtime dotnet-sdk dotnet-targeting-pack \
    aspnet-runtime aspnet-targeting-pack
fi

