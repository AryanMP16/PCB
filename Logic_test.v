module logic(input [7:0] inp, output reg [55:0] out, output [0:3] inters);

	reg [55:0] solution = 56'b10010011001100100111110101101000101101100110011111010101;

	wire a, b, c, d;
	assign a = inp[7] & inp [3] | inp[1]; //with correct inputs, should be 1
	assign b = ~(inp[6] & inp[3] & ~(inp[4] & inp[5])); //also 1
	assign c = inp[1] & ~(inp[0] | inp[4] & inp[3]); //0
	assign d = ~(~inp[2] | inp[5]); //0

	assign inters[0] = a;
	assign inters[1] = b;
	assign inters[2] = c;
	assign inters[3] = d;

	parameter FNV_OFFSET = 64'hcbf29ce484222325;
	parameter FNV_PRIME = 64'h100000001b3;

	function [63:0] FNV_1_Hash;
		input [7:0] to_hash;
		reg [63:0] hash;
		integer i;
		begin
			hash = FNV_OFFSET;
			for (i = 0; i < 8; i = i+1) begin
				hash = hash ^ to_hash[i];
				hash = hash * FNV_PRIME;
			end
			FNV_1_Hash = hash;
		end
	endfunction

	integer i;
    reg [63:0] hash_val;
	
    always @ (inp) begin
        for (i = 55; i >= 0; i = i - 1) begin
            hash_val = FNV_1_Hash(inp);
            if (solution[i] == 1'b1) begin
                out[i] = (hash_val[0] == 1'b1) ? a : b;
            end else begin
                out[i] = (hash_val[0] == 1'b1) ? c : d;
            end
        end
    end
endmodule : logic
	
module logic_tester();
	reg [7:0] inp;
	wire [55:0] out;
	wire [0:3] inters;
	integer i;
	logic l(.inp(inp), .out(out), .inters(inters));
	initial begin
		$display("Input\t||\tOutput");
		for (i = 0; i < 256; i = i+1) begin
			inp = i;
			#10;
			$display("%b  |   %b   %b %b", inp, out[6:0], out[34:7], out[55:35]);
		end
		$finish;
	end
endmodule : logic_tester


