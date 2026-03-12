if { [info exist ::env(OS)] } { puts "Windows system"  } else { puts "Linux system" }

cd ..
create_project camera_using_external_memory camera_using_external_memory -part xc7a100tcsg324-1
cd ./camera_using_external_memory
set_property target_language VHDL [current_project]

#
# Add the source files and the constraint file
#

add_files -norecurse {./i2c_sender.vhd ./histogram.vhd ./ov7670_registers.vhd ./ov7670_controller.vhd ./effects/rgb_to_gray.vhd ./video_timing.vhd ./camera.vhd ./ov7670_capture.vhd ./debouncer.vhd ./video.vhd}
add_files -norecurse {./effects/sobel.vhd ./effects/negative.vhd ./effects/xor.vhd ./effects/sad.vhd ./oled_display.vhd}
add_files -fileset constrs_1 -norecurse ./Nexys-A7-100T-Master.xdc
update_compile_order -fileset sources_1
update_compile_order -fileset sources_1



#
# Create mig ddr 2 interface
#

create_ip -name mig_7series -vendor xilinx.com -library ip -version 4.0 -module_name ddr

if { [info exist ::env(OS)] } { exec cp.bat  mig_a.prj camera_using_external_memory.srcs\\sources_1\\ip\\ddr\\  } else { exec cp ./mig_a.prj camera_using_external_memory.srcs/sources_1/ip/ddr/ }

#exec cp ./mig_a.prj camera_using_external_memory.srcs/sources_1/ip/ddr/

set_property -dict [list CONFIG.XML_INPUT_FILE {mig_a.prj} CONFIG.RESET_BOARD_INTERFACE {Custom} CONFIG.MIG_DONT_TOUCH_PARAM {Custom} CONFIG.BOARD_MIG_PARAM {Custom}] [get_ips ddr]
generate_target {instantiation_template} [get_files ./camera_using_external_memory.srcs/sources_1/ip/ddr/ddr.xci]

generate_target all [get_files  ./camera_using_external_memory.srcs/sources_1/ip/ddr/ddr.xci]

catch { config_ip_cache -export [get_ips -all ddr] }
export_ip_user_files -of_objects [get_files ./camera_using_external_memory.srcs/sources_1/ip/ddr/ddr.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ./camera_using_external_memory.srcs/sources_1/ip/ddr/ddr.xci]
launch_runs -jobs 4 ddr_synth_1


