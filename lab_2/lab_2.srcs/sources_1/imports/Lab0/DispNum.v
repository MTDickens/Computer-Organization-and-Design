module DispNum(
        input wire clk, // 时钟信号
        input wire rst, // 复位信号
        input wire wen, // 写使能信号，当其在时钟上升沿�? 1 时才根据输入端口修改显示的数�?
        input wire [31:0] i_data, // 从其他电路输入到驱动的数据，默认数据交换的宽度为 32 bits
        output reg [31:0] o_data, // 驱动中暂存的数据，其他电路可以读�?
        output reg [6:0] Segments, // 连接 FPGA 的七�? LED 的接�?
        output reg [7:0] AN // 八组七段数码管的是能信号
    );

    always @(posedge clk) begin
        if (rst)
            o_data = 32'b0;
        else if (wen)
            o_data = i_data;
    end
    
    // scan
    wire [2:0] scan;
    clkdiv c0(.clk(clk),.rst(rst),.scan(scan));

    // hex-on-display
    wire [3:0] output_hex;
    Mux8to1_4b mux0(o_data[3:0], o_data[7:4], o_data[11:8], o_data[15:12], o_data[19:16], o_data[23:20],
                      o_data[27:24], o_data[31:28], scan, output_hex);

    // display the hex 
    always @(*) begin
        case (output_hex)
            4'h0: begin
                Segments <= 7'b1000000; // Display 0
            end
            4'h1: begin
                Segments <= 7'b1111001; // Display 1
            end
            4'h2: begin
                Segments <= 7'b0100100; // Display 2
            end
            4'h3: begin
                Segments <= 7'b0110000; // Display 3
            end
            4'h4: begin
                Segments <= 7'b0011001; // Display 4
            end
            4'h5: begin
                Segments <= 7'b0010010; // Display 5
            end
            4'h6: begin
                Segments <= 7'b0000010; // Display 6
            end
            4'h7: begin
                Segments <= 7'b1111000; // Display 7
            end
            4'h8: begin
                Segments <= 7'b0000000; // Display 8 
            end
            4'h9: begin
                Segments <= 7'b0010000; // Display 9
            end
            4'hA: begin
                Segments <= 7'b0001000; // Display A
            end
            4'hB: begin
                Segments <= 7'b0000011; // Display B
            end
            4'hC: begin
                Segments <= 7'b1000110; // Display C
            end
            4'hD: begin
                Segments <= 7'b0100001; // Display D
            end
            4'hE: begin
                Segments <= 7'b0000110; // Display E
            end
            4'hF: begin
                Segments <= 7'b0001110; // Display F
            end
        endcase
    end

    // set the enable bits
    always @(*) begin
        AN <= 8'b11111111;
        AN[scan] <= 0;
    end

endmodule