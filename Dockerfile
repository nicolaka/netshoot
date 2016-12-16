FROM alpine:3.4

RUN set -ex \
    && echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
    tcpdump \
    bridge-utils \
    netcat-openbsd \
    util-linux \
    iptables \
    iputils \
    iproute2 \
    iftop \
    drill \
    apache2-utils \
    strace \
    curl \
    ethtool \
    ipvsadm \
    ngrep \
    nmap
# apparmor issue #14140
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

CMD ["sh"]
