`timescale 1ns / 1ps


module DMA_TB;

	// Inputs
	reg clk = 0, reset = 1, start = 0;
    reg [15:0] src_addr = 16'h0000;
    reg [15:0] dst_addr = 16'h0100;
    reg [15:0] length   = 16'd4;

	// Outputs
	reg [7:0] mem [0:255];
	wire [7:0] mem_data_in;
    wire [7:0] mem_data_out;
    wire [15:0] mem_addr;
    wire mem_read, mem_write;
    wire done;
	 
	 always #5 clk = ~clk;

    assign mem_data_in = mem[mem_addr];

    always @(posedge clk)
        if (mem_write)
            mem[mem_addr] <= mem_data_out;
	// Instantiate the Unit Under Test (UUT)
	DMA uut (
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.src_addr(src_addr), 
		.dst_addr(dst_addr), 
		.length(length), 
		.mem_data_in(mem_data_in), 
		.mem_data_out(mem_data_out), 
		.mem_addr(mem_addr), 
		.mem_read(mem_read), 
		.mem_write(mem_write), 
		.done(done)
	);
	always @(posedge done)
    $display("DMA TRANSFER COMPLETED at time %0t", $time);
	 
	initial begin
    $display("========================================");
    $display(" DMA CONTROLLER - TEXT OUTPUT (ISim)");
    $display("========================================");
    $display("Time(ns)\tAddr\tData\tOperation");
 forever begin
        @(posedge clk);
        if (mem_write) begin
            $display("%0t\t%h\t%h\tWRITE",
                     $time, mem_addr, mem_data_out);
        end
    end
end

	initial begin
		// Initialize Inputs
		 mem[0] = 8'hAA;
        mem[1] = 8'hBB;
        mem[2] = 8'hCC;
        mem[3] = 8'hDD;

        #10 reset = 0;
        #10 start = 1;
        #10 start = 0;
		   #200 $stop;

	end
      
endmodule
