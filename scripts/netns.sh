#!/bin/sh
set -eu

if [ "$#" -ne 3 ]; then
  echo "usage: $0 NET_IFACE PEER_IFACE CIDR" >&2
  exit 1
fi

NET_IFACE="$1"
PEER_IFACE="$2"
CIDR="$3"

unshare -Urn sh -c "
  # Create veth pair if it doesn't exist
  ip link add ${NET_IFACE} type veth peer name ${PEER_IFACE} 2>/dev/null || true

  # Bring interface up
  ip link set ${NET_IFACE} up
  ip link set ${PEER_IFACE} up

  # Assign IP to main interface (peer IP will be managed by server)
  ip addr add ${CIDR} dev ${NET_IFACE}

  # Start a shell from where you will be able to run zellij, tmux or any mux
  sh
"
