#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

set -e

bashio::log.info "Reading Config from Home Asssitant Addon..."
PIXOO_HOST_AUTO=$(bashio::config 'PIXOO_HOST_AUTO')
PIXOO_DEBUG=$(bashio::config 'PIXOO_DEBUG') 
export PIXOO_DEBUG
PIXOO_SCREEN_SIZE=$(bashio::config 'PIXOO_SCREEN_SIZE')
export PIXOO_SCREEN_SIZE

if [ $PIXOO_HOST_AUTO = True ] 
then
	PIXOO_HOST=$(curl -X POST "https://app.divoom-gz.com/Device/ReturnSameLANDevice" | jq .DeviceList[0].DevicePrivateIP)
else
	PIXOO_HOST=$(bashio::config 'PIXOO_HOST')
fi
export PIXOO_HOST

# Start Pixoo Rest server
bashio::log.info "Starting Pixoo-Rest server..."
cd /usr/app/ || exit; gunicorn --bind 0.0.0.0:5000 app:app
