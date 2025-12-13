NET_IFACE := "veth0"
CIDR := "192.168.35.2/24"
SOCKET := "/tmp/rocframe.sock"

setup-net:
    ./scripts/netns.sh {{NET_IFACE}} {{CIDR}}

