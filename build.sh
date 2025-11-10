#!/usr/bin/env bash
set -e

# Pixoo REST Docker Build Script
# Builds the Pixoo REST add-on Docker image for local testing

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
BUILD_ARCH="${BUILD_ARCH:-amd64}"
BUILD_VERSION="${BUILD_VERSION:-0.1.0-dev}"
IMAGE_NAME="${IMAGE_NAME:-pixoo-rest}"
IMAGE_TAG="${IMAGE_TAG:-dev}"
BASE_IMAGE_VERSION="${BASE_IMAGE_VERSION:-3.13-alpine3.20}"

# Determine base image based on architecture
case "$BUILD_ARCH" in
  amd64)
    BASE_IMAGE="ghcr.io/home-assistant/amd64-base-python:${BASE_IMAGE_VERSION}"
    ;;
  aarch64)
    BASE_IMAGE="ghcr.io/home-assistant/aarch64-base-python:${BASE_IMAGE_VERSION}"
    ;;
  armv7)
    BASE_IMAGE="ghcr.io/home-assistant/armv7-base-python:${BASE_IMAGE_VERSION}"
    ;;
  armhf)
    BASE_IMAGE="ghcr.io/home-assistant/armhf-base-python:${BASE_IMAGE_VERSION}"
    ;;
  i386)
    BASE_IMAGE="ghcr.io/home-assistant/i386-base-python:${BASE_IMAGE_VERSION}"
    ;;
  *)
    echo -e "${RED}Error: Unsupported architecture: $BUILD_ARCH${NC}"
    echo "Supported: amd64, aarch64, armv7, armhf, i386"
    exit 1
    ;;
esac

echo -e "${GREEN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      Pixoo REST Docker Build Script          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo "  Architecture:  $BUILD_ARCH"
echo "  Base Image:    $BASE_IMAGE"
echo "  Build Version: $BUILD_VERSION"
echo "  Image Name:    $IMAGE_NAME:$IMAGE_TAG"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
  echo -e "${RED}Error: Docker is not running${NC}"
  echo "Please start Docker Desktop or the Docker daemon"
  exit 1
fi

echo -e "${YELLOW}Building Docker image...${NC}"
docker build \
  --build-arg BUILD_FROM="$BASE_IMAGE" \
  --build-arg BUILD_ARCH="$BUILD_ARCH" \
  --build-arg BUILD_VERSION="$BUILD_VERSION" \
  -t "$IMAGE_NAME:$IMAGE_TAG" \
  -t "$IMAGE_NAME:latest" \
  ./pixoo-rest

if [ $? -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✓ Build successful!${NC}"
  echo ""
  echo -e "${YELLOW}Image Details:${NC}"
  docker images "$IMAGE_NAME" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
  echo ""
  echo -e "${YELLOW}Run with Docker:${NC}"
  echo "  docker run -d -p 5000:5000 -e PIXOO_HOST=192.168.1.100 $IMAGE_NAME:$IMAGE_TAG"
  echo ""
  echo -e "${YELLOW}Or use Docker Compose:${NC}"
  echo "  docker compose up -d"
  echo ""
else
  echo -e "${RED}✗ Build failed${NC}"
  exit 1
fi
