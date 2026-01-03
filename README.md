# Minecraft Server - Docker Deployment

Containerized Minecraft Java Edition Server (Version 1.21.11). The setup uses Docker and Docker Compose to orchestrate a complete production environment.

---

## Table of Contents

1. [Requirements](#requirements)
2. [Quickstart](#quickstart)
3. [Configuration](#configuration)
4. [Usage](#usage)


   - [Environment Configuration](#environment-configuration)
   - [Building and Running](#building-and-running)
   - [Accessing the Application](#accessing-the-application)
   - [Managing Services](#managing-services)
   - [Working with Logs](#working-with-logs)

---

## Requirements

- Docker Engine 20.10+
- Docker Compose 2.0+
- Minecraft Java Edition 1.21.11 (Client)
- At least 2GB RAM, 2 CPU cores

---

## Quick Start

### 1. Clone repository
```bash
git clone -b feature/minecraft-deployment git@github.com:Ozinho78/minecraft.git
cd minecraft-server
```

### 2. Configure environment
```bash
# Create .env file
cp .env.example .env

# Edit .env and accept EULA
nano .env
```

> [!Important]
> Set `EULA=true` to accept the [Minecraft EULA](https://www.minecraft.net/en-us/eula).

### 3. Start server
```bash
# Build image and start server
docker compose up -d

# Follow logs
docker compose logs -f mc-server
```

### 4. Connect

Open Minecraft Java Edition 1.21.11:
- Multiplayer → Add Server
- Server Address: `<your-ip>:8888`
- Join!

---

## Configuration

All settings in the `.env` file:
```bash
# Minecraft EULA (REQUIRED)
EULA=true

# Server identity
SERVER_NAME=My Minecraft Server
MAX_PLAYERS=20

# Memory settings
MEMORY_MIN=1024M
MEMORY_MAX=2048M

# Gameplay
GAMEMODE=survival        # survival, creative, adventure, spectator
DIFFICULTY=normal        # peaceful, easy, normal, hard
PVP=true
VIEW_DISTANCE=10

# Authentication
ONLINE_MODE=true         # true = Mojang Auth (recommended)
```

### Memory Recommendations

| Players | RAM Setting |
|---------|-------------|
| 1-5     | `MEMORY_MIN=1024M MEMORY_MAX=2048M` |
| 5-10    | `MEMORY_MIN=2048M MEMORY_MAX=4096M` |
| 10-20   | `MEMORY_MIN=3072M MEMORY_MAX=6144M` |

---

## Usage

### Server Management
```bash
# Start server
docker compose up -d

# Show logs
docker compose logs -f mc-server

# Stop server
docker compose down

# Restart server
docker compose restart

# Check status
docker compose ps
docker stats minecraft-server
```

### After Dockerfile Changes
```bash
# Rebuild image
docker compose build --no-cache

# Start with rebuild
docker compose up -d --build
```

### Backup
```bash
# Stop server
docker compose down

# Create backup
docker run --rm \
  -v minecraft-world-data:/data:ro \
  -v $(pwd)/backups:/backup \
  ubuntu:22.04 \
  tar czf /backup/world-backup-$(date +%Y%m%d).tar.gz /data

# Start server
docker compose up -d
```

### Restore
```bash
# Stop server
docker compose down

# Delete volume
docker volume rm minecraft-world-data

# Restore
docker run --rm \
  -v minecraft-world-data:/data \
  -v $(pwd)/backups:/backup \
  ubuntu:22.04 \
  tar xzf /backup/world-backup-YYYYMMDD.tar.gz -C /

# Start server
docker compose up -d
```

## Project Structure
```
minecraft-server/
├── Dockerfile              # Container image definition
├── docker-compose.yaml     # Service orchestration
├── scripts/
│   └── start.sh           # Server entrypoint
├── .env.example           # Configuration template
├── .dockerignore          # Build context exclusions
├── .gitignore             # Git exclusions
├── logs/                  # Server logs (auto-created)
└── README.md              # This file
```

## Troubleshooting

### Server won't start

**Problem:** `ERROR: You must accept the Minecraft EULA`

**Solution:**
```bash
# Edit .env
nano .env
# Set: EULA=true

# Restart
docker compose restart
```

### Cannot connect

**Problem:** Connection refused / Connection timed out

**Checks:**
```bash
# 1. Server running?
docker compose ps

# 2. Port reachable?
netstat -tulpn | grep 8888

# 3. Firewall?
sudo ufw allow 8888/tcp
sudo ufw status

# 4. Check logs
docker compose logs mc-server | tail -50
```

### Out of Memory

**Problem:** Server crashes or is slow

**Solution:**
```bash
# Increase memory in .env
MEMORY_MAX=4096M
MEMORY_LIMIT=5G

# Restart
docker compose restart
```

### Version Mismatch

**Problem:** "Incompatible client/server version"

**Solution:**
- Make sure your client is version 1.21.11
- For other versions: change `MINECRAFT_VERSION` in .env and rebuild

## Technical Details

### Docker Multi-Stage Build

The Dockerfile uses a two-stage build:

1. **Downloader Stage**: Downloads `server.jar` from Mojang
2. **Runtime Stage**: Copies only the JAR, without build tools

Advantage: Smaller final image (~400MB instead of ~600MB)

### Security

- **Non-root User**: Container runs as `minecraft` (UID 1000)
- **Security Options**: `no-new-privileges`, no additional capabilities
- **Resource Limits**: CPU and memory limited
- **Health Checks**: Automatic monitoring

### Performance

JVM is optimized with G1 Garbage Collector:
- Reduced lag spikes through GC tuning
- Optimal memory usage
- Pre-touched memory allocation

## Network & Firewall

### Port Opening
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

For access from outside your network:
1. Open router admin
2. Set up port forwarding: `8888 → <server-ip>:8888`
3. Determine public IP: `curl ifconfig.me`

## FAQ

**Q: Why is server.jar not in the repository?**  
A: The JAR is automatically downloaded during build. This:
- Keeps the repo small (~100KB instead of ~50MB)
- Complies with Mojang's redistribution guidelines
- Enables easy version updates

**Q: How do I change the Minecraft version?**  
A: Adjust the `MINECRAFT_VERSION` value in `.env`, update the `SERVER_JAR_URL` in the Dockerfile with the new URL from [Mojang](https://launchermeta.mojang.com/mc/game/version_manifest.json), and rebuild: `docker compose build --no-cache`

**Q: Can I use plugins?**  
A: This setup uses vanilla Minecraft. For plugins you need Paper/Spigot and must modify the Dockerfile.

**Q: Where is the world data stored?**  
A: In the Docker volume `minecraft-world-data`. Check with: `docker volume inspect minecraft-world-data`

## License

This project was created for educational purposes as part of DevSecOps training.

**Minecraft** is a trademark of Mojang Studios (Microsoft). This project is not affiliated with or endorsed by Mojang Studios.

By using this software you agree to the [Minecraft EULA](https://www.minecraft.net/en-us/eula).

---

**Last Updated: January 2026**
**Course: DevSecOps**
**Project: Mincecraft Server Containerization Project**
