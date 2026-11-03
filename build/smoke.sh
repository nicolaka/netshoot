#!/bin/sh
set -eu

fail=0
check() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "ok  $1"
  else
    echo "missing  $1" >&2
    fail=1
  fi
}

check ab
check bash
check bird
check bridge
check conntrack
check ctop
check curl
check dhcping
check dig
check drill
check ethtool
check file
check fortio
check fping
check grpcurl
check http
check iftop
check ip
check iperf
check iperf3
check ipset
check iptables
check iptraf-ng
check ipvsadm
check jq
check ltrace
check mtr
check nc
check nft
check ngrep
check nmap
check nping
check openssl
check ping
check socat
check ss
check strace
check swaks
check tcpdump
check tcptraceroute
check termshark
check trip
check tshark
check vim
check websocat
check zsh

if python3 -c 'import scapy' >/dev/null 2>&1; then
  echo "ok  scapy"
else
  echo "missing  scapy" >&2
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  echo "smoke test failed" >&2
  exit 1
fi

echo "smoke test passed"
