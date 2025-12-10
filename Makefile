.PHONY: all ethproxy frameforge clean run-proxy run-server

all: ethproxy frameforge

ethproxy:
	cd ethproxy && cargo build

frameforge:
	cd frameforge && dune build

clean:
	cd ethproxy && cargo clean
	cd frameforge && dune clean

# Use `exec` so the shell running this recipe is replaced by the server process.
# This prevents `make` from printing "Interrupt" when we stop the server with Ctrl-C.
run-proxy: ethproxy
	exec sudo ./ethproxy/target/debug/ethproxy

run-server: frameforge
	exec ./frameforge/_build/default/bin/main.exe
