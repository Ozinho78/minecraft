# Minecraft Server - Docker Deployment

Containerized Minecraft Java Edition Server (Version 1.21.11). The setup uses Docker and Docker Compose to orchestrate a complete production environment.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quickstart](#quickstart)
3. [Configuration](#configuration)
    - [Memory Recommendations](#memory-recommendations)
4. [Usage](#usage)
    - [Server Management](#server-management)
    - [After Dockerfile Changes](#after-dockerfile-changes)
5. [Project Structure](#project-structure)
6. [License](#license)
   
---

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Minecraft Java Edition 1.21.11 (Client)
- At least 2GB RAM, 2 CPU cores

---

## Quick Start

### 1. Clone repository
```bash
git clone -b feature/minecraft-deployment git@github.com:Ozinho78/minecraft.git
cd minecraft
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
SERVER_NAME=MyMinecraftServer
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

---

## Project Structure
```
minecraft/
├── Dockerfile             # Container image definition
├── docker-compose.yaml    # Service orchestration
├── entrypoint.sh          # Server entrypoint
├── .env.example           # Configuration template, contains all environment variables
├── .dockerignore          # Build context exclusions
├── .gitignore             # Git exclusions
└── README.md              # This file, project documentation and usage
```

---

## License

This project was created for educational purposes as part of DevSecOps training.

**Minecraft** is a trademark of Mojang Studios (Microsoft). This project is not affiliated with or endorsed by Mojang Studios.

By using this software you agree to the [Minecraft EULA](https://www.minecraft.net/en-us/eula).

---

**Project Information:**
- **Last Updated:** January 2026
- **Course:** DevSecOps
- **Project:** Minecraft Server Containerization Project
