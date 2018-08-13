module arbiter(
    input           clk,
    input           rst,

    input   [31:0]  rdata,
    input           rlast,
    input           rvalid,

    input           wlast,
    input           wready,

    input           ram_en,
    input   [3:0]   ram_write_en,
    input   [31:0]  ram_write_data,
    input   [31:0]  ram_addr,

    input           rom_en,
    input   [3:0]   rom_write_en,
    input   [31:0]  rom_write_data,
    input   [31:0]  rom_addr,

    output          wready_out,
    output          stall_all,

    output  [31:0]  ram_read_data,
    output  [31:0]  rom_read_data,

    output  [3:0]   awid_o,
    output  [31:0]  awaddr_o,
    output  [3:0]   awlen_o,
    output  [2:0]   awsize_o,
    output  [1:0]   awburst_o,
    output  [31:0]  wdata_o,
    output  [3:0]   wstrb_o,
    output  [3:0]   arid_o,
    output  [31:0]  araddr_o,
    output  [3:0]   arlen_o,
    output  [2:0]   arsize_o,
    output  [1:0]   arburst_o
);

    wire ram_write_flag = ram_en && ram_write_en;
    wire ram_read_flag = ram_en && !ram_write_en;

    assign  ram_read_data = ram_read_flag ? rdata : 0;
    assign  rom_read_data = !ram_read_flag && rom_en ? rdata : 0;

    assign  awid_o = 4'b000;
    assign  awaddr_o = ram_write_flag ? ram_addr : 32'h0;
    assign  awlen_o = 4'b0000;
    assign  awsize_o = 3'b010;
    assign  awburst_o = 2'b00;

    assign  wdata_o = ram_write_flag ? ram_write_data : 32'h0;
    assign  wstrb_o = ram_en ? ram_write_en : 4'b0000;

    assign  arid_o = 4'b0000;
    assign  araddr_o = ram_read_flag ? ram_addr : rom_en ? rom_addr : 32'h0;
    assign  arlen_o = 4'b0000;
    assign  arsize_o = 3'b010;
    assign  arburst_o = 2'b00;

    // TODO: replace these MAGIC codes
    reg rvalid_delay;
    wire stall_signal = ~(rvalid & rvalid_delay);

    always @(posedge clk) begin
        if (!rst) begin
            rvalid_delay <= 0;
        end
        else begin
            rvalid_delay <= rvalid;
        end
    end

    reg rlast_wait_flag;
    always @(posedge clk) begin
        if (!rst) begin
            rlast_wait_flag <= 0;
        end
        else begin
            if (ram_read_flag && rlast) begin
                rlast_wait_flag <= 1;
            end
            if (rlast_wait_flag && !rlast) begin
                rlast_wait_flag <= 0;
            end
        end
    end

    reg[1:0] wready_delay;
    always @(posedge clk) begin
        if (!rst) begin
            wready_delay <= 0;
        end
        else begin
            wready_delay[0] <= wready;
            wready_delay[1] <= wready_delay[0];
        end
    end

    // reg wlast_wait_flag;
    // always @(posedge clk) begin
    //     if (!rst) begin
    //         wlast_wait_flag <= 0;
    //     end
    //     else begin
    //         if (ram_write_flag && wlast) begin
    //             wlast_wait_flag <= 1;
    //         end
    //         if (wlast_wait_flag && !wlast) begin
    //             wlast_wait_flag <= 0;
    //         end
    //     end
    // end

    wire rlast_stall = !ram_read_flag & rlast_wait_flag;
    // wire wlast_stall = !ram_write_flag & wlast_wait_flag;
    // assign stall_all = stall_signal | rlast_stall | wlast_stall;

    assign wready_out = wready | wready_delay[0] | wready_delay[1];
    assign stall_all = stall_signal | rlast_stall;

endmodule