# Docker Compose Setup for Pixoo REST

This directory contains a Docker Compose configuration for running the Pixoo REST add-on standalone (outside of Home Assistant).

## Prerequisites

- Docker Engine 20.10+
- Docker Compose V2
- A Divoom Pixoo device on your local network

## Quick Start

1. **Create environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` file:**
   ```bash
   # Set your Pixoo device IP address
   PIXOO_HOST=192.168.1.100
   
   # Adjust screen size if needed (16, 32, or 64)
   PIXOO_SCREEN_SIZE=64
   ```

3. **Start the service:**
   ```bash
   docker compose up -d
   ```

4. **Access Swagger UI:**
   ```
   http://localhost:5001
   ```
   
   **Note:** Port 5001 is used by default to avoid conflicts with macOS AirPlay (which uses port 5000). You can change this in `.env` by setting `PIXOO_REST_PORT`.

## Building the Image

To build the Docker image locally:

```bash
docker compose build
```

Or build manually:

```bash
docker build \
  --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base-python:3.13-alpine3.20 \
  --build-arg BUILD_ARCH=amd64 \
  --build-arg BUILD_VERSION=dev \
  -t pixoo-rest:dev \
  ./pixoo-rest
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PIXOO_HOST` | `192.168.1.100` | IP address of your Pixoo device |
| `PIXOO_SCREEN_SIZE` | `64` | Screen size (16, 32, or 64) |
| `PIXOO_DEBUG` | `false` | Enable Pixoo library debug logging |
| `PIXOO_REST_DEBUG` | `false` | Enable REST API debug logging |
| `PIXOO_CONNECTION_RETRIES` | `10` | Connection retry attempts (1-30) |
| `TZ` | `Europe/Berlin` | Timezone for the container |

### Finding Your Pixoo Device IP

**Option 1: Router DHCP List**
- Check your router's admin panel for connected devices
- Look for "Pixoo" or "Divoom" in the device list

**Option 2: Divoom Mobile App**
- Open the Divoom app
- Go to device settings
- Find "Device Information" or "Network Settings"

**Option 3: Network Scan**
```bash
# Using nmap
nmap -sn 192.168.1.0/24 | grep -B 2 Pixoo

# Using arp-scan (Linux)
sudo arp-scan --localnet | grep -i divoom
```

## Usage Examples

### View Logs

```bash
docker compose logs -f pixoo-rest
```

### Restart Service

```bash
docker compose restart
```

### Stop Service

```bash
docker compose down
```

### Update and Restart

```bash
docker compose pull
docker compose up -d
```

## Testing the API

### Using curl

```bash
# Display text
curl -X POST http://localhost:5001/text \
  -d "text=Hello Docker!&x=10&y=10&r=0&g=255&b=0&push_immediately=true"

# Set brightness (0-100)
curl -X PUT http://localhost:5001/brightness/75

# Fill screen with color
curl -X POST http://localhost:5001/fill \
  -d "r=255&g=0&b=0&push_immediately=true"
```

### Using Python

```python
import requests

API_URL = "http://localhost:5001"

# Display text
response = requests.post(
    f"{API_URL}/text",
    data={
        "text": "Hello from Python!",
        "x": 10,
        "y": 10,
        "r": 255,
        "g": 0,
        "b": 0,
        "push_immediately": "true"
    }
)
print(response.status_code)
```

## Health Check

The service includes a health check endpoint:

```bash
curl http://localhost:5001/health
```

Health check runs every 30 seconds and will restart the container if it fails 3 times.

## Troubleshooting

### Container Won't Start

1. **Check logs:**
   ```bash
   docker compose logs pixoo-rest
   ```

2. **Verify environment variables:**
   ```bash
   docker compose config
   ```

3. **Check Pixoo device connectivity:**
   ```bash
   ping <PIXOO_HOST>
   ```

### API Returns 404

- Ensure the container is running: `docker compose ps`
- Check if port 5001 is exposed: `docker compose port pixoo-rest 5000`
- Verify no other service is using port 5001: `lsof -i :5001` (macOS/Linux)
- On macOS, port 5000 is used by AirPlay - that's why we use 5001 by default

### Device Not Responding

1. Verify device IP hasn't changed
2. Check device is powered on and connected to WiFi
3. Try accessing device from Divoom mobile app
4. Consider setting static IP or DHCP reservation for your Pixoo

### Permission Denied Errors

On Linux, you may need to run with elevated privileges:

```bash
sudo docker compose up -d
```

Or add your user to the docker group:

```bash
sudo usermod -aG docker $USER
# Log out and back in for changes to take effect
```

## Architecture Support

The Docker image supports multiple architectures:

- **amd64** (x86_64) - Most desktop computers
- **aarch64** (ARM64) - Raspberry Pi 4, Apple Silicon Macs
- **armv7** - Raspberry Pi 3 and similar
- **armhf** - Older ARM devices
- **i386** - 32-bit x86 systems

The compose file will automatically use the correct architecture for your system.

## Advanced Configuration

### Custom Port Mapping

Edit `compose.yml`:

```yaml
ports:
  - "8080:5000"  # Map to port 8080 instead
```

### Multiple Pixoo Devices

Create multiple service entries in `compose.yml`:

```yaml
services:
  pixoo-rest-1:
    # ... configuration for first device
    ports:
      - "5001:5000"
    environment:
      PIXOO_HOST: 192.168.1.100

  pixoo-rest-2:
    # ... configuration for second device
    ports:
      - "5002:5000"
    environment:
      PIXOO_HOST: 192.168.1.101
```

### Using with Traefik/Nginx Proxy

Add labels for reverse proxy:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.pixoo.rule=Host(`pixoo.local`)"
  - "traefik.http.services.pixoo.loadbalancer.server.port=5000"
```

## Performance Tuning

### Gunicorn Workers

The service uses 1 worker by default. To increase (edit `run.sh` in the container):

```bash
gunicorn --workers 2 --bind 0.0.0.0:5000 app:app
```

### Resource Limits

Add to `compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 256M
    reservations:
      memory: 128M
```

## Upgrading

To upgrade to the latest version:

1. Pull the latest code:
   ```bash
   git pull
   ```

2. Rebuild and restart:
   ```bash
   docker compose down
   docker compose build --no-cache
   docker compose up -d
   ```

## Uninstalling

Remove the service and cleanup:

```bash
docker compose down -v
docker rmi pixoo-rest:dev
```

## Support

- **Documentation:** [AGENTS.md](AGENTS.md)
- **Issues:** [GitHub Issues](https://github.com/kmplngj/ha-addons/issues)
- **Upstream:** [pixoo-rest](https://github.com/4ch1m/pixoo-rest)

## License

MIT License - see [LICENSE](LICENSE) for details.
