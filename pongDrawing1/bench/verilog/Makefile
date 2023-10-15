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

.PHONY: testpong
all: testpong 

testpong:      $(VDIRFB)/Vtestpong__ALL.a

$(VDIRFB)/Vtestpong__ALL.a:     $(VDIRFB)/Vtestpong.cpp

## Verilate build instructions
#$(VDIRFB)/V%.mk:  $(VDIRFB)/V%.h
#$(VDIRFB)/V%.h:   $(VDIRFB)/V%.cpp
#$(VDIRFB)/V%.cpp: $(FBDIR)/%.v
#	$(VERILATOR) $(VFLAGS) $*.v

$(VDIRFB)/Vtestpong.cpp: $(FBDIR)/testpong.sv
	$(VERILATOR) $(VFLAGS) -DSIMULATED -I. -I$(UART_EXT) --prefix Vtestpong testpong.sv

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

