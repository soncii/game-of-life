module nextstate(
	input [3839:0] ingrid,
	output reg [3839:0] outgrid,
	input wire stateready
);

integer i;
integer j;
integer neighbours;

always @(stateready) begin
	for(i = 0; i < 48; i = i + 1) begin
		for(j = 0; j < 80; j = j + 1) begin
			neighbours = 0;
			neighbours = neighbours + ingrid[(i + 47) % 48 * 80 + ((j + 79) % 80)];
			neighbours = neighbours + ingrid[(i + 48) % 48 * 80 + ((j + 79) % 80)];
			neighbours = neighbours + ingrid[(i + 49) % 48 * 80 + ((j + 79) % 80)];
			neighbours = neighbours + ingrid[(i + 47) % 48 * 80 + ((j + 80) % 80)];
			neighbours = neighbours + ingrid[(i + 49) % 48 * 80 + ((j + 80) % 80)];
			neighbours = neighbours + ingrid[(i + 47) % 48 * 80 + ((j + 81) % 80)];
			neighbours = neighbours + ingrid[(i + 48) % 48 * 80 + ((j + 81) % 80)];
			neighbours = neighbours + ingrid[(i + 49) % 48 * 80 + ((j + 81) % 80)];
			if(ingrid[i * 80 + j] == 1) begin
				if(neighbours < 2) begin
					outgrid[i * 80 + j] = 0;
				end
				else if(neighbours < 4) begin
					outgrid[i * 80 + j] = 1;
				end
				else begin
					outgrid[i * 80 + j] = 0;
				end
			end
			else begin
				if(neighbours == 3) begin
					outgrid[i * 80 + j] = 1;
				end
				else begin
					outgrid[i * 80 + j] = 0;
				end
			end
		end
	end
end

endmodule