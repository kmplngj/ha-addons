#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

# Load configuration
bashio::log.info "Loading configuration from Home Assistant add-on..."

PIXOO_HOST_AUTO=$(bashio::config 'PIXOO_HOST_AUTO')
PIXOO_DEBUG=$(bashio::config 'PIXOO_DEBUG')
PIXOO_SCREEN_SIZE=$(bashio::config 'PIXOO_SCREEN_SIZE')
PIXOO_CONNECTION_RETRIES=$(bashio::config 'PIXOO_CONNECTION_RETRIES')
PIXOO_REST_DEBUG=$(bashio::config 'PIXOO_REST_DEBUG')

# Export environment variables
export PIXOO_DEBUG
export PIXOO_SCREEN_SIZE
export PIXOO_CONNECTION_RETRIES

# Device discovery and validation
if [ "${PIXOO_HOST_AUTO}" = true ]; then
    bashio::log.info "Starting automatic device discovery..."
    
    DISCOVERY_URL="https://app.divoom-gz.com/Device/ReturnSameLANDevice"
    DISCOVERY_RESULT=$(curl -s -X POST "${DISCOVERY_URL}" || echo "")
    
    if [ -z "${DISCOVERY_RESULT}" ]; then
        bashio::log.error "Failed to connect to Divoom discovery service"
        bashio::log.error "Please check your internet connection or set PIXOO_HOST manually"
        exit 1
    fi
    
    DEVICE_IP=$(echo "${DISCOVERY_RESULT}" | jq -r '.DeviceList[0].DevicePrivateIP // empty')
    
    if [ -z "${DEVICE_IP}" ] || [ "${DEVICE_IP}" = "null" ]; then
        bashio::log.error "No Pixoo device found on local network"
        bashio::log.error "Make sure your device is powered on and connected to WiFi"
        bashio::log.info "You can also manually set PIXOO_HOST in the configuration"
        exit 1
    fi
    
    PIXOO_HOST="${DEVICE_IP}"
    bashio::log.info "Discovered Pixoo device at: ${PIXOO_HOST}"
else
    PIXOO_HOST=$(bashio::config 'PIXOO_HOST')
    
    if [ -z "${PIXOO_HOST}" ]; then
        bashio::log.error "PIXOO_HOST is not configured"
        bashio::log.error "Either enable PIXOO_HOST_AUTO or provide a valid PIXOO_HOST"
        exit 1
    fi
    
    bashio::log.info "Using manually configured device: ${PIXOO_HOST}"
fi

# Validate host format (basic IP validation)
if ! echo "${PIXOO_HOST}" | grep -qE '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'; then
    bashio::log.warning "PIXOO_HOST does not appear to be a valid IP address: ${PIXOO_HOST}"
fi

export PIXOO_HOST

# Log configuration summary
bashio::log.info "===== Pixoo REST Configuration ====="
bashio::log.info "Device IP: ${PIXOO_HOST}"
bashio::log.info "Screen Size: ${PIXOO_SCREEN_SIZE}"
bashio::log.info "Debug Mode: ${PIXOO_DEBUG}"
bashio::log.info "Connection Retries: ${PIXOO_CONNECTION_RETRIES}"
bashio::log.info "REST Debug: ${PIXOO_REST_DEBUG}"
bashio::log.info "===================================="

# Change to app directory
cd /app || {
    bashio::log.error "Failed to change to /app directory"
    exit 1
}

# Download pixoo-rest application
bashio::log.info "Downloading pixoo-rest application..."
PIXOO_REST_VERSION="1.6.0"
PIXOO_REST_URL="https://github.com/4ch1m/pixoo-rest/archive/refs/tags/${PIXOO_REST_VERSION}.tar.gz"

if ! curl -sL "${PIXOO_REST_URL}" | tar xz --strip-components=1; then
    bashio::log.error "Failed to download pixoo-rest ${PIXOO_REST_VERSION}"
    exit 1
fi

bashio::log.info "Successfully downloaded pixoo-rest ${PIXOO_REST_VERSION}"

# Start Gunicorn server
bashio::log.info "Starting Pixoo REST server on port 5000..."

GUNICORN_OPTS="--bind 0.0.0.0:5000"
GUNICORN_OPTS="${GUNICORN_OPTS} --workers 1"
GUNICORN_OPTS="${GUNICORN_OPTS} --timeout 120"
GUNICORN_OPTS="${GUNICORN_OPTS} --access-logfile -"
GUNICORN_OPTS="${GUNICORN_OPTS} --error-logfile -"

if [ "${PIXOO_REST_DEBUG}" = true ]; then
    GUNICORN_OPTS="${GUNICORN_OPTS} --log-level debug"
else
    GUNICORN_OPTS="${GUNICORN_OPTS} --log-level info"
fi

# shellcheck disable=SC2086
exec gunicorn ${GUNICORN_OPTS} app:app
