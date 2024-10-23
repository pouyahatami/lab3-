`define Sa 4'b0000
`define Sb 4'b0001
`define Sc 4'b0010
`define Sd 4'b0011
`define Se 4'b0100
`define Sf 4'b0101
`define Sg 4'b0110
`define Sh 4'b0111
`define Si 4'b1000
`define Sj 4'b1001
`define Sk 4'b1010  //defining the states to make the code more readable
`define Sl 4'b1011
`define Sm 4'b1100

module lab3_top(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
  input [9:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output [9:0] LEDR; // optional: use these outputs for debugging on your DE1-SoC

  reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // changed the hex outputs to reg for because we are assigning to them in the always block
  reg [3:0] present_state; // this is for the always block

  wire clk = ~KEY[0];  // this is your clock
  wire rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low

  always_ff @(posedge clk) begin
    if (!rst_n) begin 
        present_state = `Sa; // Use non-blocking assignment (<=) for sequential logic
    end else begin 
        case (present_state)
        `Sa : if (SW == 4'b0101) 
            present_state = `Sb;
            else 
            present_state = `Sh;
        `Sb : if (SW == 4'b0100)
            present_state = `Sc;
            else
            present_state = `Si;
        `Sc : if (SW == 4'b0000)
            present_state = `Sd;
            else
            present_state = `Sj; 
        `Sd : if (SW == 4'b0011)
            present_state = `Se;
            else
            present_state = `Sk;
        `Se : if (SW == 4'b0000)
            present_state = `Sf;
            else
            present_state = `Sl;
        `Sf : if (SW == 4'b0101)
            present_state = `Sg;
            else
            present_state = `Sm;
        `Sg : present_state = `Sg;
        `Sh : present_state = `Si;
        `Si : present_state = `Sj;
        `Sj : present_state = `Sk;
        `Sk : present_state = `Sl;
        `Sl : present_state = `Sm;
        `Sm : present_state = `Sm;
        default : present_state = 4'bxxxx; // handle undefined states

        endcase
    end
  end

  always @* begin
    case (present_state) 
    `Sg : begin 
        HEX3 = 7'b1000000; 
        HEX2 = 7'b0001100; 
        HEX1 = 7'b0000110; 
        HEX0 = 7'b0101011;
	HEX4 = 7'b1111111;
	HEX5 = 7'b1111111;
    end
    `Sm : begin
        HEX5 = 7'b1000110; 
        HEX4 = 7'b1000111; 
        HEX3 = 7'b1000000;  
        HEX2 = 7'b0010010; 
        HEX1 = 7'b0000110; 
        HEX0 = 7'b0100001;
    end  
    default : begin 
        case (SW) //entering digitds 1-10
            4'b0000 : begin  HEX0 = 7'b1000000; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end
            4'b0001 : begin HEX0 = 7'b1111001; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end
            4'b0010 : begin HEX0 = 7'b0100100; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end
            4'b0011 : begin HEX0 = 7'b0011001; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end
            4'b0100 : begin HEX0 = 7'b0110000; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end  //4
            4'b0101 : begin HEX0 = 7'b0010010; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end 
            4'b0110 : begin HEX0 = 7'b0000010; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end 
            4'b0111 : begin HEX0 = 7'b1111000; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end 
            4'b1000 : begin HEX0 = 7'b0000000; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end 
            4'b1001 : begin HEX0 = 7'b0010000; HEX4 = 7'b1111111; HEX5 = 7'b1111111; end
            default : begin
                HEX4 = 7'b1111001;  //error case 
                HEX3 = 7'b0101111; 
                HEX2 = 7'b0101111;
                HEX1 = 7'b1000000;
                HEX0 = 7'b0101111; 
            end
        endcase
    end
    endcase
  end 
endmodule
