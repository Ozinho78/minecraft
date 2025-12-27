#!/bin/bash
set -e

if [ "${EULA}" = "true" ]; then
    echo "eula=true" > eula.txt
    echo "EULA accepted via environment variable"
else
    echo "ERROR: You must accept the Minecraft EULA by setting EULA=true"
    echo "See https://www.minecraft.net/en-us/eula for details"
    exit 1
fi

if [ ! -f server.properties ]; then
    echo "Generating server.properties..."
    cat > server.properties <<EOF
# Minecraft server properties
server-port=${MINECRAFT_PORT}
motd=${SERVER_NAME}
gamemode=${GAMEMODE}
difficulty=${DIFFICULTY}
max-players=${MAX_PLAYERS}
online-mode=${ONLINE_MODE}
pvp=${PVP}
spawn-protection=${SPAWN_PROTECTION}
view-distance=${VIEW_DISTANCE}
enable-command-block=false
level-name=world
level-seed=
allow-nether=true
enable-query=false
enable-rcon=false
EOF
fi

echo "Starting Minecraft Server ${MINECRAFT_VERSION}..."
exec java -Xms${MEMORY_MIN} -Xmx${MEMORY_MAX} -jar minecraft_server.jar nogui
