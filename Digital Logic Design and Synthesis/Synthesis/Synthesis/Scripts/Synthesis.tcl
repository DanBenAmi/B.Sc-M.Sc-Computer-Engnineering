###########################################################
#
###########################################################

remove_design -designs

##############################################################
###################Defines Design Libraries###################
##############################################################

# Read in design defaults
source Scripts/Setup.tcl


##############################################################
############Read The Design Then Setting Top Level############
##############################################################

## ANALYZE FILES

# packages

# sourcecode
analyze -library WORK -format sverilog {apb.sv}
analyze -library WORK -format sverilog {control_unit.sv}
analyze -library WORK -format sverilog {decoder.sv}
analyze -library WORK -format sverilog {ecc_enc_dec.sv}
analyze -library WORK -format sverilog {encode_H1.sv}
analyze -library WORK -format sverilog {encode_H2.sv}
analyze -library WORK -format sverilog {encode_H3.sv}
analyze -library WORK -format sverilog {encoder.sv}
analyze -library WORK -format sverilog {mat_mult.sv}
analyze -library WORK -format sverilog {mat_mult_1.sv}
analyze -library WORK -format sverilog {mat_mult_2.sv}
analyze -library WORK -format sverilog {mat_mult_3.sv}
analyze -library WORK -format sverilog {mux_H1.sv}
analyze -library WORK -format sverilog {mux_H2.sv}
analyze -library WORK -format sverilog {mux_H3.sv}
analyze -library WORK -format sverilog {noise_adder.sv}
analyze -library WORK -format sverilog {op_done_logic.sv}
analyze -library WORK -format sverilog {register_file.sv}
#current_design Visible_Watermarking


## ELABORATE TOP
elaborate ecc_enc_dec -architecture verilog -library WORK

# Post elaboration save design
file mkdir save/
write -f ddc -h -o save/post_elaboration.ddc
write -f verilog -h -o save/post_elaboration.sv

#Provide unique names
uniquify

##############################################################
#######################Read Constraints#######################
##############################################################

# === Compile top ====================================================
current_design ecc_enc_dec
link

# Read in the SDC constraints
source Constrains.sdc


##############################################################
##################Compile/Synthesize Design###################
##############################################################

compile

###################################
#   Post Synthesis Reports        #
###################################
file mkdir reports
check_design > reports/check_design.rpt
report_timing  > reports/syn_timing.rep
report_area > reports/syn_area.rep
report_power > reports/syn_power_woCG_woSAIF.rep
report_constraint -all_violators > reports/syn_constrains.rep

report_area -hierarchy > reports/syn_hierarchy_area.rpt
report_hierarchy -full > reports/syn_hierarchy.rpt
report_timing -delay min  > reports/syn_hold_timing.rep

all_registers > reports/all_registers.rpt
all_designs > reports/all_designs.rpt
report_clock_gating > reports/syn_clock_gating.rpt
report_wire_load > reports/syn_wire_load.rpt
report_clocks -skew -attributes > reports/syn_report_clocks.rpt

# Post synthesis save design
write -f ddc -h -o save/post_synthesis.ddc

##########################
#   Export Design        #
##########################

#export sdc constraints for encounter
file mkdir outputs

write -h -f verilog -o outputs/ecc_enc_dec.sv

#save the SDF file
write_sdf outputs/top.sdf


###################
# Compile Ultra   #
# #################
file mkdir compile_ultra_results
compile_ultra

report_timing  > compile_ultra_results/syn_timing.rep
report_area > compile_ultra_results/syn_area.rep
report_power > compile_ultra_results/syn_power_woCG_woSAIF.rep
report_constraint -all_violators > compile_ultra_results/syn_constrains.rep
report_area -hierarchy > compile_ultra_results/syn_hierarchy_area.rpt
report_hierarchy -full > compile_ultra_results/syn_hierarchy.rpt

write -h -f verilog -o outputs/ecc_enc_dec.sv

