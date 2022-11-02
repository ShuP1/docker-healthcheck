FROM debian:buster-slim

LABEL maintainer="me@wadza.fr"

ENV INSTALL_KEY 379CE192D401AB61
ENV DEB_DISTRO buster

RUN apt-get update && apt-get install -y curl jq

RUN apt-get update && apt-get install -y gnupg1 apt-transport-https dirmngr && \
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY && \
        echo "deb https://ookla.bintray.com/debian ${DEB_DISTRO} main" | tee /etc/apt/sources.list.d/speedtest.list && \
        apt-get update && \
        apt-get install speedtest

COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

