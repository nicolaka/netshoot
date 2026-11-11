FROM debian:stable-slim AS fetcher
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*
COPY build/fetch_binaries.sh /tmp/fetch_binaries.sh
RUN chmod +x /tmp/fetch_binaries.sh && /tmp/fetch_binaries.sh

FROM alpine:3.24.4

ARG VERSION=dev
ARG OMZ_SHA=b509b1c6ed0c1ba37de12cbd37f30b2b2f61193a
ARG ZSH_AUTOSUGGESTIONS_VERSION=0.7.1
ARG POWERLEVEL10K_VERSION=1.20.0

LABEL org.opencontainers.image.title="netshoot" \
      org.opencontainers.image.description="Docker and Kubernetes network troubleshooting swiss-army container" \
      org.opencontainers.image.source="https://github.com/nicolaka/netshoot" \
      org.opencontainers.image.version="${VERSION}"

# trippy and swaks are only published in Alpine edge/testing. Tag that repo so
# the rest of the image stays on Alpine 3.24 main/community.
RUN echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
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
    file \
    fping \
    gcompat \
    git \
    httpie \
    iftop \
    iperf \
    iperf3 \
    iproute2 \
    ipset \
    iptables \
    iptraf-ng \
    iputils \
    ipvsadm \
    jq \
    liboping \
    ltrace \
    mtr \
    net-snmp-tools \
    netcat-openbsd \
    nftables \
    ngrep \
    nmap \
    nmap-nping \
    nmap-scripts \
    openssl \
    openssh \
    perl-crypt-ssleay \
    perl-net-ssleay \
    py3-pip \
    py3-setuptools \
    scapy \
    socat \
    speedtest-cli \
    strace \
    swaks@testing \
    tcpdump \
    tcptraceroute \
    trippy@testing \
    tshark \
    util-linux \
    vim \
    websocat \
    zsh

COPY --from=fetcher /tmp/ctop /usr/local/bin/ctop
COPY --from=fetcher /tmp/termshark /usr/local/bin/termshark
COPY --from=fetcher /tmp/grpcurl /usr/local/bin/grpcurl
COPY --from=fetcher /tmp/fortio /usr/local/bin/fortio
COPY build/smoke.sh /usr/local/bin/netshoot-smoke

USER root
WORKDIR /root
ENV HOSTNAME=netshoot

COPY shell/zshrc /root/.zshrc
COPY shell/motd /root/motd.template

RUN curl -fsSL "https://github.com/ohmyzsh/ohmyzsh/archive/${OMZ_SHA}.tar.gz" | tar -xz -C /tmp \
    && mv "/tmp/ohmyzsh-${OMZ_SHA}" /root/.oh-my-zsh \
    && mkdir -p /root/.oh-my-zsh/custom/plugins /root/.oh-my-zsh/custom/themes \
    && curl -fsSL "https://github.com/zsh-users/zsh-autosuggestions/archive/refs/tags/v${ZSH_AUTOSUGGESTIONS_VERSION}.tar.gz" | tar -xz -C /tmp \
    && mv "/tmp/zsh-autosuggestions-${ZSH_AUTOSUGGESTIONS_VERSION}" /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && curl -fsSL "https://github.com/romkatv/powerlevel10k/archive/refs/tags/v${POWERLEVEL10K_VERSION}.tar.gz" | tar -xz -C /tmp \
    && mv "/tmp/powerlevel10k-${POWERLEVEL10K_VERSION}" /root/.oh-my-zsh/custom/themes/powerlevel10k \
    && sed "s/__VERSION__/${VERSION}/g" /root/motd.template > /root/motd \
    && rm /root/motd.template \
    && chmod -R g=u /root \
    && chmod +x /usr/local/bin/netshoot-smoke \
    && chown root:root /usr/bin/dumpcap

CMD ["zsh"]
