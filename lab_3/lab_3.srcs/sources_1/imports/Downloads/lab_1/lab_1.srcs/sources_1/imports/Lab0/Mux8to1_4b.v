module Mux8to1_4b(
      input [3:0] a, // 第一个输�?
      input [3:0] b, // 第二个输�?
      input [3:0] c, // 第三个输�?
      input [3:0] d, // 第四个输�?
      input [3:0] e, // 第五个输�?
      input [3:0] f, // 第六个输�?
      input [3:0] g, // 第七个输�?
      input [3:0] h, // 第八个输�?
      input [2:0] s, // 选择信号
      output reg [3:0] o // 输出
    );
    
    
    always @(*) begin
        case(s)
            3'b000: o = a;
            3'b001: o = b;
            3'b010: o = c;
            3'b011: o = d;
            3'b100: o = e;
            3'b101: o = f;
            3'b110: o = g;
            3'b111: o = h;
        endcase
    end
endmodule