CXX	:= g++
FLAGS	:= -std=c++11 -Wall -Og -g
OBJDIR  := obj-pc
RTLD	:= ../verilog
VERILATOR_ROOT = /usr/share/verilator
VROOT   := $(VERILATOR_ROOT)
EXT_UART_DIR := ../../external/wbuart32/bench/cpp
INCS	:= -I$(RTLD)/obj_dir/ -I$(VROOT)/include -I/usr/lib/SDL2 -I$(EXT_UART_DIR)
EXT_SRCS := uartsim.cpp
SHARED_SOURCES := testbench.cpp tracebench.cpp clientuart.cpp
SOURCES := $(SHARED_SOURCES) $(EXT_UART_DIR)/uartsim.cpp main_txrx.cpp 
HEADERS := tracebench.h testbench.h clientuart.h $(EXT_UART_DIR)/uartsim.h
VOBJDR	:= $(RTLD)/obj_dir
SYSVDR	:= $(VROOT)/include
## }}}

# Verilator's generated Makefile sets VM_*
-include $(VOBJDR)/Vtesttxrx_classes.mk
VSRC	:= $(addsuffix .cpp, $(VM_GLOBAL_FAST) $(VM_GLOBAL_SLOW))
VLIB	:= $(addprefix $(OBJDIR)/,$(subst .cpp,.o,$(VSRC)))

$(OBJDIR)/%.o: %.cpp
	$(mk-objdir)
	$(CXX) $(FLAGS) $(INCS) -DTESTTX -c $< -o $@

$(OBJDIR)/%.o: $(SYSVDR)/%.cpp
	$(mk-objdir)
	$(CXX) $(FLAGS) $(INCS) -c $< -o $@

$(OBJDIR)/%.o: $(EXT_UART_DIR)/%.cpp
	$(mk-objdir)
	$(CXX) $(FLAGS) $(INCS) -c $< -o $@

# Sources necessary to build (uart test)
TXRXSRCS := $(SHARED_SOURCES) main_txrx.cpp
TXRXOBJ := $(subst .cpp,.o,$(EXT_SRCS)) $(subst .cpp,.o,$(TXRXSRCS)) 
TXRXOBJS:= $(addprefix $(OBJDIR)/,$(TXRXOBJ)) $(VLIB)
testtxrx: $(TXRXOBJS) $(VOBJDR)/Vtesttxrx__ALL.a 
	$(CXX) $(FLAGS) $(INCS) $^ -lpthread -lSDL2 -o $@

define	build-depends
	$(mk-objdir)
	@echo "Building dependency file"
	@$(CXX) $(FLAGS) $(INCS) -MM $(SOURCES) $(HEADERS) > $(OBJDIR)/xdepends.txt
	@sed -e 's/^.*.o: /$(OBJDIR)\/&/' < $(OBJDIR)/xdepends.txt > $(OBJDIR)/depends.txt
	@rm $(OBJDIR)/xdepends.txt
endef

.PHONY: depends
depends:
	$(build-depends)

$(OBJDIR)/depends.txt: depends

#
define	mk-objdir
	@bash -c "if [ ! -e $(OBJDIR) ]; then mkdir -p $(OBJDIR); fi"
endef

#
# The "tags" target
#
tags:	$(SOURCES) $(HEADERS)
	@echo "Generating tags"
	@ctags $(SOURCES) $(HEADERS)

.PHONY: clean
clean:
	rm -f ./testtxrx
	rm -rf $(OBJDIR)/

ifneq ($(MAKECMDGOALS),clean)
-include $(OBJDIR)/depends.txt
endif

