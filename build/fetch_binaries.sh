#!/usr/bin/env bash
set -euo pipefail

ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH=amd64 ;;
  aarch64) ARCH=arm64 ;;
  *)
    echo "unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

download() {
  local url="$1" dest="$2" sha="$3"
  curl -fsSL --retry 3 --retry-delay 2 -o "$dest" "$url"
  echo "${sha}  ${dest}" | sha256sum -c -
}

CTOP_VERSION=0.7.7
TERMSHARK_VERSION=2.4.0
GRPCURL_VERSION=1.9.4
FORTIO_VERSION=1.76.0

get_ctop() {
  local sha
  case "$ARCH" in
    amd64) sha=b78374734ebe3d14b6edee3d5512c911c250d7fa7f3f964cb00acd3bc5a02a09 ;;
    arm64) sha=d8d91e0fea53a8c78fa81192f078272e5a92f0ea6c4f0e38ec7c944d76e6f02f ;;
  esac
  download \
    "https://github.com/bcicen/ctop/releases/download/v${CTOP_VERSION}/ctop-${CTOP_VERSION}-linux-${ARCH}" \
    /tmp/ctop "$sha"
  chmod +x /tmp/ctop
}

get_termshark() {
  local term_arch sha
  case "$ARCH" in
    amd64)
      term_arch=x64
      sha=a28b2ab534ba8bf2297bbe9846281e62aa0010832b75773369e0d48912acef74
      ;;
    arm64)
      term_arch=arm64
      sha=6dc3003a48291c463f057d0151727e0d21e295d804f082f3d35d72fd94d0a56e
      ;;
  esac
  download \
    "https://github.com/gcla/termshark/releases/download/v${TERMSHARK_VERSION}/termshark_${TERMSHARK_VERSION}_linux_${term_arch}.tar.gz" \
    /tmp/termshark.tar.gz "$sha"
  tar -zxvf /tmp/termshark.tar.gz
  mv "termshark_${TERMSHARK_VERSION}_linux_${term_arch}/termshark" /tmp/termshark
  chmod +x /tmp/termshark
}

get_grpcurl() {
  local term_arch sha
  case "$ARCH" in
    amd64)
      term_arch=x86_64
      sha=97e13d58d2733a0e62cd2571d1d5f0c02823f0d25282f08bddedf1ad9c5d1736
      ;;
    arm64)
      term_arch=arm64
      sha=ad66227d90631da5428b4a5ccf28d63846f0f15649d8b2367df044a59edbb617
      ;;
  esac
  download \
    "https://github.com/fullstorydev/grpcurl/releases/download/v${GRPCURL_VERSION}/grpcurl_${GRPCURL_VERSION}_linux_${term_arch}.tar.gz" \
    /tmp/grpcurl.tar.gz "$sha"
  tar --no-same-owner -zxvf /tmp/grpcurl.tar.gz
  mv grpcurl /tmp/grpcurl
  chmod +x /tmp/grpcurl
  chown root:root /tmp/grpcurl
}

get_fortio() {
  local sha
  case "$ARCH" in
    amd64) sha=cb5907d2ff3b9bfe76d62c69f141d0b25b1d41c1b4c04c8434e8c0166a55844a ;;
    arm64) sha=5258719ab9b2515a53f2435d4eb59364b4ebcaf61166de06959ed44fc4b8440d ;;
  esac
  download \
    "https://github.com/fortio/fortio/releases/download/v${FORTIO_VERSION}/fortio-linux_${ARCH}-${FORTIO_VERSION}.tgz" \
    /tmp/fortio.tgz "$sha"
  tar -zxvf /tmp/fortio.tgz
  mv usr/bin/fortio /tmp/fortio
  chmod +x /tmp/fortio
}

get_ctop
get_termshark
get_grpcurl
get_fortio
