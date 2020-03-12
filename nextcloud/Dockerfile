FROM nextcloud:production-fpm

RUN mkdir -p /usr/share/man/man1 \
    && apt-get update && apt-get install -y \
        supervisor libfcgi-bin \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/log/supervisord /var/run/supervisord

COPY supervisord.conf /etc/supervisor/supervisord.conf

ENV NEXTCLOUD_UPDATE=1

# Enable php fpm status page
RUN set -xe && echo "pm.status_path = /status" >> /usr/local/etc/php-fpm.d/zz-docker.conf

COPY ./php-fpm-healthcheck /usr/local/bin/

RUN chmod a+x /usr/local/bin/php-fpm-healthcheck

HEALTHCHECK CMD php-fpm-healthcheck --listen-queue=10

CMD ["/usr/bin/supervisord"]
