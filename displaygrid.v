module displaygrid(
	input clk,
	input [3839:0] grid,
	output MTL2_DCLK,
	output [7:0] MTL2_R,
	output [7:0] MTL2_G,
	output [7:0] MTL2_B,
	output MTL2_HSD,
	output MTL2_VSD
);

reg [7:0] red, green, blue;
wire display_on;
wire [11:0] hpos;
wire [11:0] vpos;
reg clk25 = 0;
always @(posedge clk) clk25 = ~clk25;

hvsync test(
	.clk(clk25),
	.reset(0),
	.data_enable(display_on),
	.hsync(MTL2_HSD),
	.vsync(MTL2_VSD),
	.hpos(hpos),
	.vpos(vpos)
);

always @(posedge clk25) begin
	if(display_on && grid[(hpos / 10) + (vpos / 10) * 80]) begin
		red <= 8'd222;
		green <= 8'd222;
		blue <= 8'd77;
	end
	else begin
		red <= 8'd0;
		green <= 8'd0;
		blue <= 8'd0;
	end
end

assign MTL2_DCLK = clk25;
assign MTL2_R = red;
assign MTL2_G = green;
assign MTL2_B = blue;

endmodule