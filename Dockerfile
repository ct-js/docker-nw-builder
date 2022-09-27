FROM node:lts-bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https zip unzip

RUN dpkg --add-architecture i386 \
    && wget -nc https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key \
    && echo "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11 ./" >> /etc/apt/sources.list

RUN wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11/Release.key \
    && apt-key add Release.key \
    && echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" >> /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y winehq-stable

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x winetricks && mv winetricks /usr/local/bin

RUN apt-get install -y --no-install-recommends xvfb xauth

RUN winecfg && xvfb-run -a winetricks -q dotnet20

RUN npm install -g gulp-cli