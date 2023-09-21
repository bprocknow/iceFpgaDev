# Example iCEBreaker Makefile
# Learn more at https://projectf.io/posts/building-ice40-fpga-toolchain/

# configuration
SHELL = /bin/sh
FPGA_PKG = sg48
FPGA_TYPE = up5k
PCF = icebreaker.pcf

SRC_NAME = top_hello

# included modules
ADD_SRC = $(SRC_NAME).v

my_project: $(SRC_NAME).rpt $(SRC_NAME).bin

%.json: $(SRC_NAME).v
	yosys -ql $(basename $@)-yosys.log -p \
	    'synth_ice40 -top $(basename $@) -json $@' $(ADD_SRC)

%.asc: %.json
	nextpnr-ice40 --${FPGA_TYPE} --package ${FPGA_PKG} --json $< --pcf ${PCF} --asc $@

%.rpt: %.asc
	icetime -d ${FPGA_TYPE} -mtr $@ $<

%.bin: %.asc
	icepack $< $(subst top_,,$@)

all: my_project

clean:
	rm -f $(SRC_NAME)*.json $(SRC_NAME)*.asc $(SRC_NAME)*.rpt *.bin $(SRC_NAME)*yosys.log

.PHONY: all clean
