ARG BUILD_FROM
FROM $BUILD_FROM

# FROM python:3.10-alpine3.18 as python

ENV LANG C.UTF-8
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" \
    >> /etc/apk/repositories
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" \
    >> /etc/apk/repositories

RUN apk add --update-cache --no-cache \
    git \
    python3 \
    py-pip \
    libxml2-dev libxslt-dev libffi-dev gcc musl-dev libgcc openssl-dev curl \
    jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev jq \
    && pip install virtualenv \
    && rm -rf /var/cache/apk/*

WORKDIR /usr/app

RUN git clone --recurse-submodules https://github.com/kmplngj/pixoo-rest.git .

WORKDIR /usr/app

RUN pip install \
    --root-user-action=ignore \
    --no-cache-dir \
    --upgrade \
    --requirement requirements.txt

RUN pip install \
    --root-user-action=ignore \
    --no-cache-dir \
    --upgrade \
    --requirement pixoo/requirements.txt 

LABEL Description="pixoo-rest"

HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl --fail --silent http://localhost:5000 || exit 1

COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]