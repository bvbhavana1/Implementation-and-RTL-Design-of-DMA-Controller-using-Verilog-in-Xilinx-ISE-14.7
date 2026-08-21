`timescale 1ns / 1ps

module DMA(
    input clk,
    input reset,
    input start,

    input [15:0] src_addr,
    input [15:0] dst_addr,
    input [15:0] length,

    input [7:0] mem_data_in,

    output reg [7:0] mem_data_out,
    output reg [15:0] mem_addr,
    output reg mem_read,
    output reg mem_write,
    output reg done
);
// Internal Registers
    reg [15:0] src_ptr;
    reg [15:0] dst_ptr;
    reg [15:0] count;
    reg [7:0] data_buffer;

    // FSM State Register
    reg [2:0] state;

    // FSM States
    localparam IDLE      = 3'b000,
               READ      = 3'b001,
               READ_WAIT = 3'b010,
               WRITE     = 3'b011,
               DONE      = 3'b100;

    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
		   state        <= IDLE;
            done         <= 1'b0;

            mem_read     <= 1'b0;
            mem_write    <= 1'b0;

            mem_addr     <= 16'd0;
            mem_data_out <= 8'd0;

            src_ptr      <= 16'd0;
            dst_ptr      <= 16'd0;
            count        <= 16'd0;
            data_buffer  <= 8'd0;
        end
        else
        begin

            // Default outputs every clock
				 mem_read  <= 1'b0;
            mem_write <= 1'b0;
            done      <= 1'b0;

            case(state)

                //--------------------------------------------------
                // IDLE
                //--------------------------------------------------
                IDLE:
                begin
                    if(start)
                    begin
						   src_ptr <= src_addr;
                        dst_ptr <= dst_addr;
                        count   <= length;
                        state   <= READ;
                    end
                end

                //--------------------------------------------------
                // READ
                //--------------------------------------------------
                READ:
                begin
					 mem_addr <= src_ptr;
                    mem_read <= 1'b1;
                    state    <= READ_WAIT;
                end

                //--------------------------------------------------
                // WAIT FOR MEMORY
                //--------------------------------------------------
                READ_WAIT:
                begin
					 data_buffer <= mem_data_in;
                    state <= WRITE;
                end

                //--------------------------------------------------
                // WRITE
                //--------------------------------------------------
                WRITE:
                begin
                    mem_addr     <= dst_ptr;
                    mem_data_out <= data_buffer;
                    mem_write    <= 1'b1;
						   src_ptr <= src_ptr + 16'd1;
                    dst_ptr <= dst_ptr + 16'd1;
                    count   <= count - 16'd1;

                    if(count == 16'd1)
                        state <= DONE;
                    else
                        state <= READ;
                end

                //--------------------------------------------------
                // DONE
                //--------------------------------------------------
                DONE:
					 begin
                    done  <= 1'b1;
                    state <= IDLE;
                end

                //--------------------------------------------------
                // DEFAULT
                //--------------------------------------------------
                default:
                begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule