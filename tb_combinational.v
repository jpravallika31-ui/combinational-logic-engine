
`timescale 1ns/1ps

module tb_combinational;

    reg a, b, cin;
    wire sum, carry_out;

    reg d0, d1, d2, d3;
    reg [1:0] sel;
    wire y;

    integer i;
    integer errors;
    reg expected_sum, expected_carry, expected_y;

    full_adder fa (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .carry_out(carry_out)
    );

    mux4to1 mux (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );

    initial begin
        errors = 0;

        $dumpfile("combinational.vcd");
        $dumpvars(0, tb_combinational);

        $display("Testing Full Adder");

        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i;
            #1;

            expected_sum = a ^ b ^ cin;
            expected_carry = (a & b) |
                             (b & cin) |
                             (a & cin);

            if (sum !== expected_sum ||
                carry_out !== expected_carry) begin
                $display("FAIL Full Adder: %b %b %b",
                         a, b, cin);
                errors = errors + 1;
            end

            #9;
        end

        $display("Testing 4:1 MUX");

        for (i = 0; i < 64; i = i + 1) begin
            {d3, d2, d1, d0, sel} = i;
            #1;

            case (sel)
                2'b00: expected_y = d0;
                2'b01: expected_y = d1;
                2'b10: expected_y = d2;
                2'b11: expected_y = d3;
                default: expected_y = 1'b0;
            endcase

            if (y !== expected_y) begin
                $display("FAIL MUX: sel=%b", sel);
                errors = errors + 1;
            end

            #9;
        end

        if (errors == 0)
            $display("PASS: All 8 Full Adder and 64 MUX tests passed.");
        else
            $display("FAIL: %0d errors found.", errors);

        $finish;
    end

endmodule
