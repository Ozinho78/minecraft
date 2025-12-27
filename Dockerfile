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

COPY server.jar /opt/minecraft/minecraft_server.jar
COPY scripts/start.sh /opt/minecraft/start.sh

RUN chown minecraft:minecraft /opt/minecraft/minecraft_server.jar /opt/minecraft/start.sh && \
    chmod +x /opt/minecraft/start.sh

USER minecraft

EXPOSE ${MINECRAFT_PORT}

VOLUME ["/opt/minecraft"]

CMD ["/opt/minecraft/start.sh"]
