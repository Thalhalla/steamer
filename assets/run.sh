#!/bin/bash
# cd /home/steam/SteamLibrary
#cd '/home/steam/Steam/steamapps/common/Counter-Strike Global Offensive Beta - Dedicated Server'
cd /home/steam/serverfiles/csgo_ds

echo "GLST doc: https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive_Dedicated_Servers#Registering_Game_Server_Login_Token"
# ./srcds_run -game csgo -console -usercon +game_type 1 +game_mode 1 +mapgroup mg_demolition +map de_lake +sv_setsteamaccount $STEAM_GLST  +ip $IP
./srcds_run -game csgo -console -usercon +game_type 1 +game_mode 1 +mapgroup mg_demolition +map de_lake +sv_setsteamaccount $STEAM_GLST  -port $PORT
