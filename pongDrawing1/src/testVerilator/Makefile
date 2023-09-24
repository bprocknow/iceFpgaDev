VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`
VINC_PATH = -I/usr/share/verilator/include
BUILD_DIR = ./obj_dir

pong: pong.exe

SRCS = testbench

#%.exe: %.mk $(SRCS).o
#	make -C ./obj_dir -f Vtop_$<
%.exe: %.mk
	make -C $(BUILD_DIR) -f Vtop_$<

#%.o: $(SRCS).cpp
#	$(CXX) $(CXXFLAGS) -I.. -I/usr/include/SDL2 $(VINC_PATH) -c $< -o ./obj_dir/$@

%.mk: ../top_%.sv
	mkdir -p $(BUILD_DIR)
	verilator ${VFLAGS} -I.. $(VINC_PATH) \
		-cc $< --exe $(SRCS).cpp main_$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "${SDL_CFLAGS}" -DSIMULATED -LDFLAGS "${SDL_LDFLAGS}"
	$(CXX) $(CXXFLAGS) -I$(BUILD_DIR) -I/usr/include/SDL2 $(VINC_PATH) -c $(SRCS).cpp -o $(BUILD_DIR)/$(SRCS).o

clean:
	rm -rf $(BUILD_DIR) 

.PHONY: all clean
