#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
  echo "usage: $0 NET_IFACE CIDR" >&2
  exit 1
fi

NET_IFACE="$1"
CIDR="$2"

PEER_IFACE="${NET_IFACE}-peer"
PID_FILENAME="/tmp/rocframe-ns.pid"
rm -f "${PID_FILENAME}"

unshare -Urn sh -c "
  echo \$\$ > ${PID_FILENAME}

  # Create veth pair if it doesn't exist
  ip link add ${NET_IFACE} type veth peer name ${PEER_IFACE} 2>/dev/null || true

  # Bring interface up
  ip link set ${NET_IFACE} up
  ip link set ${PEER_IFACE} up

  # Assign IP to main interface (peer IP will be managed by server)
  ip addr add ${CIDR} dev ${NET_IFACE}

  # run interactive shell; remove PID on exit
  sh

  rm -f "${PID_FILENAME}"
"
