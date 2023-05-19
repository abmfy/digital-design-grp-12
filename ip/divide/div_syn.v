// megafunction wizard: %LPM_DIVIDE%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_DIVIDE 

// ============================================================
// File Name: div.v
// Megafunction Name(s):
// 			LPM_DIVIDE
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 19.1.0 Build 670 09/22/2019 SJ Lite Edition
// ************************************************************


//Copyright (C) 2019  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and any partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel FPGA IP License Agreement, or other applicable license
//agreement, including, without limitation, that your use is for
//the sole purpose of programming logic devices manufactured by
//Intel and sold by Intel or its authorized distributors.  Please
//refer to the applicable agreement for further details, at
//https://fpgasoftware.intel.com/eula.


//lpm_divide DEVICE_FAMILY="Cyclone IV E" LPM_DREPRESENTATION="UNSIGNED" LPM_NREPRESENTATION="UNSIGNED" LPM_REMAINDERPOSITIVE="TRUE" LPM_WIDTHD=11 LPM_WIDTHN=11 MAXIMIZE_SPEED=6 denom numer quotient remain
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_abs 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_lpm_divide 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ cbx_util_mgl 2019:09:22:08:02:34:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



//sign_div_unsign DEN_REPRESENTATION="UNSIGNED" DEN_WIDTH=11 LPM_PIPELINE=0 MAXIMIZE_SPEED=6 NUM_REPRESENTATION="UNSIGNED" NUM_WIDTH=11 SKIP_BITS=0 denominator numerator quotient remainder
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_abs 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_lpm_divide 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ cbx_util_mgl 2019:09:22:08:02:34:SJ  VERSION_END


//alt_u_div DEVICE_FAMILY="Cyclone IV E" LPM_PIPELINE=0 MAXIMIZE_SPEED=6 SKIP_BITS=0 WIDTH_D=11 WIDTH_N=11 WIDTH_Q=11 WIDTH_R=11 denominator numerator quotient remainder
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_abs 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_lpm_divide 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ cbx_util_mgl 2019:09:22:08:02:34:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=1 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  div_add_sub
	( 
	cout,
	dataa,
	datab,
	result) /* synthesis synthesis_clearbox=1 */;
	output   cout;
	input   [0:0]  dataa;
	input   [0:0]  datab;
	output   [0:0]  result;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [0:0]  dataa;
	tri0   [0:0]  datab;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  [0:0]  carry_eqn;
	wire  cin_wire;
	wire  [0:0]  datab_node;
	wire  [0:0]  sum_eqn;

	assign
		carry_eqn = {((dataa[0] & datab_node[0]) | ((dataa[0] | datab_node[0]) & cin_wire))},
		cin_wire = 1'b1,
		cout = carry_eqn[0],
		datab_node = (~ datab),
		result = sum_eqn,
		sum_eqn = {((dataa[0] ^ datab_node[0]) ^ cin_wire)};
endmodule //div_add_sub


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=2 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  div_add_sub1
	( 
	cout,
	dataa,
	datab,
	result) /* synthesis synthesis_clearbox=1 */;
	output   cout;
	input   [1:0]  dataa;
	input   [1:0]  datab;
	output   [1:0]  result;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [1:0]  dataa;
	tri0   [1:0]  datab;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  [1:0]  carry_eqn;
	wire  cin_wire;
	wire  [1:0]  datab_node;
	wire  [1:0]  sum_eqn;

	assign
		carry_eqn = {((dataa[1] & datab_node[1]) | ((dataa[1] | datab_node[1]) & carry_eqn[0])), ((dataa[0] & datab_node[0]) | ((dataa[0] | datab_node[0]) & cin_wire))},
		cin_wire = 1'b1,
		cout = carry_eqn[1],
		datab_node = (~ datab),
		result = sum_eqn,
		sum_eqn = {((dataa[1] ^ datab_node[1]) ^ carry_eqn[0]), ((dataa[0] ^ datab_node[0]) ^ cin_wire)};
