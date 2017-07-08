#!/bin/bash
SHELL=/bin/bash
# cd /home/steam/SteamLibrary
#cd '/home/steam/Steam/steamapps/common/Counter-Strike Global Offensive Beta - Dedicated Server'
cd /data/csgo_ds

echo "GSLT doc: https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive_Dedicated_Servers#Registering_Game_Server_Login_Token"
# ./srcds_run -game csgo -console -usercon +game_type 1 +game_mode 1 +mapgroup mg_demolition +map de_lake +sv_setsteamaccount $STEAM_GSLT  +ip $IP
# ./srcds_run -game csgo -console -usercon +game_type 1 +game_mode 1 +mapgroup mg_demolition +map de_lake +sv_setsteamaccount $STEAM_GSLT  -port $PORT
/bin/bash ./srcds_run -game csgo -console -usercon +game_type $CS_GAME_TYPE +game_mode $CS_GAME_MODE +mapgroup $CS_MAP_GROUP +map $CS_INITIAL_MAP +sv_setsteamaccount $STEAM_GSLT  -port $PORT
