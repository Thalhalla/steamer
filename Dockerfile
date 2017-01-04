FROM debian:stretch
MAINTAINER Josh Cox <josh 'at' webhosting coop>

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
# override these variables in with the prompts
ENV STEAM_USERNAME anonymous
ENV STEAM_PASSWORD ' '

# Start non-interactive apt
ENV DEBIAN_FRONTEND noninteractive
ENV STEAMER_UPDATED 20170104
#ENV LC_ALL en_US.UTF-8
#APT
COPY sources.list /etc/apt/sources.list.d/thalhalla.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F24AEA9FB05498B7 ; \
dpkg --add-architecture i386 ; \
apt-get -yqq update ; \
apt-get install -yqq locales && \
dpkg-reconfigure --frontend=noninteractive locales && \
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
locale-gen && \
apt-get install -yqq sudo wget lib32stdc++6 lib32z1 lib32z1-dev net-tools procps \
libcurl4-gnutls-dev:i386 build-essential gdb mailutils postfix curl wget file \
lib32ncurses5 libasound2 fail2ban \
gzip bzip2 bsdmainutils python util-linux tmux byobu lib32gcc1 libstdc++6 libstdc++6:i386 && \
rm -rf /var/lib/apt/lists/*
# End non-interactive apt
ENV DEBIAN_FRONTEND interactive

# parking lot
# echo "steam steam/purge note" |  debconf-set-selections && \
# echo "steam steam/license note" |  debconf-set-selections && \
# echo "steam steam/question select I AGREE" |  debconf-set-selections && \
# apt-get install -yqq steam steamcmd && \

# and override this file with the command to start your server
COPY assets /assets
RUN chmod 755 /assets/start.sh ; \
chmod 755 /assets/run.sh ; \
chmod 755 /assets/steamer.txt ; \
useradd -m -s /bin/bash steam ; \
usermod -a -G sudo,video,audio,tty steam ; \
echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers ; \
chown -R steam. /home/steam ; \
mkdir -p /opt/steamer ; \
locale-gen

WORKDIR /opt/steamer/
RUN wget -q 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' ; \
tar zxf steamcmd_linux.tar.gz ; \
sudo install -m=755 linux32/steamcmd /usr/local/bin/steamcmd

USER steam
WORKDIR /home/steam/

#USER root
#ENTRYPOINT ["/bin/bash"]
VOLUME /home/steam/
CMD ["/bin/bash",  "/assets/start.sh"]
