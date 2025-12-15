net_iface := "veth0"
peer_iface := net_iface + "-peer"
cidr := "192.168.35.2/24"
socket := "/tmp/frameforge.sock"

# List recipes
default:
    just --list

# Build the rust proxy
[working-directory: 'ethproxy-rust']
build-rust-proxy:
    @echo 'Building Rusty proxy...'
    cargo build

# Build Zig version of proxy
[working-directory: 'ethproxy-zig']
build-zig-proxy:
    @echo 'Building Ziggy proxy'
    zig build

# Build the server
[working-directory: 'frameforge']
build-server:
    @echo 'Building server...'
    dune build

# Build the proxy and the server
build: build-rust-proxy build-zig-proxy build-server

# Clean the build of proxy and server
clean:
    @echo 'Cleaning Rust proxy'
    cd ethproxy-rust && cargo clean
    @echo 'Cleaning Zig proxy'
    cd ethproxy-zig && rm -rf zig-out
    @echo 'Cleaning server'
    cd frameforge && dune clean

# Start the proxy. Must be run in a shell started with setup-net
rust-proxy:
    # Because we quit using ctrl-c, we prefix the rule with "-"
    # to ignore exit codes. Otherwise, Just reports an error when
    # ctrl-c is received.
    -sh -c 'exec ./ethproxy-rust/target/debug/ethproxy {{peer_iface}} {{socket}}'

# Start Zig proxy
zig-proxy:
    -sh -c 'exec ./ethproxy-zig/zig-out/bin/ethproxy_zig {{peer_iface}} {{socket}}'

# Start server. Must be run in a shell started using setup-net
server:
    -sh -c 'exec ./frameforge/_build/default/bin/main.exe `ip -j a` {{socket}}'

# Set up Veth pair and start a shell.
netns-shell: build
    @echo 'Setting network using {{net_iface}} {{peer_iface}} {{cidr}}'
    @echo 'Use a terminal mux to run server and then zig or rust proxy in the env'
    cd scripts && ./netns_shell.sh {{net_iface}} {{peer_iface}} {{cidr}}
    @echo 'Cleanup env'

# Run the whole workflow in tmux
netns-tmux: build
    @echo 'Starting a full session (server + zig proxy) inside network namespace...'
    cd scripts && ./netns_tmux.sh {{net_iface}} {{peer_iface}} {{cidr}} {{socket}}
    @echo 'Cleanup env'
