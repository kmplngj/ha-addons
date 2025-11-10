# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - 2025-11-10

### Added
- Complete modernization of add-on infrastructure
- Updated to pixoo-rest v1.6.0 (cloned from GitHub during Docker build)
- Docker Compose configuration for standalone deployment (compose.yml)
- Standalone mode support with entrypoint.sh for running outside Home Assistant
- Environment variable template (.env.example)
- Comprehensive Docker Compose documentation (DOCKER_COMPOSE.md)
- Enhanced configuration with new options:
  - `PIXOO_CONNECTION_RETRIES`: Configure connection retry attempts (1-30, default: 10)
  - `PIXOO_REST_DEBUG`: Enable REST API debug logging
  - Support for 32x32 screen size in addition to 16x16 and 64x64
- Improved device discovery with better error handling and validation
- Enhanced logging with detailed configuration summary
- Comprehensive API documentation in AGENTS.md
- Detailed upgrade and implementation plan in UPGRADE_PLAN.md
- Health check endpoint support
- Panel icon and title in Home Assistant sidebar

### Changed
- Updated base images to Python 3.13 on Alpine 3.20
- Modernized Dockerfile with git clone approach (no release tags available)
- Added tk package for pixoo library compatibility
- Default port changed to 5001 to avoid macOS AirPlay conflict on port 5000
- Improved run.sh with robust error handling and validation
- Enhanced config.yaml with proper schema validation
- Better health check with longer timeout (10s vs 3s)
- Dual-mode entrypoint supporting both Home Assistant and standalone deployments

### Fixed
- Fixed automatic device discovery error handling
- Improved IP address validation
- Better startup error messages and troubleshooting guidance

## [0.0.2] - Previous Release

### Initial
- Basic pixoo-rest integration
- Automatic device discovery
- Manual device configuration option
- Basic debug and screen size settings

## [0.0.1] - Initial Alpha Release

- Initial alpha release

---

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
