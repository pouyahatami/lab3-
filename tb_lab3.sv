module tb_lab3();

    reg clock;
    reg reset;
    reg [9:0] switch_in;
    wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5;  // HEX outputs as wire since they are driven by DUT

    // Instantiate the DUT (Device Under Test)
    lab3_top DUT (
        .SW(switch_in),
        .KEY({3'b0, reset, clock}),  // Connecting reset and clock using KEY input
        .HEX0(hex0),
        .HEX1(hex1),
        .HEX2(hex2),
        .HEX3(hex3),
        .HEX4(hex4),
        .HEX5(hex5),
        .LEDR()                      // Unused LED output
    );

    // Clock generation
    always #5 clock = ~clock;  // Toggle clock every 5 time units

    initial begin
        // Initial values
        clock = 1'b0;
        reset = 1'b0;            // Apply reset
        switch_in = 10'b0000000000;  // Initially, all switches are off

        // Reset sequence
        #10 reset = 1'b1;        // Deassert reset after 10 time units
        
        // Apply test stimulus
        #10 switch_in = 10'b0000000101;  // Set SW to represent pressing 5

        // Wait for a few clock cycles
        #20;

        // Check the HEX0 output
        $display("HEX0 is %b, expected %b", hex0, 7'b0010010); // Expected 7-segment encoding for '5'

        // Stop the simulation
        $stop;
    end

endmodule
