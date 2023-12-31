# Example iCEBreaker Makefile
# Learn more at https://projectf.io/posts/building-ice40-fpga-toolchain/

# configuration
SHELL = /bin/sh
FPGA_PKG = sg48
FPGA_TYPE = up5k
PCF = icebreaker.pcf

SRC_NAME = top_graphicsprocessor

# included modules
ADD_SRC = display_signal.sv pix_clk.sv render.sv DataAggregator.sv synchronizer.sv CommandBuffer.sv framebuf_manager.sv RAM256X32.sv RAM256X12.sv
ADD_SRC += ../external/wbuart32/rtl/txuart.v
ADD_SRC += ../external/wbuart32/rtl/rxuart.v

my_project: $(SRC_NAME).rpt $(SRC_NAME).bin

%.json: $(SRC_NAME).sv $(ADD_SRC)
	yosys -ql $(basename $@)-yosys.log -p \
	    'synth_ice40 -top $(basename $@) -json $@' $< $(ADD_SRC)

%.asc: %.json
	nextpnr-ice40 --${FPGA_TYPE} --package ${FPGA_PKG} --json $< --pcf ${PCF} --asc $@

%.rpt: %.asc
	icetime -d ${FPGA_TYPE} -mtr $@ $<

%.bin: %.asc
	icepack $< $(subst top_,,$@)

all: my_project

clean:
	rm -f *.json *.asc *.rpt *.bin *yosys.log

.PHONY: all clean
