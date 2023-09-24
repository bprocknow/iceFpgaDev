VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`

rectangle: rectangle.exe

%.exe: %.mk
	make -C ./obj_dir -f Vtop_$<

%.mk: ../top_%.sv
	verilator ${VFLAGS} -I.. -I/usr/share/verilator/include \
		-cc $< --exe main_$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "${SDL_CFLAGS}" -DSIMULATED -LDFLAGS "${SDL_LDFLAGS}"

clean:
	rm -rf ./obj_dir

.PHONY: all clean
