#!/bin/bash

sudo chown -R steam. /home/steam
mkdir /home/steam/serverfiles/csgo_ds

cp /assets/steamer.txt /home/steam/
cd /home/steam
sed -i "s/REPLACEME_USERNAME/$STEAM_USERNAME/" steamer.txt
sed -i "s/REPLACEME_PASSWORD/$STEAM_PASSWORD/" steamer.txt
sed -i "s/REPLACEME_GID/$STEAM_GID/" steamer.txt
./steamcmd.sh +runscript /home/steam/steamer.txt
bash /assets/run.sh
