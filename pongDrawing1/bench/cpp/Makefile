CXX	:= g++
FLAGS	:= -std=c++11 -Wall -Og -g
OBJDIR  := obj-pc
RTLD	:= ../verilog
VERILATOR_ROOT = /usr/share/verilator
VROOT   := $(VERILATOR_ROOT)
INCS	:= -I$(RTLD)/obj_dir/ -I$(VROOT)/include -I/usr/lib/SDL2
SOURCES := main_pong.cpp uartrxtx.cpp testbench.cpp tracebench.cpp uartsim.cpp #render.cpp
HEADERS := uartrxtx.h tracebench.h testbench.h uartsim.h #render.h
VOBJDR	:= $(RTLD)/obj_dir
SYSVDR	:= $(VROOT)/include
## }}}
all:	$(OBJDIR)/ testtx

# Verilator's generated Makefile sets VM_*
-include $(VOBJDR)/Vtesttx_classes.mk
VSRC	:= $(addsuffix .cpp, $(VM_GLOBAL_FAST) $(VM_GLOBAL_SLOW))
VLIB	:= $(addprefix $(OBJDIR)/,$(subst .cpp,.o,$(VSRC)))

$(OBJDIR)/uartsim.o: uartsim.cpp uartsim.h
#$(OBJDIR)/render.o: render.cpp render.h
$(OBJDIR)/uartrxtx.o: uartrxtx.cpp uartrxtx.h
$(OBJDIR)/tracebench.o: tracebench.cpp tracebench.h

$(OBJDIR)/%.o: %.cpp
	$(mk-objdir)
	$(CXX) $(FLAGS) $(INCS) -c $< -o $@

$(OBJDIR)/%.o: $(SYSVDR)/%.cpp
	$(mk-objdir)
	$(CXX) $(FLAGS) $(INCS) -c $< -o $@

## Hello World
# Sources necessary to build the testtx test (txuart test)
HLOOBJ := $(subst .cpp,.o,$(SOURCES))
HLOOBJS:= $(addprefix $(OBJDIR)/,$(HLOOBJ)) $(VLIB)
testtx: $(HLOOBJS) $(VOBJDR)/Vtesttx__ALL.a
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
	rm -f ./testtx 
	rm -rf $(OBJDIR)/

ifneq ($(MAKECMDGOALS),clean)
-include $(OBJDIR)/depends.txt
endif

