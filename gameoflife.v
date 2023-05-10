module gameoflife(
	input clk,
	input clkslow,
	input wire reset,
	input start,
	output reg [3839:0] grid,
	output wire [3839:0] nextgrid,
	input wire [7:0] xcoordinate,
	input wire [7:0] ycoordinate,
	input wire coordinatesready
);

integer i;
reg stateready = 0;
reg first = 0;
reg lastcoordinatesready = 0;
reg lastreset = 0;
/*
initial begin
for(i = 0; i < 3840; i = i + 1) begin
	grid[i] = 0;
end
grid[2] <= 1;
grid[80] <= 1;
grid[82] <= 1;
grid[161] <= 1;
grid[162] <= 1;
grid[180] <= 1;
grid[181] <= 1;
grid[182] <= 1;
grid[183] <= 1;
grid[259] <= 1;
grid[263] <= 1;
grid[343] <= 1;
grid[419] <= 1;
grid[422] <= 1;
end
*/
nextstate test1(
	.ingrid(grid),
	.outgrid(nextgrid),
	.stateready(stateready)
);

always @(posedge clkslow) begin
	if(start) begin
		if(first == 0) begin	
			first = ~first;
			stateready = ~stateready;
		end 
		else begin
			grid <= nextgrid;
			stateready = ~stateready;
		end
	end
	else begin
		if(lastcoordinatesready != coordinatesready) begin
			grid[xcoordinate + ycoordinate * 80] = 1;
		end
		if(lastreset != reset) begin
			for(i = 0; i < 3840; i = i + 1) begin
				grid[i] = 0;
			end
			stateready = ~stateready;
		end
	end
	lastcoordinatesready = coordinatesready;
	lastreset = reset;
end

endmodule