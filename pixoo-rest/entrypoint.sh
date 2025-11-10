#!/usr/bin/env bash
set -e

# Standalone Docker entrypoint for pixoo-rest
# This bypasses Home Assistant Supervisor dependencies

echo "======================================"
echo "  Pixoo REST - Standalone Mode"
echo "======================================"
echo ""

# Check if running in Home Assistant Supervisor
if [ -n "${SUPERVISOR_TOKEN}" ]; then
    echo "Running in Home Assistant mode, using run.sh..."
    exec /run.sh
fi

# Standalone mode - use environment variables directly
echo "Configuration:"
echo "  PIXOO_HOST: ${PIXOO_HOST:-not set}"
echo "  PIXOO_SCREEN_SIZE: ${PIXOO_SCREEN_SIZE:-64}"
echo "  PIXOO_DEBUG: ${PIXOO_DEBUG:-false}"
echo "  PIXOO_REST_DEBUG: ${PIXOO_REST_DEBUG:-false}"
echo "  PIXOO_CONNECTION_RETRIES: ${PIXOO_CONNECTION_RETRIES:-10}"
echo ""

# Validate PIXOO_HOST is set
if [ -z "${PIXOO_HOST}" ]; then
    echo "ERROR: PIXOO_HOST environment variable is required"
    echo "Please set it in your docker-compose.yml or with -e PIXOO_HOST=<ip>"
    exit 1
fi

# Export required variables
export PIXOO_HOST
export PIXOO_SCREEN_SIZE="${PIXOO_SCREEN_SIZE:-64}"
export PIXOO_DEBUG="${PIXOO_DEBUG:-false}"
export PIXOO_CONNECTION_RETRIES="${PIXOO_CONNECTION_RETRIES:-10}"

# Verify app directory exists
if [ ! -f "/app/app.py" ]; then
    echo "ERROR: pixoo-rest application files not found in /app"
    echo "Container may not have been built correctly"
    exit 1
fi

cd /app || {
    echo "ERROR: Failed to change to /app directory"
    exit 1
}

echo "Pixoo REST v1.6.0 ready"
echo ""

# Start Gunicorn server
echo "Starting Pixoo REST server on port 5000..."
echo ""

GUNICORN_OPTS="--bind 0.0.0.0:5000"
GUNICORN_OPTS="${GUNICORN_OPTS} --workers 1"
GUNICORN_OPTS="${GUNICORN_OPTS} --timeout 120"
GUNICORN_OPTS="${GUNICORN_OPTS} --access-logfile -"
GUNICORN_OPTS="${GUNICORN_OPTS} --error-logfile -"

if [ "${PIXOO_REST_DEBUG}" = "true" ]; then
    GUNICORN_OPTS="${GUNICORN_OPTS} --log-level debug"
else
    GUNICORN_OPTS="${GUNICORN_OPTS} --log-level info"
fi

# shellcheck disable=SC2086
exec gunicorn ${GUNICORN_OPTS} app:app
