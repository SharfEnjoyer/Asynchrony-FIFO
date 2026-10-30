`include "rtl/sync_fifo/sync_fifo.sv"
`default_nettype none

module tb_sync_fifo;
localparam width = 4;
localparam depth = 8;
logic clk;
logic rst_n;

logic [width - 1:0] in_data;
logic [width - 1:0] out_data;

sync_fifo 
# (
    .width(width),
    .depth(depth)
)
sync_fifo_inst (   
    .rst (rst_n),
    .clk (clk),
    .out_data (out_data),
    .in_data (in_data)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_sync_fifo.vcd");
    $dumpvars(0, tb_sync_fifo);
end

logic [width - 1:0] data[] = {11,10,13,10, 14,15,10,10, 11,12,13,14};

initial begin
    #1 rst_n <= 1'bx; clk <= 1'bx;
    #(CLK_PERIOD * 3) rst_n <= 1;
    #(CLK_PERIOD * 3) rst_n <= 0; clk <= 0;
    repeat(5) @(posedge clk);
    rst_n <= 1;
    @(posedge clk);

    rst_n <= 0;

    for (int i = 0; i < 30; i++) begin
        @(posedge clk);
        in_data <= data[i];
    end

    repeat(2) @(posedge clk);
    $finish(2);
end

endmodule
// `default_nettype wire