.PHONY: all ethproxy frameforge clean

all: ethproxy frameforge

ethproxy:
	cd ethproxy && cargo build

frameforge:
	cd frameforge && dune build

clean:
	cd ethproxy && cargo clean
	cd frameforge && dune clean
