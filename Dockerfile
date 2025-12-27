# Use Ubuntu as base image
FROM ubuntu:22.04

ENV MINECRAFT_VERSION="1.21.1" \
    MINECRAFT_PORT="25565" \
    MEMORY_MIN="1024M" \
    MEMORY_MAX="2048M" \
    EULA="false" \
    SERVER_NAME="Minecraft Server" \
    GAMEMODE="survival" \
    DIFFICULTY="normal" \
    MAX_PLAYERS="20" \
    ONLINE_MODE="true" \
    PVP="true" \
    SPAWN_PROTECTION="16" \
    VIEW_DISTANCE="10"

RUN apt-get update && \
    apt-get install -y \
    openjdk-21-jre-headless \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /opt/minecraft -s /bin/bash minecraft

WORKDIR /opt/minecraft

COPY server12111.jar /opt/minecraft/minecraft_server.jar
RUN chown minecraft:minecraft /opt/minecraft/minecraft_server.jar

RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Accept EULA if environment variable is set\n\
if [ "${EULA}" = "true" ]; then\n\
    echo "eula=true" > eula.txt\n\
    echo "EULA accepted via environment variable"\n\
else\n\
    echo "ERROR: You must accept the Minecraft EULA by setting EULA=true"\n\
    echo "See https://www.minecraft.net/en-us/eula for details"\n\
    exit 1\n\
fi\n\
\n\
# Generate server.properties if it does not exist\n\
if [ ! -f server.properties ]; then\n\
    echo "Generating server.properties..."\n\
    cat > server.properties <<EOF\n\
# Minecraft server properties\n\
server-port=${MINECRAFT_PORT}\n\
motd=${SERVER_NAME}\n\
gamemode=${GAMEMODE}\n\
difficulty=${DIFFICULTY}\n\
max-players=${MAX_PLAYERS}\n\
online-mode=${ONLINE_MODE}\n\
pvp=${PVP}\n\
spawn-protection=${SPAWN_PROTECTION}\n\
view-distance=${VIEW_DISTANCE}\n\
enable-command-block=false\n\
level-name=world\n\
level-seed=\n\
allow-nether=true\n\
enable-query=false\n\
enable-rcon=false\n\
EOF\n\
fi\n\
\n\
# Start Minecraft server\n\
echo "Starting Minecraft Server ${MINECRAFT_VERSION}..."\n\
exec java -Xms${MEMORY_MIN} -Xmx${MEMORY_MAX} -jar minecraft_server.jar nogui\n\
' > /opt/minecraft/start.sh && \
    chmod +x /opt/minecraft/start.sh && \
    chown minecraft:minecraft /opt/minecraft/start.sh

# Switch to minecraft user
USER minecraft

# Expose Minecraft port
EXPOSE ${MINECRAFT_PORT}

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${MINECRAFT_PORT} || exit 1

# Set volume for persistent data
VOLUME ["/opt/minecraft"]

# Start server
CMD ["/opt/minecraft/start.sh"]
