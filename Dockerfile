FROM debian:stretch
MAINTAINER Josh Cox <josh 'at' webhosting coop>

ENV STEAMER_UPDATED 20161229
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
#ENV LC_ALL en_US.UTF-8
#APT
RUN echo 'deb http://http.debian.net/debian/ stretch main contrib non-free'>>/etc/apt/sources.list ; \
dpkg --add-architecture i386 ; \
apt-get -y update ; \
apt-get install -y locales && \
dpkg-reconfigure --frontend=noninteractive locales && \
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
locale-gen && \
apt-get install -y sudo wget lib32stdc++6 lib32z1 lib32z1-dev net-tools procps \
libcurl4-gnutls-dev:i386 build-essential gdb mailutils postfix curl wget file \
lib32ncurses5 lib32bz2-1.0 lib32asound2  \
gzip bzip2 bsdmainutils python util-linux tmux byobu lib32gcc1 libstdc++6 libstdc++6:i386 && \
echo "steam steam/purge note" |  debconf-set-selections && \
echo "steam steam/license note" |  debconf-set-selections && \
echo "steam steam/question select I AGREE" |  debconf-set-selections && \
apt-get install -y steam && \
rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND interactive

# override these variables in with the prompts
ENV STEAM_USERNAME anonymous
ENV STEAM_PASSWORD ' '


# and override this file with the command to start your server
COPY assets /assets
RUN chmod 755 /assets/start.sh ; \
chmod 755 /assets/run.sh ; \
chmod 755 /assets/steamer.txt ; \
useradd -m -s /bin/bash steam ; \
usermod -a -G sudo,video,audio,tty steam ; \
echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers ; \
chown -R steam. /home/steam

RUN locale-gen

USER steam
WORKDIR /home/steam/

RUN curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf -
RUN sudo install -m=755 linux32/steamcmd /usr/local/bin/steamcmd

#USER root
#ENTRYPOINT ["/bin/bash"]
VOLUME /home/steam/.steam
VOLUME /home/steam/.local
VOLUME /home/steam/steamcmd
VOLUME /home/steam/Steam
VOLUME /home/steam/SteamLibrary
VOLUME /home/steam/serverfiles
VOLUME /home/steam/log
CMD ["/bin/bash",  "/assets/start.sh"]
