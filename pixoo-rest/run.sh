#!/usr/bin/with-contenv bashio

set -e

bashio::log.info "Reading Config from Home Asssitant Addon..."
export PIXOO_HOST=$(bashio::config 'PIXOO_HOST')
export PIXOO_DEBUG=$(bashio::config 'PIXOO_DEBUG') 
export PIXOO_SCREEN_SIZE=$(bashio::config 'PIXOO_SCREEN_SIZE')

# Start Pixoo Rest server
bashio::log.info "Starting Pixoo-Rest server..."
cd /usr/app/ || exit; gunicorn --bind 0.0.0.0:5000 app:app