export_simulation -of_objects [get_files ./camera_using_external_memory.srcs/sources_1/ip/ddr/ddr.xci] -directory ./camera_using_external_memory.ip_user_files/sim_scripts -ip_user_files_dir ./camera_using_external_memory.ip_user_files -ipstatic_source_dir ./camera_using_external_memory.ip_user_files/ipstatic -lib_map_path [list {modelsim=./camera_using_external_memory.cache/compile_simlib/modelsim} {questa=./camera_using_external_memory.cache/compile_simlib/questa} {ies=./camera_using_external_memory.cache/compile_simlib/ies} {vcs=./camera_using_external_memory.cache/compile_simlib/vcs} {riviera=./camera_using_external_memory.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet


#
# create block memory line buffer
#

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name line_buffer
set_property -dict [list CONFIG.Component_Name {line_buffer} CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Write_Width_A {96} CONFIG.Write_Depth_A {80} CONFIG.Read_Width_A {96} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Write_Width_B {96} CONFIG.Read_Width_B {96} CONFIG.Enable_B {Always_Enabled} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {true} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100}] [get_ips line_buffer]

generate_target {instantiation_template} [get_files ./camera_using_external_memory.srcs/sources_1/ip/line_buffer/line_buffer.xci]

update_compile_order -fileset sources_1
generate_target all [get_files  ./camera_using_external_memory.srcs/sources_1/ip/line_buffer/line_buffer.xci]

catch { config_ip_cache -export [get_ips -all line_buffer] }
export_ip_user_files -of_objects [get_files ./camera_using_external_memory.srcs/sources_1/ip/line_buffer/line_buffer.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ./camera_using_external_memory.srcs/sources_1/ip/line_buffer/line_buffer.xci]
launch_runs -jobs 4 line_buffer_synth_1

export_simulation -of_objects [get_files ./camera_using_external_memory.srcs/sources_1/ip/line_buffer/line_buffer.xci] -directory ./camera_using_external_memory.ip_user_files/sim_scripts -ip_user_files_dir ./camera_using_external_memory.ip_user_files -ipstatic_source_dir ./camera_using_external_memory.ip_user_files/ipstatic -lib_map_path [list {modelsim=./camera_using_external_memory.cache/compile_simlib/modelsim} {questa=./camera_using_external_memory.cache/compile_simlib/questa} {ies=./camera_using_external_memory.cache/compile_simlib/ies} {vcs=./camera_using_external_memory.cache/compile_simlib/vcs} {riviera=./camera_using_external_memory.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet

#
# Create the clock system
#

create_ip -name clk_wiz -vendor xilinx.com -library ip -version 5.4 -module_name clk_wiz_0

set_property -dict [list CONFIG.CLKOUT2_USED {true} CONFIG.CLK_OUT1_PORT {clk_200Mhz} CONFIG.CLK_OUT2_PORT {clk_camera} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {12.000} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false} CONFIG.MMCM_DIVCLK_DIVIDE {1} CONFIG.MMCM_CLKFBOUT_MULT_F {9.000} CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.500} CONFIG.MMCM_CLKOUT1_DIVIDE {75} CONFIG.MMCM_CLKOUT2_DIVIDE {12} CONFIG.NUM_OUT_CLKS {2} CONFIG.CLKOUT1_JITTER {120.598} CONFIG.CLKOUT1_PHASE_ERROR {105.461} CONFIG.CLKOUT2_JITTER {211.763} CONFIG.CLKOUT2_PHASE_ERROR {105.461} ] [get_ips clk_wiz_0]

set_property -dict [list CONFIG.CLKOUT3_USED {true} CONFIG.CLK_OUT3_PORT {clk_5Mhz} CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {5.000} CONFIG.MMCM_DIVCLK_DIVIDE {1} CONFIG.MMCM_CLKFBOUT_MULT_F {6.000} CONFIG.MMCM_CLKIN1_PERIOD {10.0} CONFIG.MMCM_CLKIN2_PERIOD {10.0} CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.000} CONFIG.MMCM_CLKOUT1_DIVIDE {50} CONFIG.MMCM_CLKOUT2_DIVIDE {120} CONFIG.NUM_OUT_CLKS {3} CONFIG.CLKOUT1_JITTER {132.221} CONFIG.CLKOUT1_PHASE_ERROR {132.063} CONFIG.CLKOUT2_JITTER {231.952} CONFIG.CLKOUT2_PHASE_ERROR {132.063} CONFIG.CLKOUT3_JITTER {275.378} CONFIG.CLKOUT3_PHASE_ERROR {132.063}] [get_ips clk_wiz_0]

generate_target {instantiation_template} [get_files ./camera_using_external_memory.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci]


generate_target all [get_files  ./camera_using_external_memory.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci]

catch { config_ip_cache -export [get_ips -all clk_wiz_0] }
export_ip_user_files -of_objects [get_files ./camera_using_external_memory.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ./camera_using_external_memory.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci]
launch_runs -jobs 4 clk_wiz_0_synth_1



export_simulation -of_objects [get_files ./camera_using_external_memory.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci] -directory ./camera_using_external_memory.ip_user_files/sim_scripts -ip_user_files_dir ./camera_using_external_memory.ip_user_files -ipstatic_source_dir ./camera_using_external_memory.ip_user_files/ipstatic -lib_map_path [list {modelsim=./camera_using_external_memory.cache/compile_simlib/modelsim} {questa=./camera_using_external_memory.cache/compile_simlib/questa} {ies=./camera_using_external_memory.cache/compile_simlib/ies} {vcs=./camera_using_external_memory.cache/compile_simlib/vcs} {riviera=./camera_using_external_memory.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet

#
# Create the bit file
#
launch_runs impl_1 -to_step write_bitstream -jobs 4
