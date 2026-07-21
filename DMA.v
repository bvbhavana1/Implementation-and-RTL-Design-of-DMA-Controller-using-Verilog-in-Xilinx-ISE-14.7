module DMA(
    input clk,
    input reset,
    input start,

    input [15:0] src_addr,
    input [15:0] dst_addr,
    input [15:0] length,
	  input  [7:0] mem_data_in,
    output reg [7:0] mem_data_out,

    output reg [15:0] mem_addr,
    output reg mem_read,
    output reg mem_write,

    output reg done
);
 reg [15:0] src_ptr, dst_ptr;
    reg [15:0] count;
    reg [2:0]  state;          // 🔧 FIXED: 3-bit state

    localparam IDLE      = 3'b000,
               READ      = 3'b001,
					READ_WAIT = 3'b010,
               WRITE     = 3'b011,
               DONE      = 3'b100;

    reg [7:0] data_buffer;
 always @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= IDLE;
            done        <= 0;
            mem_read    <= 0;
            mem_write   <= 0;
				 mem_addr    <= 0;
            mem_data_out<= 0;
        end else begin
            case (state)
				IDLE: begin
                    done      <= 0;
                    mem_read  <= 0;
                    mem_write <= 0;
                    if (start) begin
                        src_ptr <= src_addr;
								 dst_ptr <= dst_addr;
                        count   <= length;
                        state   <= READ;
                    end
                end

                READ: begin
					  mem_addr  <= src_ptr;
                    mem_read  <= 1;
                    mem_write <= 0;
                    state     <= READ_WAIT;
                end

                READ_WAIT: begin
					 mem_read    <= 0;
                    data_buffer <= mem_data_in;
                    state       <= WRITE;
                end

                WRITE: begin
                    mem_addr     <= dst_ptr;
						  mem_data_out <= data_buffer;
                    mem_write    <= 1;

                    src_ptr <= src_ptr + 16'd1;
                    dst_ptr <= dst_ptr + 16'd1;
                    count   <= count   - 16'd1;

                    if (count == 16'd1)
                        state <= DONE;
								else
                        state <= READ;
                end

                DONE: begin
                    mem_read  <= 0;
                    mem_write <= 0;
                    done      <= 1;
                    state     <= IDLE;
						   end

            endcase
        end
    end

endmodule
