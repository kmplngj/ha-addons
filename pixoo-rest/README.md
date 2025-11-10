# # Home Assistant Add-on: Pixoo REST

[![Release][release-shield]][release] [![License][license-shield]](LICENSE)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

RESTful API to easily interact with Wi-Fi enabled Divoom Pixoo LED displays, including automatic device discovery and seamless Home Assistant integration.

## About

This add-on provides a REST API to control Divoom Pixoo devices (16x16, 32x32, and 64x64 pixel LED displays). It wraps the [pixoo-rest](https://github.com/4ch1m/pixoo-rest) application and integrates it seamlessly into Home Assistant.

**Features:**

- 🔍 **Automatic Device Discovery** - Finds your Pixoo device on the local network automatically
- 🎨 **Full API Control** - 50+ endpoints for images, text, animations, and more
- 📱 **Swagger UI** - Interactive API documentation at `http://[HOST]:5000`
- 🏠 **Home Assistant Integration** - Easy REST commands and automations
- 🖼️ **Image Support** - Display custom images, GIFs, and animations
- ⏱️ **Timers & Countdowns** - Built-in timer and countdown functionality
- 🌡️ **Sensor Data** - Display temperature, humidity, and other sensor values
- 🎵 **Visualizations** - Sound spectrum analyzer and visualizer effects

## Installation

1. Add this repository to your Home Assistant add-on store:
   ```
   https://github.com/kmplngj/ha-addons
   ```

2. Install the "Pixoo REST" add-on

3. Configure the add-on (see Configuration section)

4. Start the add-on

5. Access the Swagger UI at `http://homeassistant.local:5000`

## Configuration

### Minimal Configuration (Automatic Discovery)

```yaml
PIXOO_HOST_AUTO: true
PIXOO_SCREEN_SIZE: 64
```

### Manual Configuration

```yaml
PIXOO_HOST_AUTO: false
PIXOO_HOST: "192.168.1.100"
PIXOO_SCREEN_SIZE: 64
PIXOO_DEBUG: false
PIXOO_CONNECTION_RETRIES: 10
PIXOO_REST_DEBUG: false
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `PIXOO_HOST_AUTO` | bool | `true` | Enable automatic device discovery |
| `PIXOO_HOST` | string | `null` | Manual IP address (required if auto is `false`) |
| `PIXOO_SCREEN_SIZE` | list | `64` | Screen size: `16`, `32`, or `64` pixels |
| `PIXOO_DEBUG` | bool | `false` | Enable debug logging for Pixoo library |
| `PIXOO_CONNECTION_RETRIES` | int | `10` | Connection retry attempts (1-30) |
| `PIXOO_REST_DEBUG` | bool | `false` | Enable REST API debug logging |

## Usage Examples

### Display Custom Text

```bash
curl -X POST http://homeassistant.local:5000/device/text \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Hello!",
    "position": 0,
    "color": "#FF0000",
    "font": 3
  }'
```

### Show Image from URL

```bash
curl -X POST http://homeassistant.local:5000/device/image/url \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com/image.jpg"
  }'
```

### Home Assistant Automation

```yaml
automation:
  - alias: "Display temperature on Pixoo"
    trigger:
      - platform: state
        entity_id: sensor.living_room_temperature
    action:
      - service: rest_command.pixoo_text
        data:
          text: "{{ states('sensor.living_room_temperature') }}°C"
```

See [DOCS.md](DOCS.md) for complete documentation and more examples.

## API Documentation

Interactive API documentation is available via Swagger UI at:
```
http://[HOST]:5000
```

For detailed information about all available endpoints, see [AGENTS.md](../AGENTS.md).

## Support

- **Issues:** [GitHub Issues](https://github.com/kmplngj/ha-addons/issues)
- **Upstream Project:** [pixoo-rest](https://github.com/4ch1m/pixoo-rest)
- **Pixoo Library:** [pixoo](https://github.com/SomethingWithComputers/pixoo)

## Credits

- **pixoo-rest** by [@4ch1m](https://github.com/4ch1m)
- **pixoo library** by [@SomethingWithComputers](https://github.com/SomethingWithComputers)

## License

MIT License - see [LICENSE](../LICENSE) for details.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[license-shield]: https://img.shields.io/github/license/kmplngj/ha-addons.svg
[release-shield]: https://img.shields.io/badge/version-0.1.0-blue.svg
[release]: https://github.com/kmplngj/ha-addons/releases/tag/v0.1.0
