`timescale 1ns / 1ps

`include "../../define/bus.v"

module IDEX(
    input clk,
    input rst,
    input stall_current_stage,
    input stall_next_stage,
    // input from ID stage
    input [`FUNCT_BUS] funct_in,
    input [`SHAMT_BUS] shamt_in,
    input [`DATA_BUS] operand_1_in,
    input [`DATA_BUS] operand_2_in,
    input mem_read_flag_in,
    input mem_write_flag_in,
    input mem_sign_ext_flag_in,
    input [3:0] mem_sel_in,
    input [`DATA_BUS] mem_write_data_in,
    input  write_reg_en_in,
    input [`REG_ADDR_BUS] write_reg_addr_in,
    input [`ADDR_BUS] debug_pc_addr_in,
    // output to EX (and WB) stage
    output [`FUNCT_BUS] funct_out,
    output [`SHAMT_BUS] shamt_out,
    output [`DATA_BUS] operand_1_out,
    output [`DATA_BUS] operand_2_out,
    output mem_read_flag_out,
    output mem_write_flag_out,
    output mem_sign_ext_flag_out,
    output [3:0] mem_sel_out,
    output [`DATA_BUS] mem_write_data_out,
    output  write_reg_en_out,
    output [`REG_ADDR_BUS] write_reg_addr_out,
    output [`ADDR_BUS] debug_pc_addr_out
);

    PipelineDeliver #(`FUNCT_BUS_WIDTH) ff_funct(
        clk, rst,
        stall_current_stage, stall_next_stage,
        funct_in, funct_out
    );

    PipelineDeliver #(`SHAMT_BUS_WIDTH) ff_shamt(
        clk, rst,
        stall_current_stage, stall_next_stage,
        shamt_in, shamt_out
    );

    PipelineDeliver #(`DATA_BUS_WIDTH) ff_operand_1(
        clk, rst,
        stall_current_stage, stall_next_stage,
        operand_1_in, operand_1_out
    );

    PipelineDeliver #(`DATA_BUS_WIDTH) ff_operand_2(
        clk, rst,
        stall_current_stage, stall_next_stage,
        operand_2_in, operand_2_out
    );

    PipelineDeliver #(1) ff_mem_read_flag(
        clk, rst,
        stall_current_stage, stall_next_stage,
        mem_read_flag_in, mem_read_flag_out
    );

    PipelineDeliver #(1) ff_mem_write_flag(
        clk, rst,
        stall_current_stage, stall_next_stage,
        mem_write_flag_in, mem_write_flag_out
    );

    PipelineDeliver #(1) ff_mem_sign_ext_flag(
        clk, rst,
        stall_current_stage, stall_next_stage,
        mem_sign_ext_flag_in, mem_sign_ext_flag_out
    );

    PipelineDeliver #(4) ff_mem_sel(
        clk, rst,
        stall_current_stage, stall_next_stage,
        mem_sel_in, mem_sel_out
    );

    PipelineDeliver #(`DATA_BUS_WIDTH) ff_mem_write_data(
        clk, rst,
        stall_current_stage, stall_next_stage,
        mem_write_data_in, mem_write_data_out
    );

    PipelineDeliver #(1) ff_write_reg_en(
        clk, rst,
        stall_current_stage, stall_next_stage,
        write_reg_en_in, write_reg_en_out
    );

    PipelineDeliver #(`REG_ADDR_BUS_WIDTH) ff_write_reg_addr(
        clk, rst,
        stall_current_stage, stall_next_stage,
        write_reg_addr_in, write_reg_addr_out
    );

    PipelineDeliver #(`ADDR_BUS_WIDTH) ff_debug_pc_addr(
        clk, rst,
        0, 0,
        debug_pc_addr_in, debug_pc_addr_out
    );

endmodule // IDEX
