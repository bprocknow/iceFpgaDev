.PHONY: all
.DELETE_ON_ERROR:
YYMMDD=`date +%Y%m%d`
CXX   := g++
FBDIR := .
VDIRFB:= $(FBDIR)/obj_dir
RTLDR := ../../rtl
VERILATOR := verilator
VFLAGS := -Wall --MMD --trace -y $(RTLDR) -cc
UART_EXT := ../../external/wbuart32/rtl
HW_EXT_SRC := ../../external/wbuart32/bench/verilog/helloworld.v

.PHONY: testtxrx
all: testtxrx 

testtxrx:      $(VDIRFB)/Vtesttxrx__ALL.a

$(VDIRFB)/Vtesttxrx__ALL.a:     $(VDIRFB)/Vtesttxrx.cpp

## Verilate build instructions
$(VDIRFB)/V%.mk:  $(VDIRFB)/V%.h
$(VDIRFB)/V%.h:   $(VDIRFB)/V%.cpp
$(VDIRFB)/V%.cpp: $(FBDIR)/%.v
	$(VERILATOR) $(VFLAGS) $*.v

$(VDIRFB)/Vtesttxrx.cpp: $(FBDIR)/testtxrx.v
	$(VERILATOR) $(VFLAGS) -I$(UART_EXT) --prefix Vtesttxrx testtxrx.v

## Turn C++ to libraries
$(VDIRFB)/V%__ALL.a: $(VDIRFB)/V%.cpp
	cd $(VDIRFB); make -f V$*.mk

## TAGS
tags: $(wildcard *.v) $(wildcard $(RTLDR)/*.v)
	ctags *.v $(RTLDR)/*.v

## Clean
.PHONY: clean
clean:
	rm -rf tags $(VDIRFB)/

## Automatic dependency handling
DEPS := $(wildcard $(VDIRFB)/*.d)

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(DEPS),)
include $(DEPS)
endif
endif

