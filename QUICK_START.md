# Minecraft Server - Vereinfachte Version

**Fokussiertes DevSecOps Projekt mit nur den essentiellen Dateien**

## 📁 Projektdateien (7 Dateien)

```
minecraft-server/
├── Dockerfile              # Container Image mit Multi-Stage Build
├── docker-compose.yaml     # Service-Konfiguration
├── scripts/
│   └── start.sh           # Server Entrypoint mit JVM-Optimierung
├── .env.example           # Konfigurationstemplate
├── .dockerignore          # Build-Optimierung
├── .gitignore             # Git-Ausschlüsse
└── README.md              # Vollständige Dokumentation
```

## ⚡ Quick Start (3 Schritte)

```bash
# 1. Konfiguration erstellen
cp .env.example .env
nano .env  # EULA=true setzen

# 2. Server bauen und starten
docker compose up -d

# 3. Logs anzeigen
docker compose logs -f mc-server
```

**Fertig!** Verbinde mit Minecraft 1.21.11 zu `<deine-ip>:8888`

## ✨ Beibehaltene Optimierungen

### Automatischer Server-Download
```dockerfile
# Dockerfile Stage 1: Download
FROM ubuntu:22.04 AS downloader
RUN wget server.jar from Mojang

# Stage 2: Runtime
FROM ubuntu:22.04
COPY --from=downloader server.jar
```
**Vorteil**: Kein manueller Download, kleineres Image

### JVM Performance-Tuning
```bash
# start.sh mit G1GC Optimierung
java -Xms1G -Xmx2G \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  [15+ weitere Optimierungen]
  -jar minecraft_server.jar
```
**Vorteil**: Weniger Lag, bessere Performance

### Security Hardening
```yaml
# docker-compose.yaml
security_opt:
  - no-new-privileges:true
USER minecraft  # Non-root (UID 1000)
```
**Vorteil**: Produktionsreife Sicherheit

### Resource Management
```yaml
deploy:
  resources:
    limits:
      cpus: '2'
      memory: 3G
```
**Vorteil**: Verhindert Ressourcen-Überlastung

## 📝 Wichtigste Konfigurationen

### .env File (Minimal)
```bash
EULA=true                    # ERFORDERLICH!
SERVER_NAME=Mein Server
MAX_PLAYERS=20
MEMORY_MIN=1024M
MEMORY_MAX=2048M
GAMEMODE=survival
DIFFICULTY=normal
```

### Häufige Anpassungen
```bash
# Mehr Spieler = Mehr RAM
MAX_PLAYERS=50
MEMORY_MIN=3072M
MEMORY_MAX=6144M

# Creative Mode
GAMEMODE=creative

# Offline Mode (cracked clients)
ONLINE_MODE=false
```

## 🔧 Wichtige Commands

```bash
# Starten
docker compose up -d

# Stoppen
docker compose down

# Logs
docker compose logs -f mc-server

# Neu bauen (nach Dockerfile-Änderungen)
docker compose build --no-cache

# Status
docker compose ps
docker stats minecraft-server

# Neu starten
docker compose restart
```

## 🐛 Troubleshooting Schnellhilfe

| Problem | Lösung |
|---------|--------|
| Server startet nicht | `EULA=true` in .env setzen |
| Kann nicht verbinden | Firewall: `sudo ufw allow 8888/tcp` |
| Out of Memory | `MEMORY_MAX=4096M` in .env |
| Version mismatch | Client muss 1.21.11 sein |

Details: Siehe README.md

## 🎯 Was wurde weggelassen?

Für maximale Einfachheit NICHT enthalten:

- ❌ Makefile (nicht essentiell)
- ❌ setup.sh (Ersteinrichtung ist einfach genug)
- ❌ Backup-Scripts (manuell im README dokumentiert)
- ❌ Health-Check Script (Docker Health Check reicht)
- ❌ CI/CD Workflow (kann später hinzugefügt werden)
- ❌ Zusätzliche Docs (alles in README.md)

## 📚 Technische Highlights

**Multi-Stage Build**
- Downloader: 600MB
- Runtime: 400MB  
- **Ersparnis: 200MB**

**Security**
- Non-root User (minecraft:1000)
- no-new-privileges
- Resource Limits
- Health Checks

**Performance**
- G1GC Garbage Collector
- 15+ JVM Tuning Flags
- Pre-touched Memory
- Optimierte GC Pause Times

## 🚀 Deployment

```bash
# Production Ready!
1. git clone <repo>
2. cp .env.example .env && nano .env
3. docker compose up -d
```

Das wars! Alle wichtigen Features, aber übersichtlich und wartbar.

---

**DevSecOps Academy - Containerization Project**  
*Version: Simplified (Production Ready)*
