# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Build arguments
ARG BUILD_ARCH
ARG BUILD_VERSION

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set environment
ENV LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apk add --no-cache \
    curl \
    jq \
    jpeg-dev \
    zlib-dev \
    freetype-dev \
    lcms2-dev \
    openjpeg-dev \
    tiff-dev \
    tk \
    && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt

# Clone pixoo-rest application (no tags available, using master)
RUN apk add --no-cache git && \
    git clone --depth 1 \
    https://github.com/4ch1m/pixoo-rest.git /tmp/pixoo-rest && \
    cp -r /tmp/pixoo-rest/* /app/ && \
    rm -rf /tmp/pixoo-rest && \
    apk del git

WORKDIR /app

# Copy Home Assistant scripts
COPY run.sh /
COPY entrypoint.sh /
RUN chmod a+x /run.sh /entrypoint.sh

# Add labels
LABEL \
    io.hass.name="Pixoo REST" \
    io.hass.description="RESTful API for Divoom Pixoo LED displays" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="Jan Kampling <jan@kampling.eu>"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl --fail --silent http://localhost:5000/health || exit 1

# Entrypoint (handles both HA and standalone modes)
ENTRYPOINT ["/entrypoint.sh"]