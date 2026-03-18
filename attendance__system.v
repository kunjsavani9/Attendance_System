 module attendance__system (
    input clk, reset, present, absent,
    output [6:0] seg_present_ones, seg_present_tens, seg_absent_ones, seg_absent_tens
);

    reg [6:0] present_count = 7'd0;
    reg [6:0] absent_count = 7'd0;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            present_count <= 7'd0;
            absent_count <= 7'd0;
        end else if (present_count + absent_count < 7'd99)begin
            if (present && !absent && present_count < 7'd99)
                present_count <= present_count + 1;
            if (absent && !present && absent_count < 7'd99)
                absent_count <= absent_count + 1;
        end
    end

    // Seven Segment Display for Present Count (Tens and Ones Digits)
    seven_segment_display present_display_ones (
        .digit(present_count % 10),
        .segments(seg_present_ones)
    );
    
    seven_segment_display present_display_tens (
        .digit(present_count / 10),
        .segments(seg_present_tens)
    );

    // Seven Segment Display for Absent Count (Tens and Ones Digits)
    seven_segment_display absent_display_ones (
        .digit(absent_count % 10),
        .segments(seg_absent_ones)
    );
    
    seven_segment_display absent_display_tens (
        .digit(absent_count / 10),
        .segments(seg_absent_tens)
    );

endmodule

module seven_segment_display (
    input [3:0] digit,
    output reg [6:0] segments
);
    always @(*) begin
        case (digit)
            4'd0: segments = 7'b0000001;
            4'd1: segments = 7'b1001111;
            4'd2: segments = 7'b0010010;
            4'd3: segments = 7'b0000110;
            4'd4: segments = 7'b1001100;
            4'd5: segments = 7'b0100100;
            4'd6: segments = 7'b0100000;
            4'd7: segments = 7'b0001111;
            4'd8: segments = 7'b0000000;
            4'd9: segments = 7'b0000100;
            default: segments = 7'b0000000;
        endcase
    end
endmodule
