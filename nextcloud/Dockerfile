FROM nextcloud:production-fpm

RUN mkdir -p /usr/share/man/man1 \
    && apt-get update && apt-get install -y \
        supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/log/supervisord /var/run/supervisord

COPY supervisord.conf /etc/supervisor/supervisord.conf

ENV NEXTCLOUD_UPDATE=1

HEALTHCHECK --interval=5m --timeout=5s \
    CMD curl -f $(hostname -i || echo '127.0.0.1')/status.php || exit 1

CMD ["/usr/bin/supervisord"]
