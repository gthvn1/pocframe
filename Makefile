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
run-proxy:
	cd ethproxy && exec cargo run

run-server:
	cd frameforge && exec dune exec frameforge
