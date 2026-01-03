# Multi-stage build for Minecraft Server
# Stage 1: Download server.jar from Mojang
FROM ubuntu:22.04 AS downloader

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Minecraft version and download URL
ARG MINECRAFT_VERSION=1.21.11
ARG SERVER_JAR_URL=https://piston-data.mojang.com/v1/objects/64bb6d763bed0a9f1d632ec347938594144943ed/server.jar

WORKDIR /download
RUN wget -q --show-progress -O minecraft_server.jar "${SERVER_JAR_URL}" && \
    test -s minecraft_server.jar || (echo "ERROR: Download failed" && exit 1)

# Stage 2: Runtime image
FROM ubuntu:22.04

# Environment variables with defaults
ENV MINECRAFT_VERSION="1.21.11" \
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

# Install Java 21
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-21-jre-headless && \
    rm -rf /var/lib/apt/lists/*

# Create minecraft user (non-root)
RUN useradd -r -m -d /opt/minecraft -u 1000 minecraft

WORKDIR /opt/minecraft

# Copy server.jar from downloader stage
COPY --from=downloader --chown=minecraft:minecraft /download/minecraft_server.jar .

# Copy startup script
COPY --chown=minecraft:minecraft entrypoint.sh .
RUN chmod +x entrypoint.sh

# Switch to non-root user
USER minecraft

# Expose Minecraft port
EXPOSE ${MINECRAFT_PORT}

# Volume for persistent data
VOLUME ["/opt/minecraft"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep -f "minecraft_server.jar" || exit 1

# Start server
CMD ["./entrypoint.sh"]
