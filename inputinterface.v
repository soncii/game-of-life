module inputinterface(
    input clk,
    input [9:0] SW,
    input [3:0] KEY,
	 output reg [6:0] HEX0,
	 output reg [6:0] HEX1,
	 output reg [6:0] HEX2,
	 output reg [6:0] HEX3,
	 output reg [6:0] HEX4,
	 output reg [6:0] HEX5,
	 output reg [7:0] xcoordinate,
	 output reg [7:0] ycoordinate,
	 output reg coordinatesready,
	 output reg start,
	 output reg reset
);

reg [7:0] digit1 = 0;
reg [7:0] digit2 = 0;
reg [7:0] digit3 = 0;
reg [7:0] digit4 = 0;

reg [3:0] state = 0;
reg [3:0] next_state = 0;

reg inputprev;
reg pressedinput = 0;
reg startprev;
reg pressedstart = 0;
reg pauseprev;
reg pressedpause = 0;
reg resetprev;
reg pressedreset = 0;

reg [7:0] first = 100;
reg inputmode = 1;
integer i;

initial begin 
HEX0 = 7'b1110111;
HEX1 = 7'b1110111;
HEX2 = 7'b1000001;
HEX3 = 7'b0001001;
HEX4 = 7'b1110111;
HEX5 = 7'b1110111;
start = 0;
end

always @(posedge clk) begin
inputprev <= KEY[3];
pressedinput <= !inputprev && KEY[3];
end

always @(posedge clk) begin
startprev <= KEY[2];
pressedstart <= !startprev && KEY[2];
end

always @(posedge clk) begin
pauseprev <= KEY[1];
pressedpause <= !pauseprev && KEY[1];
end

always @(posedge clk) begin
resetprev <= KEY[0];
pressedreset <= !resetprev && KEY[0];
end

function [6:0] display_digit;
  input [7:0] digit;
  begin
    case (digit)
      8'd0: display_digit = 7'b1000000;
      8'd1: display_digit = 7'b1111001;
      8'd2: display_digit = 7'b0100100;
      8'd3: display_digit = 7'b0110000;
      8'd4: display_digit = 7'b0011001;
      8'd5: display_digit = 7'b0010010;
      8'd6: display_digit = 7'b0000010;
      8'd7: display_digit = 7'b1111000;
      8'd8: display_digit = 7'b0000000;
      8'd9: display_digit = 7'b0010000;
      default: display_digit = 7'b1110111; // default to displaying _
    endcase
  end
endfunction

always @(posedge clk) begin
	if (first != 0) first = first - 1;
	else begin
		if(inputmode && pressedinput) begin
			if (state == 0) begin
				next_state = 1;
				for (i = 0; i < 10; i = i + 1) begin
					if (SW[i]) digit1 = i;
				end
				HEX5 = display_digit(digit1);	 
			end
			if (state == 1) begin
				next_state = 2;
				for (i = 0; i < 10; i = i + 1) begin
					if (SW[i]) digit2 = i;
				end
				HEX4 = display_digit(digit2);	 			 
			end
			if (state == 2) begin
				next_state = 3;
				for (i = 0; i < 10; i = i + 1) begin
					if (SW[i]) digit3 = i;
				end
				HEX1 = display_digit(digit3);
			end
			if (state == 3) begin	
				next_state = 4;
				for (i = 0; i < 10; i = i + 1) begin
					if (SW[i]) digit4 = i;
				end
				HEX0 = display_digit(digit4);
			end	 
			if (state==4) begin 
				HEX0 = 7'b1110111;
				HEX1 = 7'b1110111;
				HEX4 = 7'b1110111;
				HEX5 = 7'b1110111;
				xcoordinate = digit1 * 10 + digit2;
				ycoordinate = digit3 * 10 + digit4;
				if (xcoordinate < 80 && ycoordinate < 48) begin
					coordinatesready = ~coordinatesready;
				end
				next_state = 0;
			end 
			state = next_state;
		end
		else if(pressedstart) begin
			start = 1;
			inputmode = 0;
		end
		else if(pressedpause) begin
			start = 0;
		end
		else if(pressedreset) begin
			start = 0;
			inputmode = 1;
			HEX0 = 7'b1110111;
			HEX1 = 7'b1110111;
			HEX2 = 7'b1000001;
			HEX3 = 7'b0001001;
			HEX4 = 7'b1110111;
			HEX5 = 7'b1110111;
			reset = ~reset;
			state = 0;
		end
		if(inputmode == 0) begin
			HEX0 = 7'b0011100;
			HEX1 = 7'b0000110;
			HEX2 = 7'b0001110;
			HEX3 = 7'b1001111;
			HEX4 = 7'b1000111;
			HEX5 = 7'b0100011;
		end
	end  
end

endmodule