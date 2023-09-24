VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`

pong: pong.exe

#SRCS = testbench.cpp
#OBJS = $(SRCS:.cpp=.o)

%.exe: %.mk
	make -C ./obj_dir -f Vtop_$<

#%.o: $(SRCS)
#	$(CXX) $(CXXFLAGS) -Iobj_dir -I/usr/share/verilator/include -c $< -o $@

%.mk: ../top_%.sv
	verilator ${VFLAGS} -I.. -I/usr/share/verilator/include \
		-cc $< --exe main_$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "${SDL_CFLAGS}" -DSIMULATED -LDFLAGS "${SDL_LDFLAGS}"

clean:
	rm -rf ./obj_dir

.PHONY: all clean
