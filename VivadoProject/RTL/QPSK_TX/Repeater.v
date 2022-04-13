module Repeater#(
  parameter N = 4   // 重复次数
)(
  input               clk,
  input               reset,

  input [31:0]        axis_in_tdata,
  input               axis_in_tvalid,
  output reg          axis_in_tready,

  output     [31:0]   axis_out_tdata,
  output reg          axis_out_tvalid,
  input               axis_out_tready,
  
  // debug
  output [$clog2(N)-1:0] sender_cnt

);

reg [$clog2(N)-1:0] sender_cnt;  // 发送计数器

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

// 发送计数器 计数值为N
always @(posedge clk or posedge reset) begin
  if (reset) begin
    sender_cnt <= 4'd0;
  end else begin
    if (axis_out_tvalid && axis_out_tready) begin
      if (sender_cnt == N-1) begin
        sender_cnt <= 0;
      end
      else begin
        sender_cnt <= sender_cnt + 1'b1;
      end
    end
    else begin
      sender_cnt <= sender_cnt;
    end
  end
end

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
      if (sender_cnt == N-2 && axis_out_tvalid && axis_out_tready) begin  // 发送15位后 第16位进入到SEND_LAST状态，来判断是否进入IDLE
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
    // axis_out_tdata <= 32'b0;
    axis_out_tvalid <= 0;
  end
  else begin
    case (nstate)
      IDLE: begin
        axis_in_tready <= 1;
        // axis_out_tdata <= 32'b0;
        axis_out_tvalid <= 0;
      end
      HEADER: begin
        axis_in_tready <= 0;
        // axis_out_tdata[0] <= axis_in_tdata[cnt_m2];
        // axis_out_tdata[1] <= axis_in_tdata[cnt_m2p1];
        // axis_out_tdata[31:2] <= 0;
        axis_out_tvalid <= 0;
      end
      SEND: begin
        axis_in_tready <= 0;
        if (sender_cnt == 0) begin
          // axis_out_tdata[0] <= in_tdata_reg[cnt_m2];
          // axis_out_tdata[1] <= in_tdata_reg[cnt_m2p1];
          // axis_out_tdata[31:2] <= 0;
        end
        else begin
          // axis_out_tdata[0] <= in_tdata_reg[cnt_m2];
          // axis_out_tdata[1] <= in_tdata_reg[cnt_m2p1];
          // axis_out_tdata[31:2] <= 0;
        end
        axis_out_tvalid <= 1;
      end
      SEND_LAST: begin
        axis_in_tready <= 1;
        // axis_out_tdata[0] <= in_tdata_reg[cnt_m2];
        // axis_out_tdata[1] <= in_tdata_reg[cnt_m2p1];
        // axis_out_tdata[31:2] <= 0;
        axis_out_tvalid <= 1;
      end
      default: begin
        axis_in_tready <= 1;
        // axis_out_tdata <= 32'b0;
        axis_out_tvalid <= 0;
      end
    endcase
  end
end

assign axis_out_tdata = (cstate==IDLE)? 32'b0 : in_tdata_reg;

endmodule
