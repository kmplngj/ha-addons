# Pixoo REST Add-on Documentation

Complete documentation for the Pixoo REST Home Assistant add-on.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Configuration](#configuration)
- [API Usage](#api-usage)
- [Home Assistant Integration](#home-assistant-integration)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

## Overview

The Pixoo REST add-on provides a RESTful API to control Divoom Pixoo LED displays (16x16, 32x32, and 64x64 pixels). It enables you to:

- Display custom images and GIFs
- Show text with various fonts and colors
- Control brightness and screen rotation
- Display sensor data and visualizations
- Create countdown timers and stopwatches
- Play animations and effects

## Installation

### Step 1: Add Repository

Add this repository to your Home Assistant instance:

1. Go to **Settings** → **Add-ons** → **Add-on Store**
2. Click the three dots (⋮) in the top right
3. Select **Repositories**
4. Add: `https://github.com/kmplngj/ha-addons`
5. Click **Add**

### Step 2: Install Add-on

1. Find "Pixoo REST" in the add-on store
2. Click on it and press **Install**
3. Wait for the installation to complete

### Step 3: Configure

See the [Configuration](#configuration) section below.

### Step 4: Start

1. Click **Start** to run the add-on
2. Enable **Start on boot** if desired
3. Enable **Watchdog** for automatic restart on failure

## Configuration

### Quick Start (Automatic Discovery)

The simplest configuration uses automatic device discovery:

```yaml
PIXOO_HOST_AUTO: true
PIXOO_SCREEN_SIZE: 64
```

### Manual Configuration

If automatic discovery doesn't work, specify the IP address manually:

```yaml
PIXOO_HOST_AUTO: false
PIXOO_HOST: "192.168.1.100"
PIXOO_SCREEN_SIZE: 64
```

### Complete Configuration Example

```yaml
PIXOO_HOST_AUTO: false
PIXOO_HOST: "192.168.1.100"
PIXOO_DEBUG: true
PIXOO_SCREEN_SIZE: 64
PIXOO_CONNECTION_RETRIES: 15
PIXOO_REST_DEBUG: true
```

### Configuration Options Reference

#### PIXOO_HOST_AUTO

- **Type:** Boolean
- **Default:** `true`
- **Description:** Enable automatic device discovery via Divoom cloud service
- **When to use manual:** If you have network restrictions or firewall rules blocking external requests

#### PIXOO_HOST

- **Type:** String (IP address)
- **Default:** `null`
- **Required:** Only when `PIXOO_HOST_AUTO` is `false`
- **Example:** `"192.168.1.100"`
- **Description:** Manual IP address of your Pixoo device

**Finding your Pixoo IP:**
1. Check your router's DHCP client list
2. Use the Divoom mobile app (Settings → Device Information)
3. Check Home Assistant's network discovery

#### PIXOO_SCREEN_SIZE

- **Type:** Integer
- **Options:** `16`, `32`, `64`
- **Default:** `64`
- **Description:** Pixel dimensions of your Pixoo device
- **Models:**
  - 16: Pixoo-16
  - 32: Pixoo-32 (rare model)
  - 64: Pixoo-64, Pixoo-Max

#### PIXOO_DEBUG

- **Type:** Boolean
- **Default:** `false`
- **Description:** Enable debug logging for the Pixoo Python library
- **Use case:** Troubleshooting device communication issues

#### PIXOO_CONNECTION_RETRIES

- **Type:** Integer
- **Range:** 1-30
- **Default:** `10`
- **Description:** Number of retry attempts when connecting to the device
- **Recommendation:** Increase if your device is slow to respond or on a congested network

#### PIXOO_REST_DEBUG

- **Type:** Boolean
- **Default:** `false`
- **Description:** Enable debug logging for the REST API (Gunicorn)
- **Use case:** Troubleshooting API requests and responses

## API Usage

### Accessing the API

The API is available at: `http://homeassistant.local:5000`

Interactive Swagger documentation: `http://homeassistant.local:5000`

### Authentication

No authentication is required. The API is accessible on your local network.

### Common Endpoints

#### Display Text

```bash
curl -X POST http://homeassistant.local:5000/device/text \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Hello World",
    "position": 0,
    "color": "#FF0000",
    "font": 3
  }'
```

**Parameters:**
- `text`: String to display
- `position`: Y-position (0 = top)
- `color`: Hex color code
- `font`: Font ID (0-7)

#### Display Image from URL

```bash
curl -X POST http://homeassistant.local:5000/device/image/url \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com/image.jpg"
  }'
```

#### Set Brightness

```bash
curl -X POST http://homeassistant.local:5000/device/brightness \
  -H "Content-Type: application/json" \
  -d '{
    "brightness": 75
  }'
```

**Range:** 0-100

#### Clear Screen

```bash
curl -X POST http://homeassistant.local:5000/device/screen/clear
```

#### Start Countdown

```bash
curl -X POST http://homeassistant.local:5000/device/countdown \
  -H "Content-Type: application/json" \
  -d '{
    "minutes": 5,
    "seconds": 0
  }'
```

### Response Format

Successful responses:
```json
{
  "status": "ok",
  "message": "Command executed successfully"
}
```

Error responses:
```json
{
  "error": "Device not reachable",
  "status": "error"
}
```

## Home Assistant Integration

### REST Commands

Add these to your `configuration.yaml`:

```yaml
rest_command:
  pixoo_text:
    url: http://homeassistant.local:5000/device/text
    method: POST
    headers:
      Content-Type: application/json
    payload: >
      {
        "text": "{{ text }}",
        "position": {{ position | default(0) }},
        "color": "{{ color | default('#FFFFFF') }}",
        "font": {{ font | default(3) }}
      }
  
  pixoo_brightness:
    url: http://homeassistant.local:5000/device/brightness
    method: POST
    headers:
      Content-Type: application/json
    payload: >
      {
        "brightness": {{ brightness }}
      }
  
  pixoo_image_url:
    url: http://homeassistant.local:5000/device/image/url
    method: POST
    headers:
      Content-Type: application/json
    payload: >
      {
        "url": "{{ url }}"
      }
  
  pixoo_clear:
    url: http://homeassistant.local:5000/device/screen/clear
    method: POST
```

### Automation Examples

#### Display Temperature

```yaml
automation:
  - alias: "Pixoo - Show Temperature"
    trigger:
      - platform: state
        entity_id: sensor.living_room_temperature
    action:
      - service: rest_command.pixoo_text
        data:
          text: "{{ states('sensor.living_room_temperature') }}°C"
          color: "#00FF00"
          position: 20
          font: 5
```

#### Doorbell Notification

```yaml
automation:
  - alias: "Pixoo - Doorbell Alert"
    trigger:
      - platform: state
        entity_id: binary_sensor.doorbell
        to: "on"
    action:
      - service: rest_command.pixoo_text
        data:
          text: "DOORBELL!"
          color: "#FF0000"
          position: 15
          font: 7
      - delay: "00:00:05"
      - service: rest_command.pixoo_clear
```

#### Brightness by Time of Day

```yaml
automation:
  - alias: "Pixoo - Morning Brightness"
    trigger:
      - platform: time
        at: "07:00:00"
    action:
      - service: rest_command.pixoo_brightness
        data:
          brightness: 80

  - alias: "Pixoo - Evening Brightness"
    trigger:
      - platform: time
        at: "22:00:00"
    action:
      - service: rest_command.pixoo_brightness
        data:
          brightness: 20
```

#### Weather Display

```yaml
automation:
  - alias: "Pixoo - Weather Update"
    trigger:
      - platform: time_pattern
        hours: "/1"  # Every hour
    action:
      - service: rest_command.pixoo_text
        data:
          text: >
            {{ states('weather.home') }}
            {{ state_attr('weather.home', 'temperature') }}°C
          color: "#00AAFF"
          position: 10
          font: 4
```

## Troubleshooting

### Device Not Found (Automatic Discovery)

**Symptoms:** Error message "No Pixoo device found on local network"

**Solutions:**
1. Ensure device is powered on and connected to WiFi
2. Check that device is on the same network as Home Assistant
3. Try manual configuration with IP address
4. Verify firewall isn't blocking external requests to `app.divoom-gz.com`

### Connection Timeout

**Symptoms:** "Failed to connect to device" or timeout errors

**Solutions:**
1. Increase `PIXOO_CONNECTION_RETRIES` to 20-30
2. Verify IP address is correct
3. Check network connectivity: `ping <device-ip>`
4. Restart the Pixoo device
5. Check for IP address changes (consider DHCP reservation)

### API Returns 404

**Symptoms:** API endpoints return 404 Not Found

**Solutions:**
1. Verify the add-on is running (check logs)
2. Check the correct port (5000)
3. Try accessing Swagger UI: `http://homeassistant.local:5000`
4. Restart the add-on

### Images Not Displaying

**Symptoms:** Image endpoint succeeds but nothing shows on device

**Solutions:**
1. Verify image URL is publicly accessible
2. Check image format (JPEG, PNG, GIF supported)
3. Ensure image size is appropriate
4. Try displaying a test image from a known URL
5. Check device logs for errors

### Add-on Won't Start

**Symptoms:** Add-on fails to start or immediately crashes

**Solutions:**
1. Check add-on logs (click "Log" tab)
2. Verify configuration is valid YAML
3. Ensure `PIXOO_HOST` is provided when `PIXOO_HOST_AUTO` is `false`
4. Check `PIXOO_SCREEN_SIZE` is one of: 16, 32, 64
5. Try default configuration first

### Viewing Logs

To view detailed logs:

1. Go to add-on page in Home Assistant
2. Click the **Log** tab
3. Enable **Auto-update**
4. For more detail, enable `PIXOO_DEBUG` and `PIXOO_REST_DEBUG` in configuration

## Advanced Usage

### Custom Python Scripts

```python
import requests

PIXOO_API = "http://homeassistant.local:5000"

def display_message(text, color="#FFFFFF"):
    response = requests.post(
        f"{PIXOO_API}/device/text",
        json={
            "text": text,
            "position": 0,
            "color": color,
            "font": 3
        }
    )
    return response.json()

# Usage
display_message("Hello from Python!", "#00FF00")
```

### Node-RED Integration

Use the **http request** node:

- Method: POST
- URL: `http://homeassistant.local:5000/device/text`
- Payload: JSON
```json
{
  "text": "{{msg.payload}}",
  "color": "#FFFFFF",
  "position": 0,
  "font": 3
}
```

### Shell Scripts

```bash
#!/bin/bash

PIXOO_API="http://homeassistant.local:5000"

# Function to display text
pixoo_text() {
    local text="$1"
    local color="${2:-#FFFFFF}"
    
    curl -s -X POST "$PIXOO_API/device/text" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": \"$text\",
            \"color\": \"$color\",
            \"position\": 0,
            \"font\": 3
        }"
}

# Usage
pixoo_text "System Update" "#FF0000"
```

### Docker Compose (Alternative Deployment)

If you want to run outside Home Assistant:

```yaml
version: '3.8'

services:
  pixoo-rest:
    image: ghcr.io/kmplngj/pixoo-rest:latest
    ports:
      - "5000:5000"
    environment:
      - PIXOO_HOST=192.168.1.100
      - PIXOO_SCREEN_SIZE=64
      - PIXOO_DEBUG=false
    restart: unless-stopped
```

### API Rate Limiting

The Pixoo device can handle approximately:
- **Text updates:** ~10 per second
- **Image updates:** ~2 per second
- **Brightness changes:** ~5 per second

Exceeding these rates may cause command delays or drops.

### Network Performance

For best performance:
- Use wired Ethernet for Home Assistant
- Ensure Pixoo has strong WiFi signal
- Consider 5GHz WiFi for Pixoo if supported
- Minimize network hops between HA and Pixoo

## Support and Resources

- **Add-on Issues:** [GitHub Issues](https://github.com/kmplngj/ha-addons/issues)
- **Upstream Project:** [pixoo-rest](https://github.com/4ch1m/pixoo-rest)
- **Pixoo Library:** [pixoo](https://github.com/SomethingWithComputers/pixoo)
- **API Reference:** See [AGENTS.md](../AGENTS.md)
- **Home Assistant Community:** [Community Forum](https://community.home-assistant.io/)

## License

MIT License - see [LICENSE](../LICENSE) for details
