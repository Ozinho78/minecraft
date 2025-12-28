# Minecraft Server - Docker Deployment

A production-ready, containerized Minecraft Java Edition server built with Docker and Docker Compose.

## Table of Contents

- [Description](#description)
- [Prerequisites](#prerequisites)
- [Quickstart](#quickstart)
- [Usage](#usage)
  - [Environment Configuration](#environment-configuration)
  - [Starting the Server](#starting-the-server)
  - [Stopping the Server](#stopping-the-server)
  - [Viewing Logs](#viewing-logs)
- [Configuration](#configuration)
  - [Memory Settings](#memory-settings)
  - [Game Settings](#game-settings)
- [Project Structure](#project-structure)
- [License](#license)

## Description

This repository contains a complete Docker-based deployment solution for a Minecraft Java Edition server (version 1.21.11). The setup is designed for educational purposes.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Docker Engine**: Version 20.10 or higher
  ```bash
  docker --version
  ```
- **Docker Compose**: Version 2.0 or higher
  ```bash
  docker compose version
  ```
- **Git**: For cloning the repository
  ```bash
  git --version
  ```

**System Requirements:**
- Minimum 2GB RAM (4GB recommended)
- 2 CPU cores (recommended)
- 10GB free disk space
- Open port 8888 (or your configured port) in your firewall

## Quickstart

Get your Minecraft server up and running in 5 minutes:

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd minecraft-server
   ```

2. **Create environment configuration:**
   ```bash
   cp .env.example .env
   ```

3. **Accept the Minecraft EULA:**
   
   Edit the `.env` file and set:
   ```bash
   EULA=true
   ```
   
   By setting this to `true`, you accept the [Minecraft End User License Agreement](https://www.minecraft.net/en-us/eula).

4. **Start the server:**
   ```bash
   docker compose up -d
   ```

5. **Check server status:**
   ```bash
   docker compose logs -f mc-server
   ```

6. **Connect to your server:**
   
   Open Minecraft Java Edition and connect to:
   ```
   <your-server-ip>:8888
   ```

That's it! Your Minecraft server is now running.

## Usage

### Environment Configuration

All server configuration is managed through environment variables. Copy the example file to create your configuration:

```bash
cp .env.example .env
```

Edit `.env` to customize your server. **Important settings:**

```bash
# REQUIRED: Accept Minecraft EULA
EULA=true

# Server identity
SERVER_NAME=My Awesome Server
MAX_PLAYERS=20

# Memory allocation (adjust based on your system)
MEMORY_MIN=1024M
MEMORY_MAX=2048M

# Game settings
GAMEMODE=survival
DIFFICULTY=normal
```

### Starting the Server

Start the server in detached mode (runs in background):

```bash
docker compose up -d
```

Start with logs visible:

```bash
docker compose up
```

Build and start (after Dockerfile changes):

```bash
docker compose up -d --build
```

### Stopping the Server

Gracefully stop the server:

```bash
docker compose down
```

Stop and remove volumes (⚠️ **WARNING**: This deletes your world data):

```bash
docker compose down -v
```

### Viewing Logs

View real-time logs:

```bash
docker compose logs -f mc-server
```

View last 100 lines:

```bash
docker compose logs --tail=100 mc-server
```

## Configuration

### Memory Settings

Adjust JVM memory allocation based on your server resources:

| Players | RAM    | Config                               |
|---------|--------|--------------------------------------|
| 1-5     | 2GB    | `MEMORY_MIN=1024M MEMORY_MAX=2048M` |
| 5-10    | 4GB    | `MEMORY_MIN=2048M MEMORY_MAX=4096M` |
| 10-20   | 6GB    | `MEMORY_MIN=3072M MEMORY_MAX=6144M` |
| 20+     | 8GB+   | `MEMORY_MIN=4096M MEMORY_MAX=8192M` |

### Game Settings

Configure gameplay parameters in `.env`:

```bash
# Game mode: survival, creative, adventure, spectator
GAMEMODE=survival

# Difficulty: peaceful, easy, normal, hard
DIFFICULTY=normal

# Enable PvP combat
PVP=true

# Render distance (2-32 chunks)
VIEW_DISTANCE=10
```

## Project Structure

```
minecraft-server/
├── Dockerfile                 # Custom Minecraft server image definition
├── docker-compose.yaml        # Service orchestration configuration
├── .env.example              # Example environment variables (template)
├── .env                      # Actual environment config (not in Git)
├── .gitignore                # Git ignore patterns
├── README.md                 # This file
├── logs/                     # Server logs (volume mount)
└── backups/                  # Backup storage (created manually)
```

## License

This project is created for educational purposes as part of the Developer Academy curriculum.

Minecraft is a trademark of Mojang Studios. This project is not affiliated with or endorsed by Mojang Studios.

By using this software, you agree to the [Minecraft End User License Agreement](https://www.minecraft.net/en-us/eula).

---

**Made with ❤️ for the DA DevSecOps Course**
