FROM eclipse-temurin:21-jre-alpine

ARG MINECRAFT_VERSION=1.21.11
ARG SERVER_JAR_URL=https://piston-data.mojang.com/v1/objects/64bb6d763bed0a9f1d632ec347938594144943ed/server.jar

RUN apk add --no-cache wget bash

RUN addgroup -g 1000 minecraft && \
    adduser -D -u 1000 -G minecraft minecraft

WORKDIR /opt/minecraft

RUN wget -q --show-progress -O minecraft_server.jar "${SERVER_JAR_URL}" && \
    test -s minecraft_server.jar || (echo "ERROR: Download failed" && exit 1)

COPY --chown=minecraft:minecraft entrypoint.sh .
RUN chmod +x entrypoint.sh

RUN chown -R minecraft:minecraft /opt/minecraft

USER minecraft

EXPOSE 25565

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep -f "minecraft_server.jar" || exit 1

CMD ["./entrypoint.sh"]
