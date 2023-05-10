module control(clk, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, MTL2_DCLK, MTL2_R, MTL2_G, MTL2_B, MTL2_HSD, MTL2_VSD);
input clk;
wire clkslow;
input [9:0] SW;
input [3:0] KEY;
output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;
output MTL2_DCLK;
output [7:0] MTL2_R;
output [7:0] MTL2_G;
output [7:0] MTL2_B;
output MTL2_HSD;
output MTL2_VSD;
wire [3839:0] currentgrid;
wire [3839:0] nextgrid;
wire start;
wire [7:0] xcoordinate;
wire [7:0] ycoordinate;
wire coordinatesready;
wire reset;

inputinterface inputinterface_inst(
	.clk(clk),
	.SW(SW),
	.KEY(KEY),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3),
	.HEX4(HEX4),
	.HEX5(HEX5),
	.xcoordinate(xcoordinate),
	.ycoordinate(ycoordinate),
	.coordinatesready(coordinatesready),
	.start(start),
	.reset(reset)
);

gameoflife gameoflife_inst(
	.clk(clk),
	.clkslow(clkslow),
	.reset(reset),
	.start(start),
	.grid(currentgrid),
	.nextgrid(nextgrid),
	.xcoordinate(xcoordinate),
	.ycoordinate(ycoordinate),
	.coordinatesready(coordinatesready),
);

displaygrid displaygrid_inst(
	.clk(clk),
	.grid(currentgrid),
	.MTL2_DCLK(MTL2_DCLK),
	.MTL2_R(MTL2_R),
	.MTL2_G(MTL2_G),
	.MTL2_B(MTL2_B),
	.MTL2_HSD(MTL2_HSD),
	.MTL2_VSD(MTL2_VSD)
);

clock clock_inst(
	.clk(clk),
	.clk_div(clkslow)
);

endmodule