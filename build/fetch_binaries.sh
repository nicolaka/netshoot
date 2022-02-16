#!/usr/bin/env bash
set -euo pipefail

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}


ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH=amd64
        ;;
    aarch64)
        ARCH=arm64
        ;;
esac

get_ctop() {
  TERM_ARCH=$ARCH
  if [ "$ARCH" == "armv7l" ]; then
    TERM_ARCH=arm
  fi
  VERSION=$(get_latest_release bcicen/ctop | sed -e 's/^v//')
  LINK="https://github.com/bcicen/ctop/releases/download/${VERSION}/ctop-${VERSION}-linux-${TERM_ARCH}"
  wget "$LINK" -O /tmp/ctop && chmod +x /tmp/ctop
}

get_calicoctl() {
  if [ "$ARCH" != "armv7l" ]; then
    VERSION=$(get_latest_release projectcalico/calicoctl)
    LINK="https://github.com/projectcalico/calicoctl/releases/download/${VERSION}/calicoctl-linux-${ARCH}"
    wget "$LINK" -O /tmp/calicoctl && chmod +x /tmp/calicoctl
  fi
}

get_termshark() {
  VERSION=$(get_latest_release gcla/termshark | sed -e 's/^v//')
  if [ "$ARCH" == "amd64" ]; then
    TERM_ARCH=x64
  elif [ "$ARCH" == "armv7l" ]; then
    TERM_ARCH=armv6
  else
    TERM_ARCH="$ARCH"
  fi
  LINK="https://github.com/gcla/termshark/releases/download/v${VERSION}/termshark_${VERSION}_linux_${TERM_ARCH}.tar.gz"
  wget "$LINK" -O /tmp/termshark.tar.gz && \
  tar -zxvf /tmp/termshark.tar.gz && \
  mv "termshark_${VERSION}_linux_${TERM_ARCH}/termshark" /tmp/termshark && \
  chmod +x /tmp/termshark
}

get_ctop
get_calicoctl
get_termshark
