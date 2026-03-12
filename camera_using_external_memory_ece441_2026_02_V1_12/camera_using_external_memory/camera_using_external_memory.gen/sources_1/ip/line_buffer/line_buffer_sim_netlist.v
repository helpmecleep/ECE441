// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Mar  5 15:01:52 2026
// Host        : ws11-04 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/saredar/camera_using_external_memory_ece441_2026_02_V1_12/camera_using_external_memory/camera_using_external_memory.gen/sources_1/ip/line_buffer/line_buffer_sim_netlist.v
// Design      : line_buffer
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "line_buffer,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module line_buffer
   (clka,
    ena,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [6:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [95:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [6:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [95:0]doutb;

  wire [6:0]addra;
  wire [6:0]addrb;
  wire clka;
  wire clkb;
  wire [95:0]dina;
  wire [95:0]doutb;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [95:0]NLW_U0_douta_UNCONNECTED;
  wire [6:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [6:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [95:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "7" *) 
  (* C_ADDRB_WIDTH = "7" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     10.67465 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "line_buffer.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "80" *) 
  (* C_READ_DEPTH_B = "80" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "96" *) 
  (* C_READ_WIDTH_B = "96" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "80" *) 
  (* C_WRITE_DEPTH_B = "80" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "96" *) 
  (* C_WRITE_WIDTH_B = "96" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  line_buffer_blk_mem_gen_v8_4_9 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[95:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[6:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[6:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[95:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
FPXllyX2NFs/RMngGqZy2bLYbZr92CdofeZrJOHklWXExpaPgHNYp2Lzm4MnflbnrfSkCmLwwKT5
zfRgEip7FKQ5Zhb73p0MAIADixBZ/ZRt4hQkJL0T9brm0waLHfanjnov2aCX6jN3LbQc3ujmDga6
Dd73k78u4xjRTDv1/P4=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kr7VKKvChFoiyRCReag+OvU3jnmG9pN0cv+BxhNmMKLthg/ksgNZyU3L+fQ7cmIQELtlUjwjkBAP
Jjq5RsCnHbJxj+Ys1GNhriiBsxLqxWCP8onhAVvgZN2xZFOih0UWpqlU8NVP8Eww1ohvkDgxTstC
3kDmYehxIUJjqCC/mgRZmuezqugrFdubYmBoz16tUvD17iA5qqCIMS9xSIXYp2LBNekmWEwrVqzu
R4koEo4UlXl/CEw0XY3QvMoHnlXgu6N/6sc+nxZtKSwjiMVvGnZE9UVvJPAC3Hn3zKFGlK53mmGO
Tj0dWzhwX0ahSYzkyJC/HLdbGZmriL2UNvDyFw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
CaLc9FGt3AdRHfNtGAsGFY/QEvHY1Vv4TvvgCDsdDMqiuDeLizFJDJeskBWjeKDoE2cufK8TxiBq
mySRQNJoeOKnxTiDdf+Rx6m0iR6h/YeswegYwgghpM5KVrl6mSwF3+4yEovPM7a+9ArDQ5vl+WT8
SilNGzyW0KnTwe7+szs=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
cEnudSW1X71p0Xuq6jrXOxHnBku87IA0RA3zKqmeZHZM0r+9rEm5MSzX8RecnQ994yiqeyxbIH2l
fGEzUzr0ZzryS3fkf2LnJuB39f2YARW9eVCSiaeWaraZuY1l89T+h3vgdlurS/1LIraYLS1MyOXa
6F1LAcQp3W4OO4ctc3q1FRMZGldRS1biMsKwJ8Lxj8NEOm67UfgFrJNQAxbVXEfbWRWhKtwNxcTB
JbgC8j4EHkIA46mzoHloeBAL6KieplQUBjKXSSTb66rxglbFhWLy+mirROHcocu9J4ZbvTRYZEww
4lso1lqAllVLAoKYqa3WImZuSRoTbGDngBt9Lg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rOyI+x4PlmKcVSFoN3oKgSYpVlmYxc194Ej04il/YmBg10xopy4zmtu5sdCP/uGSNYcNGWeAiw01
mNf98KyNgTUFXruHCA38qjhhEIvl4vfWWn3W3mFRxrIuwmnreT6qTvgMaxIkCdVBDP7Iy7O6WmCf
3Va5X5hnCHhtXgX5UYniBHiLjmupv63B8XMAYDH2n6mQ3H0DF7mtb7psBafd0Z6+IWUbmzwMtKrf
ZrRJBGAhNT0i1KrEjEh/rWjN7Z7N32zQ+Pl1kc5gYCQIX5McfdTdqSaRVXZ/HF90ymS7/8d5LDyj
Er+ORdcjnOn6oAyY4PuUUl4OYUHv5k+RglTe5Q==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bJa7kPSpDipzoJoQu1APEjc8vFLqBfQZK/grZvWijD7/FgMTerFCWLUY6n8DWeGdvjXvTeyrqCHE
2rP/H57wUqPC8tIJlGm6ZYQGjZ3TgYqLrJshDE5zYMTO//q0vuSraWvZP7A7SLuW6y7tFE/nplpx
L8gbYORx6j70okGUwnamCMS9yhFr7Z2QTJne1k4GNFGvy66URk3k5cBPl5j4/1yc4xGV+aWYl6L8
q8RorRU/CltObHKrji/jdiY1WtdGrkpRyCEFc+XNPazL9xSLLu5bz6XlvKwoks+8a5KYT/VFUovM
JbM0bpAXM8Z7rGaPuXjqXtZBg5praTZLu/WNcA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PYKBDinOGc/kIVdFzXrz2wA4/QNFxLDrQfTWfR5TjYE6bm49vrZi0bawcr9HXp4OP1+XxPLB3oCP
oV5e/rYeDln531ebt8yEg27XCoSHEX4FU8oG8aBJ8fqgWayOnAMJt025WodOxuZXbhT1zPo7J3uh
6iO9Mv7RtYE2fZ1W+G8oN//FTOEJYPWlKYnt0cDeZrN3I4rHHptZHuu7l8T+df0PYea3x6U3Mvkl
ojZ+TwQtdu0NuYY5j3QNgx3+W2XYq1M773FAnEz/deW54EjE+jf1jjrBk2pl8SYxeKuutS15oPVF
eHdqXYVcJxoUY5JH8z04lITKEnZ4oq6sYS6dog==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
tl+2vFCWZ583gQGsVC7oopz2NCKBiJ9uOHYBGzJZheOHJMqI/ehNvo25l710eBx00tztXzM30AH6
ZhAJg+kJwE2jO0MV5fmG5dnwXmLqoGEJMBs7xwWxvYK7w/0z9M0AJKD7HnuC+IiLhNU/fIxyuE+I
+vWqp//RcfY0tMMp2I2J1yEW6GUahS1ve/4JchssZ7Xu7VthoSDWXMQWATbvsUsDzeSo2+Ruz8Kq
Dc05HqEU8NgBxDPPEKLCcdKLp4byglwj7iCAtCjsPy8P18qjgb2sycFjNgmaiNMMB51WqeD+hneG
hLOue9bqVdEojkrb3q4WbsGZKz0bAGsryxslOlYHP1b8vey3yI2ixA80wyERe8d3GRIeZiSxGykH
qWxsE6x/iyi8QRb5mXZPMApA+Fln8tYmn7+1rFCm8gF4gJWhr1PsSJqTi658symGrzT0Ghjvf2QL
SvvoaeNdy0pOsWs7jLBFndd4GiFA+9K6Y33sziLToU9EvvFokENIslod

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oYiCujFRj1F3wKsGZlHR9niEtR9MLXEVAVfy+f/3xrmpW6Ye5a+fBCvm4TH+iRQefGHNdMPnzTNW
K/pEPAS9uMJjOdFiu+APT+LYrSRnEg4W0dX5buSDGM6LBWAuMseoTMjbJJoYDGLRckJgW43E30mX
ej4823nkbfwc+Ecbrup825qLyv8RTQLNHafvJA5lSapdqXwnlOIYRmcHn+sfAh5pGv9kW9aokcdh
ObR2XYxX99rYloyvz3x0pmjxD5ILW4SQMB1IUEuuyqX6eb5IQ+kZ41hjvsHIuQH29vzpCfV9Jqha
WC5yxxK1R+cleZSKD1H1gVzbTei8uFs/91Bgeg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
urNc+S8AFPj+GVFdqJE5V7P8O6QI6MA3nkwYb8NKbYbVufnXKg6voJIRYYeYr7EOa8mrqirozWbY
Lln9SLWnkaAy2LvL/N6WahoQdCt++4RH+xe768XvSrVUFPrIwZRixqMLurc/tPov4i5P/ukZKl18
ZPZvXRzUNlvCZnMPcF+5QCQihqPbjcZ0YyGgWgX/ipTGG3sNqmylGN7qLa4Rgqu/mB5a2xVyu5Wc
911+/X3VVFx697WVaP5V0SbOzYN8R8+8B8kdznwixMA+f4lSbBXyRysVOSzYjo8bKEMqyKMVBQn9
xDmEuV0DvVWXdO7VPvWA1LuJFwS07OxeI2GCcQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QcP7fsLZxaDrG29e9HQeXfu2TsKsdyW7Yc1vWct6lbmDEfXkWMU1fFWSPIjPzRc9UOnfEu0bRn+B
D+8MWokqes3WF7txljBmgUPiNGZ8arUU6ENa/IY/Wv7iaB/ZKM5PtdnFAkjDIrYyKFCTz/U6Yzwi
hBGGarK/wYQOLzeeKRewiPTiNUL7tztWuMZ1t1msxD951EeKrwjrjcXIIuf/TzrOGUOlWgjHlnrl
4Q/lfMAnRLBNTSWG+5wWewCE8jK2X/gJ5AV4p3x1WP3+JglbxpP39l3pzedXqciZPbuz2XlFnRPV
KByaUaAShzJ56p8+0HjWebibqQdieGNPiPWW0Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 43040)
`pragma protect data_block
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
c5ZBkj4=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
