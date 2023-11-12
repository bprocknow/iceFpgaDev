
all: rtl bench

rtl:
	cd rtl ; $(MAKE)

bench: rtl
	cd bench/verilog ; $(MAKE)
	cd bench/cpp ; $(MAKE)

clean:
	cd rtl ; $(MAKE) clean
	cd bench/verilog ; $(MAKE) clean
	cd bench/cpp ; $(MAKE) clean
