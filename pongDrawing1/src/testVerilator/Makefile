VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`
VINC_PATH = -I/usr/share/verilator/include
BUILD_DIR = ./obj_dir

pong: pong.exe

SRCS = testbench.cpp renderbench.cpp
OBJS = $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(SRCS))

%.exe: %.mk
	make -C $(BUILD_DIR) -f Vtop_$<

%.mk: ../top_%.sv
	mkdir -p $(BUILD_DIR)
	verilator ${VFLAGS} -I.. $(VINC_PATH) \
		-cc $< --exe $(SRCS) main_$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "${SDL_CFLAGS}" -DSIMULATED -LDFLAGS "${SDL_LDFLAGS}"
	
clean:
	rm -rf $(BUILD_DIR) 

.PHONY: all clean
