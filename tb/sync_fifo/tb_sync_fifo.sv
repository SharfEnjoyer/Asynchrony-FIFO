`include "rtl/sync_fifo/sync_fifo.sv"
`default_nettype none

module tb_sync_fifo;
localparam width = 4;
localparam depth = 8;
logic clk;
logic rst_n;

logic [width - 1:0] in_data;
logic [width - 1:0] out_data;

logic in_vld;
logic in_ready;
logic out_vld;
logic out_ready;
logic empty;
logic full;
logic almost_full;
logic almost_empty;

sync_fifo 
# (
    .width(width),
    .depth(depth)
)
uut (   
    .clk(clk),
    .rst(rst_n),
    .in_vld(in_vld),
    .in_ready(in_ready),
    .in_data(in_data),
    .out_vld(out_vld),
    .out_ready(out_ready),
    .out_data(out_data),
    .empty(empty),
    .full(full),
    .almost_empty(almost_empty),
    .almost_full(almost_full)
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
    in_ready <= 0;
    for (int i = 0; i < 30; i++) begin
        @(posedge clk);
        if(out_ready) begin
            in_vld <= 1;
            in_data <= width' ($urandom());
        end
        // if(full) begin
        //     in_ready <= 1;
        // end
    end
    in_vld <= 0;

    if(!empty) begin
        in_ready <= 1;
    end
    repeat(depth) @(posedge clk);
    in_ready <= 0;
    in_vld <= 0;
    repeat(20) @(posedge clk);
    $finish(2);
end

endmodule
// `default_nettype wire