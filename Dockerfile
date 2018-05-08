FROM alpine:3.7

RUN set -ex \
    && echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
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
    vim \
    bird \
    bash 

# apparmor issue #14140
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

# Installing calicoctl
RUN wget https://github.com/projectcalico/calicoctl/releases/download/v3.1.1/calicoctl && chmod +x calicoctl && mv calicoctl /usr/local/bin

# Netgen
ADD netgen.sh /usr/local/bin/netgen

# Settings
ADD motd /etc/motd
ADD profile  /etc/profile

CMD ["/bin/bash","-l"]