endmodule //div_add_sub1


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=11 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=3 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=4 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=5 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=6 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=7 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=8 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=9 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Cyclone IV E" LPM_DIRECTION="SUB" LPM_WIDTH=10 cout dataa datab result
//VERSION_BEGIN 19.1 cbx_cycloneii 2019:09:22:08:02:34:SJ cbx_lpm_add_sub 2019:09:22:08:02:34:SJ cbx_mgl 2019:09:22:09:26:20:SJ cbx_nadder 2019:09:22:08:02:34:SJ cbx_stratix 2019:09:22:08:02:34:SJ cbx_stratixii 2019:09:22:08:02:34:SJ  VERSION_END

//synthesis_resources = lut 72 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  div_alt_u_div
	( 
	denominator,
	numerator,
	quotient,
	remainder) /* synthesis synthesis_clearbox=1 */;
	input   [10:0]  denominator;
	input   [10:0]  numerator;
	output   [10:0]  quotient;
	output   [10:0]  remainder;

	wire  wire_add_sub_0_cout;
	wire  [0:0]   wire_add_sub_0_result;
	wire  wire_add_sub_1_cout;
	wire  [1:0]   wire_add_sub_1_result;
	wire	[11:0]	wire_add_sub_10_result_int;
	wire	wire_add_sub_10_cout;
	wire	[10:0]	wire_add_sub_10_dataa;
	wire	[10:0]	wire_add_sub_10_datab;
	wire	[10:0]	wire_add_sub_10_result;
	wire	[3:0]	wire_add_sub_2_result_int;
	wire	wire_add_sub_2_cout;
	wire	[2:0]	wire_add_sub_2_dataa;
	wire	[2:0]	wire_add_sub_2_datab;
	wire	[2:0]	wire_add_sub_2_result;
	wire	[4:0]	wire_add_sub_3_result_int;
	wire	wire_add_sub_3_cout;
	wire	[3:0]	wire_add_sub_3_dataa;
	wire	[3:0]	wire_add_sub_3_datab;
	wire	[3:0]	wire_add_sub_3_result;
	wire	[5:0]	wire_add_sub_4_result_int;
	wire	wire_add_sub_4_cout;
	wire	[4:0]	wire_add_sub_4_dataa;
	wire	[4:0]	wire_add_sub_4_datab;
	wire	[4:0]	wire_add_sub_4_result;
	wire	[6:0]	wire_add_sub_5_result_int;
	wire	wire_add_sub_5_cout;
	wire	[5:0]	wire_add_sub_5_dataa;
	wire	[5:0]	wire_add_sub_5_datab;
	wire	[5:0]	wire_add_sub_5_result;
	wire	[7:0]	wire_add_sub_6_result_int;
	wire	wire_add_sub_6_cout;
	wire	[6:0]	wire_add_sub_6_dataa;
	wire	[6:0]	wire_add_sub_6_datab;
	wire	[6:0]	wire_add_sub_6_result;
	wire	[8:0]	wire_add_sub_7_result_int;
	wire	wire_add_sub_7_cout;
	wire	[7:0]	wire_add_sub_7_dataa;
	wire	[7:0]	wire_add_sub_7_datab;
	wire	[7:0]	wire_add_sub_7_result;
	wire	[9:0]	wire_add_sub_8_result_int;
	wire	wire_add_sub_8_cout;
	wire	[8:0]	wire_add_sub_8_dataa;
	wire	[8:0]	wire_add_sub_8_datab;
	wire	[8:0]	wire_add_sub_8_result;
	wire	[10:0]	wire_add_sub_9_result_int;
	wire	wire_add_sub_9_cout;
	wire	[9:0]	wire_add_sub_9_dataa;
	wire	[9:0]	wire_add_sub_9_datab;
	wire	[9:0]	wire_add_sub_9_result;
	wire  [143:0]  DenominatorIn;
	wire  [143:0]  DenominatorIn_tmp;
	wire  gnd_wire;
	wire  [131:0]  nose;
	wire  [131:0]  NumeratorIn;
	wire  [131:0]  NumeratorIn_tmp;
	wire  [120:0]  prestg;
	wire  [10:0]  quotient_tmp;
	wire  [131:0]  sel;
	wire  [131:0]  selnose;
	wire  [131:0]  StageIn;
	wire  [131:0]  StageIn_tmp;
	wire  [120:0]  StageOut;

	div_add_sub   add_sub_0
	( 
	.cout(wire_add_sub_0_cout),
	.dataa(NumeratorIn[10]),
	.datab(DenominatorIn[0]),
	.result(wire_add_sub_0_result));
	div_add_sub1   add_sub_1
	( 
	.cout(wire_add_sub_1_cout),
	.dataa({StageIn[11], NumeratorIn[20]}),
	.datab(DenominatorIn[13:12]),
	.result(wire_add_sub_1_result));
	assign
		wire_add_sub_10_result_int = wire_add_sub_10_dataa - wire_add_sub_10_datab;
	assign
		wire_add_sub_10_result = wire_add_sub_10_result_int[10:0],
		wire_add_sub_10_cout = ~wire_add_sub_10_result_int[11:11];
	assign
		wire_add_sub_10_dataa = {StageIn[119:110], NumeratorIn[110]},
		wire_add_sub_10_datab = DenominatorIn[130:120];
	assign
		wire_add_sub_2_result_int = wire_add_sub_2_dataa - wire_add_sub_2_datab;
	assign
		wire_add_sub_2_result = wire_add_sub_2_result_int[2:0],
		wire_add_sub_2_cout = ~wire_add_sub_2_result_int[3:3];
	assign
		wire_add_sub_2_dataa = {StageIn[23:22], NumeratorIn[30]},
		wire_add_sub_2_datab = DenominatorIn[26:24];
	assign
		wire_add_sub_3_result_int = wire_add_sub_3_dataa - wire_add_sub_3_datab;
	assign
		wire_add_sub_3_result = wire_add_sub_3_result_int[3:0],
		wire_add_sub_3_cout = ~wire_add_sub_3_result_int[4:4];
	assign
		wire_add_sub_3_dataa = {StageIn[35:33], NumeratorIn[40]},
		wire_add_sub_3_datab = DenominatorIn[39:36];
	assign
		wire_add_sub_4_result_int = wire_add_sub_4_dataa - wire_add_sub_4_datab;
	assign
		wire_add_sub_4_result = wire_add_sub_4_result_int[4:0],
		wire_add_sub_4_cout = ~wire_add_sub_4_result_int[5:5];
	assign
		wire_add_sub_4_dataa = {StageIn[47:44], NumeratorIn[50]},
		wire_add_sub_4_datab = DenominatorIn[52:48];
	assign
		wire_add_sub_5_result_int = wire_add_sub_5_dataa - wire_add_sub_5_datab;
	assign
		wire_add_sub_5_result = wire_add_sub_5_result_int[5:0],
		wire_add_sub_5_cout = ~wire_add_sub_5_result_int[6:6];
	assign
		wire_add_sub_5_dataa = {StageIn[59:55], NumeratorIn[60]},
		wire_add_sub_5_datab = DenominatorIn[65:60];
	assign
		wire_add_sub_6_result_int = wire_add_sub_6_dataa - wire_add_sub_6_datab;
	assign
		wire_add_sub_6_result = wire_add_sub_6_result_int[6:0],
		wire_add_sub_6_cout = ~wire_add_sub_6_result_int[7:7];
	assign
		wire_add_sub_6_dataa = {StageIn[71:66], NumeratorIn[70]},
		wire_add_sub_6_datab = DenominatorIn[78:72];
	assign
		wire_add_sub_7_result_int = wire_add_sub_7_dataa - wire_add_sub_7_datab;
	assign
		wire_add_sub_7_result = wire_add_sub_7_result_int[7:0],
		wire_add_sub_7_cout = ~wire_add_sub_7_result_int[8:8];
	assign
		wire_add_sub_7_dataa = {StageIn[83:77], NumeratorIn[80]},
		wire_add_sub_7_datab = DenominatorIn[91:84];
	assign
		wire_add_sub_8_result_int = wire_add_sub_8_dataa - wire_add_sub_8_datab;
	assign
		wire_add_sub_8_result = wire_add_sub_8_result_int[8:0],
		wire_add_sub_8_cout = ~wire_add_sub_8_result_int[9:9];
	assign
		wire_add_sub_8_dataa = {StageIn[95:88], NumeratorIn[90]},
		wire_add_sub_8_datab = DenominatorIn[104:96];
	assign
		wire_add_sub_9_result_int = wire_add_sub_9_dataa - wire_add_sub_9_datab;
	assign
		wire_add_sub_9_result = wire_add_sub_9_result_int[9:0],
		wire_add_sub_9_cout = ~wire_add_sub_9_result_int[10:10];
	assign
		wire_add_sub_9_dataa = {StageIn[107:99], NumeratorIn[100]},
		wire_add_sub_9_datab = DenominatorIn[117:108];
	assign
		DenominatorIn = DenominatorIn_tmp,
		DenominatorIn_tmp = {DenominatorIn[131:0], {gnd_wire, denominator}},
		gnd_wire = 1'b0,
		nose = {{11{1'b0}}, wire_add_sub_10_cout, {11{1'b0}}, wire_add_sub_9_cout, {11{1'b0}}, wire_add_sub_8_cout, {11{1'b0}}, wire_add_sub_7_cout, {11{1'b0}}, wire_add_sub_6_cout, {11{1'b0}}, wire_add_sub_5_cout, {11{1'b0}}, wire_add_sub_4_cout, {11{1'b0}}, wire_add_sub_3_cout, {11{1'b0}}, wire_add_sub_2_cout, {11{1'b0}}, wire_add_sub_1_cout, {11{1'b0}}, wire_add_sub_0_cout},
		NumeratorIn = NumeratorIn_tmp,
		NumeratorIn_tmp = {NumeratorIn[120:0], numerator},
		prestg = {wire_add_sub_10_result, {1{1'b0}}, wire_add_sub_9_result, {2{1'b0}}, wire_add_sub_8_result, {3{1'b0}}, wire_add_sub_7_result, {4{1'b0}}, wire_add_sub_6_result, {5{1'b0}}, wire_add_sub_5_result, {6{1'b0}}, wire_add_sub_4_result, {7{1'b0}}, wire_add_sub_3_result, {8{1'b0}}, wire_add_sub_2_result, {9{1'b0}}, wire_add_sub_1_result, {10{1'b0}}, wire_add_sub_0_result},
		quotient = quotient_tmp,
		quotient_tmp = {(~ selnose[0]), (~ selnose[12]), (~ selnose[24]), (~ selnose[36]), (~ selnose[48]), (~ selnose[60]), (~ selnose[72]), (~ selnose[84]), (~ selnose[96]), (~ selnose[108]), (~ selnose[120])},
		remainder = StageIn[131:121],
		sel = {gnd_wire, (sel[131] | DenominatorIn[142]), (sel[130] | DenominatorIn[141]), (sel[129] | DenominatorIn[140]), (sel[128] | DenominatorIn[139]), (sel[127] | DenominatorIn[138]), (sel[126] | DenominatorIn[137]), (sel[125] | DenominatorIn[136]), (sel[124] | DenominatorIn[135]), (sel[123] | DenominatorIn[134]), (sel[122] | DenominatorIn[133]), gnd_wire, (sel[120] | DenominatorIn[130]), (sel[119] | DenominatorIn[129]), (sel[118] | DenominatorIn[128]), (sel[117] | DenominatorIn[127]), (sel[116] | DenominatorIn[126]), (sel[115] | DenominatorIn[125]), (sel[114] | DenominatorIn[124]), (sel[113] | DenominatorIn[123]), (sel[112] | DenominatorIn[122]), (sel[111] | DenominatorIn[121]), gnd_wire, (sel[109] | DenominatorIn[118]), (sel[108] | DenominatorIn[117]), (sel[107] | DenominatorIn[116]), (sel[106] | DenominatorIn[115]), (sel[105] | DenominatorIn[114]), (sel[104] | DenominatorIn[113]), (sel[103] | DenominatorIn[112]), (sel[102] | DenominatorIn[111]), (sel[101] | DenominatorIn[110]), (sel[100] | DenominatorIn[109]), gnd_wire, (sel[98] | DenominatorIn[106]), (sel[97] | DenominatorIn[105]), (sel[96] | DenominatorIn[104]), (sel[95] | DenominatorIn[103]), (sel[94] | DenominatorIn[102]), (sel[93] | DenominatorIn[101]), (sel[92] | DenominatorIn[100]), (sel[91] | DenominatorIn[99]), (sel[90] | DenominatorIn[98]), (sel[89] | DenominatorIn[97]), gnd_wire, (sel[87] | DenominatorIn[94]), (sel[86] | DenominatorIn[93]), (sel[85] | DenominatorIn[92]), (sel[84] | DenominatorIn[91]), (sel[83] | DenominatorIn[90]), (sel[82] | DenominatorIn[89]), (sel[81] | DenominatorIn[88]), (sel[80] | DenominatorIn[87]), (sel[79] | DenominatorIn[86]), (sel[78] | DenominatorIn[85]), gnd_wire, (sel[76] | DenominatorIn[82]), (sel[75] | DenominatorIn[81]), (sel[74] | DenominatorIn[80]), (sel[73] | DenominatorIn[79]), (sel[72] | DenominatorIn[78]), (sel[71] | DenominatorIn[77]), (sel[70] | DenominatorIn[76]), (sel[69] | DenominatorIn[75]), (sel[68] | DenominatorIn[74]), (sel[67] | DenominatorIn[73]), gnd_wire, (sel[65] | DenominatorIn[70]), (sel[64] | DenominatorIn[69]
), (sel[63] | DenominatorIn[68]), (sel[62] | DenominatorIn[67]), (sel[61] | DenominatorIn[66]), (sel[60] | DenominatorIn[65]), (sel[59] | DenominatorIn[64]), (sel[58] | DenominatorIn[63]), (sel[57] | DenominatorIn[62]), (sel[56] | DenominatorIn[61]), gnd_wire, (sel[54] | DenominatorIn[58]), (sel[53] | DenominatorIn[57]), (sel[52] | DenominatorIn[56]), (sel[51] | DenominatorIn[55]), (sel[50] | DenominatorIn[54]), (sel[49] | DenominatorIn[53]), (sel[48] | DenominatorIn[52]), (sel[47] | DenominatorIn[51]), (sel[46] | DenominatorIn[50]), (sel[45] | DenominatorIn[49]), gnd_wire, (sel[43] | DenominatorIn[46]), (sel[42] | DenominatorIn[45]), (sel[41] | DenominatorIn[44]), (sel[40] | DenominatorIn[43]), (sel[39] | DenominatorIn[42]), (sel[38] | DenominatorIn[41]), (sel[37] | DenominatorIn[40]), (sel[36] | DenominatorIn[39]), (sel[35] | DenominatorIn[38]), (sel[34] | DenominatorIn[37]), gnd_wire, (sel[32] | DenominatorIn[34]), (sel[31] | DenominatorIn[33]), (sel[30] | DenominatorIn[32]), (sel[29] | DenominatorIn[31]), (sel[28] | DenominatorIn[30]), (sel[27] | DenominatorIn[29]), (sel[26] | DenominatorIn[28]), (sel[25] | DenominatorIn[27]), (sel[24] | DenominatorIn[26]), (sel[23] | DenominatorIn[25]), gnd_wire, (sel[21] | DenominatorIn[22]), (sel[20] | DenominatorIn[21]), (sel[19] | DenominatorIn[20]), (sel[18] | DenominatorIn[19]), (sel[17] | DenominatorIn[18]), (sel[16] | DenominatorIn[17]), (sel[15] | DenominatorIn[16]), (sel[14] | DenominatorIn[15]), (sel[13] | DenominatorIn[14]), (sel[12] | DenominatorIn[13]), gnd_wire, (sel[10] | DenominatorIn[10]), (sel[9] | DenominatorIn[9]), (sel[8] | DenominatorIn[8]), (sel[7] | DenominatorIn[7]), (sel[6] | DenominatorIn[6]), (sel[5] | DenominatorIn[5]), (sel[4] | DenominatorIn[4]), (sel[3] | DenominatorIn[3]), (sel[2] | DenominatorIn[2]), (sel[1] | DenominatorIn[1])},
		selnose = {((~ nose[131]) | sel[131]), ((~ nose[130]) | sel[130]), ((~ nose[129]) | sel[129]), ((~ nose[128]) | sel[128]), ((~ nose[127]) | sel[127]), ((~ nose[126]) | sel[126]), ((~ nose[125]) | sel[125]), ((~ nose[124]) | sel[124]), ((~ nose[123]) | sel[123]), ((~ nose[122]) | sel[122]), ((~ nose[121]) | sel[121]), ((~ nose[120]) | sel[120]), ((~ nose[119]) | sel[119]), ((~ nose[118]) | sel[118]), ((~ nose[117]) | sel[117]), ((~ nose[116]) | sel[116]), ((~ nose[115]) | sel[115]), ((~ nose[114]) | sel[114]), ((~ nose[113]) | sel[113]), ((~ nose[112]) | sel[112]), ((~ nose[111]) | sel[111]), ((~ nose[110]) | sel[110]), ((~ nose[109]) | sel[109]), ((~ nose[108]) | sel[108]), ((~ nose[107]) | sel[107]), ((~ nose[106]) | sel[106]), ((~ nose[105]) | sel[105]), ((~ nose[104]) | sel[104]), ((~ nose[103]) | sel[103]), ((~ nose[102]) | sel[102]), ((~ nose[101]) | sel[101]), ((~ nose[100]) | sel[100]), ((~ nose[99]) | sel[99]), ((~ nose[98]) | sel[98]), ((~ nose[97]) | sel[97]), ((~ nose[96]) | sel[96]), ((~ nose[95]) | sel[95]), ((~ nose[94]) | sel[94]), ((~ nose[93]) | sel[93]), ((~ nose[92]) | sel[92]), ((~ nose[91]) | sel[91]), ((~ nose[90]) | sel[90]), ((~ nose[89]) | sel[89]), ((~ nose[88]) | sel[88]), ((~ nose[87]) | sel[87]), ((~ nose[86]) | sel[86]), ((~ nose[85]) | sel[85]), ((~ nose[84]) | sel[84]), ((~ nose[83]) | sel[83]), ((~ nose[82]) | sel[82]), ((~ nose[81]) | sel[81]), ((~ nose[80]) | sel[80]), ((~ nose[79]) | sel[79]), ((~ nose[78]) | sel[78]), ((~ nose[77]) | sel[77]), ((~ nose[76]) | sel[76]), ((~ nose[75]) | sel[75]), ((~ nose[74]) | sel[74]), ((~ nose[73]) | sel[73]), ((~ nose[72]) | sel[72]), ((~ nose[71]) | sel[71]), ((~ nose[70]) | sel[70]), ((~ nose[69]) | sel[69]), ((~ nose[68]) | sel[68]), ((~ nose[67]) | sel[67]), ((~ nose[66]) | sel[66]), ((~ nose[65]) | sel[65]), ((~ nose[64]) | sel[64]), ((~ nose[63]) | sel[63]), ((~ nose[62]) | sel[62]), ((~ nose[61]) | sel[61]), ((~ nose[60]) | sel[60]), ((~ nose[59]) | sel[59]), ((~ nose[58]) | sel[58]), ((~ nose[57]) | sel[57]), ((~ nose[56]) | sel[56]
), ((~ nose[55]) | sel[55]), ((~ nose[54]) | sel[54]), ((~ nose[53]) | sel[53]), ((~ nose[52]) | sel[52]), ((~ nose[51]) | sel[51]), ((~ nose[50]) | sel[50]), ((~ nose[49]) | sel[49]), ((~ nose[48]) | sel[48]), ((~ nose[47]) | sel[47]), ((~ nose[46]) | sel[46]), ((~ nose[45]) | sel[45]), ((~ nose[44]) | sel[44]), ((~ nose[43]) | sel[43]), ((~ nose[42]) | sel[42]), ((~ nose[41]) | sel[41]), ((~ nose[40]) | sel[40]), ((~ nose[39]) | sel[39]), ((~ nose[38]) | sel[38]), ((~ nose[37]) | sel[37]), ((~ nose[36]) | sel[36]), ((~ nose[35]) | sel[35]), ((~ nose[34]) | sel[34]), ((~ nose[33]) | sel[33]), ((~ nose[32]) | sel[32]), ((~ nose[31]) | sel[31]), ((~ nose[30]) | sel[30]), ((~ nose[29]) | sel[29]), ((~ nose[28]) | sel[28]), ((~ nose[27]) | sel[27]), ((~ nose[26]) | sel[26]), ((~ nose[25]) | sel[25]), ((~ nose[24]) | sel[24]), ((~ nose[23]) | sel[23]), ((~ nose[22]) | sel[22]), ((~ nose[21]) | sel[21]), ((~ nose[20]) | sel[20]), ((~ nose[19]) | sel[19]), ((~ nose[18]) | sel[18]), ((~ nose[17]) | sel[17]), ((~ nose[16]) | sel[16]), ((~ nose[15]) | sel[15]), ((~ nose[14]) | sel[14]), ((~ nose[13]) | sel[13]), ((~ nose[12]) | sel[12]), ((~ nose[11]) | sel[11]), ((~ nose[10]) | sel[10]), ((~ nose[9]) | sel[9]), ((~ nose[8]) | sel[8]), ((~ nose[7]) | sel[7]), ((~ nose[6]) | sel[6]), ((~ nose[5]) | sel[5]), ((~ nose[4]) | sel[4]), ((~ nose[3]) | sel[3]), ((~ nose[2]) | sel[2]), ((~ nose[1]) | sel[1]), ((~ nose[0]) | sel[0])},
		StageIn = StageIn_tmp,
		StageIn_tmp = {StageOut[120:0], {11{1'b0}}},
		StageOut = {(({StageIn[119:110], NumeratorIn[110]} & {11{selnose[120]}}) | (prestg[120:110] & {11{(~ selnose[120])}})), (({StageIn[108:99], NumeratorIn[100]} & {11{selnose[108]}}) | (prestg[109:99] & {11{(~ selnose[108])}})), (({StageIn[97:88], NumeratorIn[90]} & {11{selnose[96]}}) | (prestg[98:88] & {11{(~ selnose[96])}})), (({StageIn[86:77], NumeratorIn[80]} & {11{selnose[84]}}) | (prestg[87:77] & {11{(~ selnose[84])}})), (({StageIn[75:66], NumeratorIn[70]} & {11{selnose[72]}}) | (prestg[76:66] & {11{(~ selnose[72])}})), (({StageIn[64:55], NumeratorIn[60]} & {11{selnose[60]}}) | (prestg[65:55] & {11{(~ selnose[60])}})), (({StageIn[53:44], NumeratorIn[50]} & {11{selnose[48]}}) | (prestg[54:44] & {11{(~ selnose[48])}})), (({StageIn[42:33], NumeratorIn[40]} & {11{selnose[36]}}) | (prestg[43:33] & {11{(~ selnose[36])}})), (({StageIn[31:22], NumeratorIn[30]} & {11{selnose[24]}}) | (prestg[32:22] & {11{(~ selnose[24])}})), (({StageIn[20:11], NumeratorIn[20]} & {11{selnose[12]}}) | (prestg[21:11] & {11{(~ selnose[12])}})), (({StageIn[9:0], NumeratorIn[10]} & {11{selnose[0]}}) | (prestg[10:0] & {11{(~ selnose[0])}}))};
endmodule //div_alt_u_div

//synthesis_resources = lut 72 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  div_sign_div_unsign
	( 
	denominator,
	numerator,
	quotient,
	remainder) /* synthesis synthesis_clearbox=1 */;
	input   [10:0]  denominator;
	input   [10:0]  numerator;
	output   [10:0]  quotient;
	output   [10:0]  remainder;

	wire  [10:0]   wire_divider_quotient;
	wire  [10:0]   wire_divider_remainder;
	wire  [10:0]  norm_num;
	wire  [10:0]  protect_quotient;
	wire  [10:0]  protect_remainder;

	div_alt_u_div   divider
	( 
	.denominator(denominator),
	.numerator(norm_num),
	.quotient(wire_divider_quotient),
	.remainder(wire_divider_remainder));
	assign
		norm_num = numerator,
		protect_quotient = wire_divider_quotient,
		protect_remainder = wire_divider_remainder,
		quotient = protect_quotient,
		remainder = protect_remainder;
endmodule //div_sign_div_unsign

//synthesis_resources = lut 72 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  div_lpm_divide
	( 
	denom,
	numer,
	quotient,
	remain) /* synthesis synthesis_clearbox=1 */;
	input   [10:0]  denom;
	input   [10:0]  numer;
	output   [10:0]  quotient;
	output   [10:0]  remain;

	wire  [10:0]   wire_divider_quotient;
	wire  [10:0]   wire_divider_remainder;
	wire  [10:0]  numer_tmp;

	div_sign_div_unsign   divider
	( 
	.denominator(denom),
	.numerator(numer_tmp),
	.quotient(wire_divider_quotient),
	.remainder(wire_divider_remainder));
	assign
		numer_tmp = numer,
		quotient = wire_divider_quotient,
		remain = wire_divider_remainder;
endmodule //div_lpm_divide
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module div (
	denom,
	numer,
	quotient,
	remain)/* synthesis synthesis_clearbox = 1 */;

	input	[10:0]  denom;
	input	[10:0]  numer;
	output	[10:0]  quotient;
	output	[10:0]  remain;

	wire [10:0] sub_wire0;
	wire [10:0] sub_wire1;
	wire [10:0] quotient = sub_wire0[10:0];
	wire [10:0] remain = sub_wire1[10:0];

	div_lpm_divide	div_lpm_divide_component (
				.denom (denom),
				.numer (numer),
				.quotient (sub_wire0),
				.remain (sub_wire1));

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: PRIVATE_LPM_REMAINDERPOSITIVE STRING "TRUE"
// Retrieval info: PRIVATE: PRIVATE_MAXIMIZE_SPEED NUMERIC "6"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "1"
// Retrieval info: PRIVATE: USING_PIPELINE NUMERIC "0"
// Retrieval info: PRIVATE: VERSION_NUMBER NUMERIC "2"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_DREPRESENTATION STRING "UNSIGNED"
// Retrieval info: CONSTANT: LPM_HINT STRING "MAXIMIZE_SPEED=6,LPM_REMAINDERPOSITIVE=TRUE"
// Retrieval info: CONSTANT: LPM_NREPRESENTATION STRING "UNSIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_DIVIDE"
// Retrieval info: CONSTANT: LPM_WIDTHD NUMERIC "11"
// Retrieval info: CONSTANT: LPM_WIDTHN NUMERIC "11"
// Retrieval info: USED_PORT: denom 0 0 11 0 INPUT NODEFVAL "denom[10..0]"
// Retrieval info: USED_PORT: numer 0 0 11 0 INPUT NODEFVAL "numer[10..0]"
// Retrieval info: USED_PORT: quotient 0 0 11 0 OUTPUT NODEFVAL "quotient[10..0]"
// Retrieval info: USED_PORT: remain 0 0 11 0 OUTPUT NODEFVAL "remain[10..0]"
// Retrieval info: CONNECT: @denom 0 0 11 0 denom 0 0 11 0
// Retrieval info: CONNECT: @numer 0 0 11 0 numer 0 0 11 0
// Retrieval info: CONNECT: quotient 0 0 11 0 @quotient 0 0 11 0
// Retrieval info: CONNECT: remain 0 0 11 0 @remain 0 0 11 0
// Retrieval info: GEN_FILE: TYPE_NORMAL div.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL div.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL div.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL div.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL div_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL div_bb.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL div_syn.v TRUE
// Retrieval info: LIB_FILE: lpm
