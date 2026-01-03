FROM ubuntu:22.04 AS downloader

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ARG MINECRAFT_VERSION=1.21.11
ARG SERVER_JAR_URL=https://piston-data.mojang.com/v1/objects/64bb6d763bed0a9f1d632ec347938594144943ed/server.jar

WORKDIR /download
RUN wget -q --show-progress -O minecraft_server.jar "${SERVER_JAR_URL}" && \
    test -s minecraft_server.jar || (echo "ERROR: Download failed" && exit 1)


FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-21-jre-headless && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -r -m -d /opt/minecraft -u 1000 minecraft

WORKDIR /opt/minecraft

COPY --from=downloader --chown=minecraft:minecraft /download/minecraft_server.jar .

COPY --chown=minecraft:minecraft entrypoint.sh .
RUN chmod +x entrypoint.sh

USER minecraft

EXPOSE ${MINECRAFT_PORT}

VOLUME ["/opt/minecraft"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep -f "minecraft_server.jar" || exit 1

CMD ["./entrypoint.sh"]
