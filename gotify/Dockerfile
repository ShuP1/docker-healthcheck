FROM gotify/server

RUN set -ex \
    && apk add --no-cache curl

HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -s -f $(hostname -i || echo '127.0.0.1')/health || exit 1

COPY config.yml /etc/gotify/config.yml