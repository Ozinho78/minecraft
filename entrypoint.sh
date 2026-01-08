#!/bin/bash
set -e

echo "=== Minecraft Server Startup ==="
echo "Version: ${MINECRAFT_VERSION}"

if [ "${EULA}" != "true" ]; then
    echo "ERROR: You must accept the Minecraft EULA"
    echo "Set EULA=true in your .env file"
    echo "See: https://www.minecraft.net/en-us/eula"
    exit 1
fi

echo "EULA accepted"
echo "eula=false" > eula.txt

if [ ! -f server.properties ]; then
    echo "Generating server.properties..."
    cat > server.properties <<EOF
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
allow-nether=true
EOF
    echo "server.properties created"
fi

echo ""
echo "Server Configuration:"
echo "  Port:         ${MINECRAFT_PORT}"
echo "  Max Players:  ${MAX_PLAYERS}"
echo "  Memory:       ${MEMORY_MIN} - ${MEMORY_MAX}"
echo "  Gamemode:     ${GAMEMODE}"
echo "  Difficulty:   ${DIFFICULTY}"
echo ""

echo "Starting Minecraft server..."
exec java \
    -Xms${MEMORY_MIN} \
    -Xmx${MEMORY_MAX} \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -jar minecraft_server.jar nogui
