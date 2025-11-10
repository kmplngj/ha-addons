# Home Assistant Add-ons by kmplngj

[![License][license-shield]](LICENSE)
![Project Maintenance][maintenance-shield]

Custom Home Assistant add-ons repository.

## Installation

Add this repository to your Home Assistant instance:

1. Navigate to **Settings** → **Add-ons** → **Add-on Store**
2. Click the **⋮** (three dots) menu in the top right
3. Select **Repositories**
4. Add this repository URL:
   ```
   https://github.com/kmplngj/ha-addons
   ```
5. Click **Add**
6. Refresh the add-on store
7. Find and install the add-ons you need

## Available Add-ons

### 🎨 [Pixoo REST](pixoo-rest)

[![Version][pixoo-version-shield]][pixoo-changelog]
![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

RESTful API to control Divoom Pixoo LED displays with automatic device discovery and seamless Home Assistant integration.

**Features:**
- 🔍 Automatic device discovery
- 🎨 50+ API endpoints for full control
- 📱 Built-in Swagger UI documentation
- 🖼️ Image, GIF, and animation support
- 📝 Text display with multiple fonts
- ⏱️ Timers and countdowns
- 🌡️ Sensor data visualization

**Quick Start:**
```yaml
PIXOO_HOST_AUTO: true
PIXOO_SCREEN_SIZE: 64
```

[📖 Full Documentation](pixoo-rest/DOCS.md) | [🔧 API Reference](AGENTS.md) | [📋 Changelog](pixoo-rest/CHANGELOG.md)

### 🐋 Standalone Docker Deployment

Want to run Pixoo REST outside of Home Assistant? Use Docker Compose:

```bash
# Clone repository
git clone https://github.com/kmplngj/ha-addons.git
cd ha-addons

# Configure
cp .env.example .env
# Edit .env with your Pixoo device IP

# Start
docker compose up -d

# Access at http://localhost:5001
```

[📖 Docker Compose Guide](DOCKER_COMPOSE.md)

---

## Support

- **Issues:** [GitHub Issues](https://github.com/kmplngj/ha-addons/issues)
- **Discussions:** [GitHub Discussions](https://github.com/kmplngj/ha-addons/discussions)

## Contributing

---

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Credits

### Pixoo REST

This add-on wraps the excellent work of:

- **pixoo-rest** by [@4ch1m](https://github.com/4ch1m) - RESTful API server
- **pixoo library** by [@SomethingWithComputers](https://github.com/SomethingWithComputers) - Python device library

### Home Assistant

Built for the amazing [Home Assistant](https://www.home-assistant.io/) smart home platform.

## License

MIT License - see [LICENSE](LICENSE) for details.

---

**Maintained by [@kmplngj](https://github.com/kmplngj)**

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[license-shield]: https://img.shields.io/github/license/kmplngj/ha-addons.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[pixoo-version-shield]: https://img.shields.io/badge/version-2.0.0-blue.svg
[pixoo-changelog]: pixoo-rest/CHANGELOG.md
