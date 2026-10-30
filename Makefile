TB      ?= tb/sync_fifo/tb_sync_fifo.sv
OUT     ?= build/a.out
IVERILOG ?= iverilog
FLAGS   ?= -g2012 -Wall

.PHONY: tb build clean

tb: run

build: | $(BUILD)
	$(IVERILOG) $(FLAGS) -o $(OUT) $(TB)

run: build
	cd build && vvp a.out

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm -rf $(BUILD)