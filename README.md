# Minecraft Server - Docker Deployment

Containerisierter Minecraft Java Edition Server (Version 1.21.11) für die DevSecOps Ausbildung.

## Features

- ✅ **Automatischer Download**: Server JAR wird beim Build von Mojang heruntergeladen
- ✅ **Multi-Stage Build**: Optimiertes Docker Image (~400MB)
- ✅ **Security**: Non-root User, Resource Limits, Health Checks
- ✅ **Performance**: Optimierte JVM Flags (G1GC)
- ✅ **Einfache Konfiguration**: Alle Settings via `.env` Datei

## Voraussetzungen

- Docker Engine 20.10+
- Docker Compose 2.0+
- Minecraft Java Edition 1.21.11 (Client)
- Mindestens 2GB RAM, 2 CPU Cores

## Quick Start

### 1. Repository klonen

```bash
git clone <repository-url>
cd minecraft-server
```

### 2. Umgebung konfigurieren

```bash
# .env Datei erstellen
cp .env.example .env

# .env bearbeiten und EULA akzeptieren
nano .env
```

**Wichtig:** Setze `EULA=true` um die [Minecraft EULA](https://www.minecraft.net/en-us/eula) zu akzeptieren.

### 3. Server starten

```bash
# Image bauen und Server starten
docker compose up -d

# Logs verfolgen
docker compose logs -f mc-server
```

Warte bis du diese Meldung siehst:
```
Done (XXs)! For help, type "help"
```

### 4. Verbinden

Öffne Minecraft Java Edition 1.21.11:
- Multiplayer → Add Server
- Server Address: `<deine-ip>:8888`
- Join!

## Konfiguration

Alle Einstellungen in der `.env` Datei:

```bash
# Minecraft EULA (ERFORDERLICH)
EULA=true

# Server Identität
SERVER_NAME=My Minecraft Server
MAX_PLAYERS=20

# Memory Einstellungen
MEMORY_MIN=1024M
MEMORY_MAX=2048M

# Gameplay
GAMEMODE=survival        # survival, creative, adventure, spectator
DIFFICULTY=normal        # peaceful, easy, normal, hard
PVP=true
VIEW_DISTANCE=10

# Authentifizierung
ONLINE_MODE=true         # true = Mojang Auth (empfohlen)
```

### Memory Empfehlungen

| Spieler | RAM Einstellung |
|---------|----------------|
| 1-5     | `MEMORY_MIN=1024M MEMORY_MAX=2048M` |
| 5-10    | `MEMORY_MIN=2048M MEMORY_MAX=4096M` |
| 10-20   | `MEMORY_MIN=3072M MEMORY_MAX=6144M` |

## Verwendung

### Server Management

```bash
# Server starten
docker compose up -d

# Logs anzeigen
docker compose logs -f mc-server

# Server stoppen
docker compose down

# Server neu starten
docker compose restart

# Status prüfen
docker compose ps
docker stats minecraft-server
```

### Nach Dockerfile Änderungen

```bash
# Image neu bauen
docker compose build --no-cache

# Mit Rebuild starten
docker compose up -d --build
```

### Backup

```bash
# Server stoppen
docker compose down

# Backup erstellen
docker run --rm \
  -v minecraft-world-data:/data:ro \
  -v $(pwd)/backups:/backup \
  ubuntu:22.04 \
  tar czf /backup/world-backup-$(date +%Y%m%d).tar.gz /data

# Server starten
docker compose up -d
```

### Restore

```bash
# Server stoppen
docker compose down

# Volume löschen
docker volume rm minecraft-world-data

# Wiederherstellen
docker run --rm \
  -v minecraft-world-data:/data \
  -v $(pwd)/backups:/backup \
  ubuntu:22.04 \
  tar xzf /backup/world-backup-YYYYMMDD.tar.gz -C /

# Server starten
docker compose up -d
```

## Projektstruktur

```
minecraft-server/
├── Dockerfile              # Container Image Definition
├── docker-compose.yaml     # Service Orchestrierung
├── scripts/
│   └── start.sh           # Server Entrypoint
├── .env.example           # Konfigurations-Template
├── .dockerignore          # Build Context Ausschlüsse
├── .gitignore             # Git Ausschlüsse
├── logs/                  # Server Logs (auto-erstellt)
└── README.md              # Diese Datei
```

## Troubleshooting

### Server startet nicht

**Problem:** `ERROR: You must accept the Minecraft EULA`

**Lösung:**
```bash
# .env bearbeiten
nano .env
# Setze: EULA=true

# Neu starten
docker compose restart
```

### Kann nicht verbinden

**Problem:** Connection refused / Connection timed out

**Checks:**
```bash
# 1. Server läuft?
docker compose ps

# 2. Port erreichbar?
netstat -tulpn | grep 8888

# 3. Firewall?
sudo ufw allow 8888/tcp
sudo ufw status

# 4. Logs prüfen
docker compose logs mc-server | tail -50
```

### Out of Memory

**Problem:** Server crasht oder ist langsam

**Lösung:**
```bash
# Memory in .env erhöhen
MEMORY_MAX=4096M
MEMORY_LIMIT=5G

# Neu starten
docker compose restart
```

### Version Mismatch

**Problem:** "Incompatible client/server version"

**Lösung:**
- Stelle sicher dass dein Client Version 1.21.11 ist
- Für andere Versionen: `MINECRAFT_VERSION` in .env ändern und neu bauen

## Technische Details

### Docker Multi-Stage Build

Das Dockerfile nutzt einen zweistufigen Build:

1. **Downloader Stage**: Lädt `server.jar` von Mojang
2. **Runtime Stage**: Kopiert nur die JAR, ohne Build-Tools

Vorteil: Kleineres finales Image (~400MB statt ~600MB)

### Sicherheit

- **Non-root User**: Container läuft als `minecraft` (UID 1000)
- **Security Options**: `no-new-privileges`, keine zusätzlichen Capabilities
- **Resource Limits**: CPU und Memory begrenzt
- **Health Checks**: Automatische Überwachung

### Performance

JVM ist mit G1 Garbage Collector optimiert:
- Reduzierte Lag-Spikes durch GC-Tuning
- Optimale Memory-Nutzung
- Pre-touched Memory Allocation

## Netzwerk & Firewall

### Port Freigabe

```bash
# UFW (Ubuntu/Debian)
sudo ufw allow 8888/tcp
sudo ufw enable

# firewalld (RHEL/CentOS)
sudo firewall-cmd --permanent --add-port=8888/tcp
sudo firewall-cmd --reload

# iptables
sudo iptables -A INPUT -p tcp --dport 8888 -j ACCEPT
```

### Router Port Forwarding

Für Zugriff von außerhalb deines Netzwerks:
1. Router Admin öffnen
2. Port Forwarding einrichten: `8888 → <server-ip>:8888`
3. Öffentliche IP ermitteln: `curl ifconfig.me`

## FAQ

**Q: Warum ist server.jar nicht im Repository?**  
A: Die JAR wird automatisch beim Build heruntergeladen. Dies:
- Hält das Repo klein (~100KB statt ~50MB)
- Entspricht Mojangs Redistribution-Richtlinien
- Ermöglicht einfache Version-Updates

**Q: Wie ändere ich die Minecraft Version?**  
A: Passe in `.env` den `MINECRAFT_VERSION` Wert an, update die `SERVER_JAR_URL` im Dockerfile mit der neuen URL von [Mojang](https://launchermeta.mojang.com/mc/game/version_manifest.json), und baue neu: `docker compose build --no-cache`

**Q: Kann ich Plugins nutzen?**  
A: Dieses Setup nutzt Vanilla Minecraft. Für Plugins brauchst du Paper/Spigot und musst das Dockerfile anpassen.

**Q: Wo sind die World-Daten gespeichert?**  
A: Im Docker Volume `minecraft-world-data`. Prüfe mit: `docker volume inspect minecraft-world-data`

## Lizenz

Dieses Projekt wurde für Bildungszwecke im Rahmen der DevSecOps Ausbildung erstellt.

**Minecraft** ist eine Marke von Mojang Studios (Microsoft). Dieses Projekt ist nicht mit Mojang Studios verbunden oder von diesem unterstützt.

Durch die Nutzung dieser Software stimmst du der [Minecraft EULA](https://www.minecraft.net/en-us/eula) zu.

---

**DevSecOps Academy - Containerization Project**
