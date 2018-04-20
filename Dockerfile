FROM alpine:3.7

RUN set -ex \
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
    iperf \
    nmap \
    nmap-nping \
    conntrack-tools \
    socat \
    busybox-extras \
    tcptraceroute \
    mtr \
    fping \
    liboping \
    iptraf-ng \
    dhcping \
    nmap-nping \
    net-snmp-tools \
    python2 \
    py2-virtualenv \
    py-crypto \
    scapy \
    vim
# apparmor issue #14140
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

ADD netgen.sh /usr/local/bin/netgen

CMD ["sh"]
