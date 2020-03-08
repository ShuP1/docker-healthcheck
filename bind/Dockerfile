FROM debian:testing-slim

LABEL maintainer="me@wadza.fr"

ENV BIND_USER=bind \
    DATA_DIR=/data

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      bind9 bind9-host dnsutils

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]

