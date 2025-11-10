# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2025-11-10

### Added
- Upgraded to pixoo-rest v2.0.0 with FastAPI and modern Python architecture
- FastAPI/Uvicorn server stack replacing Flask/Gunicorn
- Modern Python package structure with proper module organization
- Comprehensive API documentation with OpenAPI/Swagger UI
- Health check endpoint at `/health` returning device status
- **Ingress support** - Access add-on securely through Home Assistant UI (+2 security points)
- **AppArmor profile** (`apparmor.txt`) - Custom security profile for enhanced protection (+1 security point)
- **Icon and logo** - Professional Pixoo-themed graphics for add-on store presentation
- **Translations** - English translations for all configuration options (`translations/en.yaml`)
- **Codenotary signing** - Container image verification for supply chain security
- Port 5000 remains available for external API access alongside Ingress
- Minimum Home Assistant version requirement (2024.1.0)
- Stage flag set to `stable` for production-ready release

### Changed
- **BREAKING**: Migrated from Flask to FastAPI framework
- **BREAKING**: Server now runs with Uvicorn instead of Gunicorn
- Updated Dockerfile to clone from `master` branch (modernized codebase)
- Updated entrypoint.sh to support FastAPI/Uvicorn in standalone mode
- Updated run.sh to use `uvicorn pixoo_rest.app:app` for Home Assistant mode
- Application structure now uses `/app/pixoo_rest/` package directory
- API endpoint organization now follows FastAPI best practices:
  - `/draw/*` for drawing operations
  - `/set/*` for device control
  - `/download/*` for content downloading
  - `/divoom/*` for cloud API access
- Enhanced error handling and response validation
- Improved logging with structured output
- Version bumped from 0.1.0 to 0.2.0 across all configuration files
- **Security score improved from 5/6 to 8/6** (Base 5 + Ingress +2 + AppArmor +1)

### Fixed
- Fixed entrypoint.sh compatibility with modernized application structure
- Corrected application file detection from `/app/app.py` to `/app/pixoo_rest/`
- Updated server startup command to use proper FastAPI module path

### Security
- AppArmor profile restricts add-on capabilities and file system access
- Codenotary signing ensures container image authenticity
- Ingress provides authentication through Home Assistant
- Port 5000 can be used externally when needed for automation tools

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
