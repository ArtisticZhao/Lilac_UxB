module QPSK_data_converter (
  input             clk,
  input             reset,

  input [31:0]      axis_in_tdata,
  input             axis_in_tvalid,
  output reg        axis_in_tready,

  output reg [31:0] axis_out_tdata,
  output reg        axis_out_tvalid,
  input             axis_out_tready

);

reg [3:0] sender_cnt;  // 发送计数器，0~15 收一个数，输出16个数

// 对数据映射到幅值, 目前是DAC full scale的80%
parameter ONE = 16'h6665;
parameter ZERO = 16'h999B;

wire sample;
assign sample = axis_in_tvalid && axis_in_tready;

// 输入数据缓存，会导致输入数据一个周期的延迟
reg [31:0] in_tdata_reg;
always @(posedge clk or posedge reset) begin
  if (reset) begin
    in_tdata_reg <= 32'b0;
  end
  else begin
    if (sample) begin
      in_tdata_reg <= axis_in_tdata;
    end
    else begin
      in_tdata_reg <= in_tdata_reg;
    end
  end
end

// 发送计数器
always @(posedge clk or posedge reset) begin
  if (reset) begin
    sender_cnt <= 4'd0;
  end else begin
    if (axis_out_tvalid && axis_out_tready) begin
      sender_cnt <= sender_cnt + 1'b1;
    end
    else begin
      sender_cnt <= sender_cnt;
    end
  end
end

// 计算索引值
wire [4:0] cnt_m2;
wire [4:0] cnt_m2p1;
wire [3:0] minus_cnt;
assign minus_cnt = 4'b1111 - sender_cnt;
assign cnt_m2 = {minus_cnt, 1'b0};    // 这个是cnt*2
assign cnt_m2p1 = {minus_cnt, 1'b1};  // cnt*2 +1

// --- FSM 3 ---
localparam IDLE      = 4'b0001;
// 因为in_tdata_reg会延迟一个周期，这个状态是用来同步in_tdata_reg的信号的，并在这个状态下需要tready=0来阻塞
localparam HEADER    = 4'b0010;
localparam SEND      = 4'b0100;
localparam SEND_LAST = 4'b1000;

reg [3:0] cstate, nstate;
// fsm-1
always @(posedge clk or posedge reset) begin
  if (reset) begin
    cstate <= IDLE;
  end
  else begin
    cstate <= nstate;
  end
end
// fsm-2
always @(*) begin
  nstate = IDLE;
  case(cstate)
    IDLE: begin
      if (sample) begin
        nstate = HEADER;
      end
      else begin
        nstate = IDLE;
      end
    end
    HEADER: begin
      nstate = SEND;
    end
    SEND: begin
      if (sender_cnt == 14 && axis_out_tvalid && axis_out_tready) begin  // 发送15位后 第16位进入到SEND_LAST状态，来判断是否进入IDLE
        nstate = SEND_LAST;
      end
      else begin
        nstate = SEND;
      end
    end
    SEND_LAST: begin
      if (sample) begin
        nstate = SEND;
      end
      else begin
        if (axis_out_tvalid && axis_out_tready) begin
          nstate = IDLE;
        end
        else begin
          nstate = SEND_LAST;
        end
      end
    end
    default: nstate = IDLE;
  endcase
end
// fsm-3
always @(posedge clk or posedge reset) begin
  if (reset) begin
    axis_in_tready <= 1;
    axis_out_tvalid <= 0;
  end
  else begin
    case (nstate)
      IDLE: begin
        axis_in_tready <= 1;
        axis_out_tvalid <= 0;
      end
      HEADER: begin
        axis_in_tready <= 0;
        axis_out_tvalid <= 0;
      end
      SEND: begin
        axis_in_tready <= 0;
        if (sender_cnt == 0) begin
        end
        else begin
        end
        axis_out_tvalid <= 1;
      end
      SEND_LAST: begin
        axis_in_tready <= 1;
        axis_out_tvalid <= 1;
      end
      default: begin
        axis_in_tready <= 1;
        axis_out_tvalid <= 0;
      end
    endcase
  end
end

// for DEBUG
// assign axis_out_tdata[31:2] = 0;
// assign axis_out_tdata[0] = in_tdata_reg[cnt_m2];
// assign axis_out_tdata[1] = in_tdata_reg[cnt_m2p1];

// remap output value to DAC output.
always @(*) begin
  case ({in_tdata_reg[cnt_m2p1], in_tdata_reg[cnt_m2]})
    2'b00: begin
      axis_out_tdata[31:0] = {ONE, ONE};
    end
    2'b01: begin
      axis_out_tdata[31:0] = {ZERO, ONE};
    end
    2'b11: begin
      axis_out_tdata[31:0] = {ZERO, ZERO};
    end
    2'b10: begin
      axis_out_tdata[31:0] = {ONE, ZERO};
    end
  endcase
end

endmodule
