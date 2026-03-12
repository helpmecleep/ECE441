// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Mar  5 15:01:51 2026
// Host        : ws11-04 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ line_buffer_sim_netlist.v
// Design      : line_buffer
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "line_buffer,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_9 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 43200)
`pragma protect data_block
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
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
