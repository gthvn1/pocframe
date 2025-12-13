#!/bin/sh
set -eu

if [ "$#" -ne 4 ]; then
  echo "usage: $0 NET_IFACE PEER_IFACE CIDR SOCKET" >&2
  exit 1
fi

NET_IFACE="$1"
PEER_IFACE="$2"
CIDR="$3"
SOCKET="$4"

unshare -Urn sh -c "
  # Create veth pair if it doesn't exist
  ip link add ${NET_IFACE} type veth peer name ${PEER_IFACE} 2>/dev/null || true
  ip link set ${NET_IFACE} up
  ip link set ${PEER_IFACE} up
  ip addr add ${CIDR} dev ${NET_IFACE}

  
  # Start tmux session
  tmux new-session -d -s rocframe-session
  tmux split-window -h -t rocframe-session:0
  
  # Start server in right pane
  tmux select-pane -R
  tmux send-keys 'just server' C-m
  
  # Start proxy in left pane after waiting for socket
  tmux select-pane -L
  tmux send-keys 'while [ ! -S ${SOCKET} ]; do sleep 0.1; done; just proxy' C-m
    
  # Attach to session
  tmux attach -t rocframe-session
"
