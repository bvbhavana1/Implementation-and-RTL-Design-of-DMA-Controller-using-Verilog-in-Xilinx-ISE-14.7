`timescale 1ns / 1ps

module DMA_TB;

    //====================================================
    // Inputs
    //====================================================
    reg clk;
    reg reset;
    reg start;

    reg [15:0] src_addr;
    reg [15:0] dst_addr;
    reg [15:0] length;
	 //====================================================
    // Simple Memory (512 Bytes)
    //====================================================
    reg [7:0] mem [0:511];

    //====================================================
    // DMA Interface Signals
    //====================================================
    wire [7:0] mem_data_in;
    wire [7:0] mem_data_out;
    wire [15:0] mem_addr;
    wire mem_read;
    wire mem_write;
    wire done;
	  //====================================================
    // Clock Generation (10 ns Period)
    //====================================================
    initial
        clk = 0;

    always
        #5 clk = ~clk;

    //====================================================
    // Memory Read
    //====================================================
    assign mem_data_in = mem[mem_addr];
	 //====================================================
    // Memory Write
    //====================================================
    always @(posedge clk)
    begin
        if(mem_write)
            mem[mem_addr] <= mem_data_out;
    end

    //====================================================
    // Instantiate DMA
    //====================================================
    DMA uut(
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
	 //====================================================
    // Display Header
    //====================================================
    initial
    begin
	  $display("======================================================");
        $display("        DMA CONTROLLER SIMULATION (ISim)");
        $display("======================================================");
        $display(" Time(ns)\tAddress\tData\tOperation");
        $display("------------------------------------------------------");
    end
	 //====================================================
    // Display READ / WRITE Operations
    //====================================================
    always @(posedge clk)
    begin
        if(mem_read)
        begin
            $display("%8t\t%h\t%h\tREAD",
                     $time,
                     mem_addr,
                     mem_data_in);
							 end

        if(mem_write)
        begin
            $display("%8t\t%h\t%h\tWRITE",
                     $time,
                     mem_addr,
                     mem_data_out);
        end
    end
	 //====================================================
    // Display Completion Message
    //====================================================
    always @(posedge done)
    begin
        $display("\nDMA TRANSFER COMPLETED at %0t ns\n",$time);
    end

    //====================================================
    // Test Sequence
	  //====================================================
    initial
    begin

        // Initialize Inputs
        reset = 1;
        start = 0;

        src_addr = 16'h0000;
        dst_addr = 16'h0100;
        length   = 16'd4;
		  // Initialize Memory
        mem[16'h0000] = 8'hAA;
        mem[16'h0001] = 8'hBB;
        mem[16'h0002] = 8'hCC;
        mem[16'h0003] = 8'hDD;

        // Apply Reset
        #10;
        reset = 0;

        // Start DMA
        #10;
        start = 1;

        #10;
        start = 0;
		  
    end

    //====================================================
    // Automatic Verification
    //====================================================
    initial
    begin

        @(posedge done);

        #10;
		   $display("--------------------------------------");
        $display(" Destination Memory Contents");
        $display("--------------------------------------");

        $display("mem[0100] = %h",mem[16'h0100]);
        $display("mem[0101] = %h",mem[16'h0101]);
        $display("mem[0102] = %h",mem[16'h0102]);
        $display("mem[0103] = %h",mem[16'h0103]);
		  if( mem[16'h0100]==8'hAA &&
            mem[16'h0101]==8'hBB &&
            mem[16'h0102]==8'hCC &&
            mem[16'h0103]==8'hDD )
        begin
            $display("\n======================================");
            $display("         DMA TEST PASSED");
            $display("======================================");
        end
        else
        begin
		  $display("\n======================================");
            $display("         DMA TEST FAILED");
            $display("======================================");
        end

        #20;
        $stop;

    end

endmodule