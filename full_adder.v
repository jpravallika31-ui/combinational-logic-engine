
module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire carry_out
);

    assign sum = a ^ b ^ cin;

    assign carry_out = (a & b) |
                       (b & cin) |
                       (a & cin);

endmodule
