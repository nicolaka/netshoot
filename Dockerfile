FROM alpine:3.11

RUN set -ex \
    && echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
    apache2-utils \
    bash \
    bind-tools \
    bird \
    bridge-utils \
    busybox-extras \
    conntrack-tools \
    curl \
    dhcping \
    drill \
    ethtool \
    file\
    fping \
    httpie \
    iftop \
    iperf \
    iproute2 \
    ipset \
    iptables \ 
    iptraf-ng \
    iputils \
    ipvsadm \
    jq \
    libc6-compat \
    liboping \
    mtr \
    net-snmp-tools \
    netcat-openbsd \
    nftables \
    ngrep \
    nmap \
    nmap-nping \
    openssl \
    py-crypto \
    scapy \
    socat \
    strace \
    tcpdump \
    tcptraceroute \
    tshark \
    util-linux \
    vim \
    websocat


# apparmor issue #14140
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

# Installing ctop - top-like container monitor
RUN wget https://github.com/bcicen/ctop/releases/download/v0.7.1/ctop-0.7.1-linux-amd64 -O /usr/local/bin/ctop && chmod +x /usr/local/bin/ctop

# Installing calicoctl
ARG CALICOCTL_VERSION=v3.13.3
RUN wget https://github.com/projectcalico/calicoctl/releases/download/${CALICOCTL_VERSION}/calicoctl && chmod +x calicoctl && mv calicoctl /usr/local/bin

# Installing termshark
ENV TERMSHARK_VERSION 2.1.1
RUN wget https://github.com/gcla/termshark/releases/download/v${TERMSHARK_VERSION}/termshark_${TERMSHARK_VERSION}_linux_x64.tar.gz -O /tmp/termshark_${TERMSHARK_VERSION}_linux_x64.tar.gz && \
    tar -zxvf /tmp/termshark_${TERMSHARK_VERSION}_linux_x64.tar.gz && \
    mv termshark_${TERMSHARK_VERSION}_linux_x64/termshark /usr/local/bin/termshark && \
    chmod +x /usr/local/bin/termshark

# Installing gRPCurl
ENV GRPCURL_VERSION 1.6.0
RUN wget https://github.com/fullstorydev/grpcurl/releases/download/v${GRPCURL_VERSION}/grpcurl_${GRPCURL_VERSION}_linux_x86_64.tar.gz -O /tmp/grpcurl_${GRPCURL_VERSION}_linux_x86_64.tar.gz && \
    mkdir ./grpcurl_${GRPCURL_VERSION}_linux_x86_64 && \
    tar -zxvf /tmp/grpcurl_${GRPCURL_VERSION}_linux_x86_64.tar.gz -C grpcurl_${GRPCURL_VERSION}_linux_x86_64/ && \
    mv grpcurl_${GRPCURL_VERSION}_linux_x86_64/grpcurl /usr/local/bin/grpcurl && \
    chmod +x /usr/local/bin/grpcurl

# Installing ghz
ENV GHZ_VERSION 0.55.0
RUN wget https://github.com/bojand/ghz/releases/download/v${GHZ_VERSION}/ghz-linux-x86_64.tar.gz -O /tmp/ghz-linux-x86_64.tar.gz && \
    mkdir ./ghz_${GHZ_VERSION} && \
    tar -zxvf /tmp/ghz-linux-x86_64.tar.gz -C ghz_${GHZ_VERSION}/ && \
    mv ghz_${GHZ_VERSION}/ghz /usr/local/bin/ghz && \
    rm ghz_${GHZ_VERSION}/ghz-web && \
    chmod +x /usr/local/bin/ghz

# Settings
ADD motd /etc/motd
ADD profile  /etc/profile

CMD ["/bin/bash","-l"]
