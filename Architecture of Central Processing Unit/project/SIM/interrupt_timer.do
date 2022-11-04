onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_tb/U_0/GIE
add wave -noupdate -radix hexadecimal /mips_tb/Instruction_out
add wave -noupdate /mips_tb/clock
add wave -noupdate -radix hexadecimal /mips_tb/U_0/IFE/Instruction
add wave -noupdate /mips_tb/U_0/IFE/jal
add wave -noupdate /mips_tb/U_0/IFE/jr
add wave -noupdate -radix hexadecimal /mips_tb/U_0/IFE/PC
add wave -noupdate -radix hexadecimal -childformat {{/mips_tb/U_0/ID/register_array(0) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(1) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(2) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(3) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(4) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(5) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(6) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(7) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(8) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(9) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(10) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(11) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(12) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(13) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(14) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(15) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(16) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(17) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(18) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(19) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(20) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(21) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(22) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(23) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(24) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(25) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(26) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(27) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(28) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(29) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(30) -radix hexadecimal} {/mips_tb/U_0/ID/register_array(31) -radix hexadecimal}} -subitemconfig {/mips_tb/U_0/ID/register_array(0) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(1) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(2) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(3) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(4) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(5) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(6) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(7) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(8) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(9) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(10) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(11) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(12) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(13) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(14) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(15) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(16) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(17) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(18) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(19) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(20) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(21) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(22) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(23) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(24) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(25) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(26) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(27) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(28) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(29) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(30) {-height 15 -radix hexadecimal} /mips_tb/U_0/ID/register_array(31) {-height 15 -radix hexadecimal}} /mips_tb/U_0/ID/register_array
add wave -noupdate /mips_tb/U_0/key0
add wave -noupdate /mips_tb/U_0/IFE/intr
add wave -noupdate /mips_tb/U_0/inta
add wave -noupdate /mips_tb/U_0/ID/RegWrite
add wave -noupdate /mips_tb/U_0/INT/IFG
add wave -noupdate /mips_tb/U_0/INT/BTCTL
add wave -noupdate /mips_tb/U_0/INT/BTIFG
add wave -noupdate /mips_tb/U_0/INT/selected_clk
add wave -noupdate /mips_tb/U_0/INT/BTHOLD
add wave -noupdate -radix hexadecimal /mips_tb/U_0/INT/BTCNT
add wave -noupdate /mips_tb/U_0/INT/BTSSEL
add wave -noupdate /mips_tb/U_0/INT/BTIP
add wave -noupdate /mips_tb/U_0/INT/clock0
add wave -noupdate /mips_tb/U_0/INT/clock1
add wave -noupdate /mips_tb/U_0/INT/clock2
add wave -noupdate /mips_tb/U_0/INT/clock3
add wave -noupdate /mips_tb/Switches
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1168170 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1051383 ps} {2028817 ps}
bookmark add wave bookmark0 {{0 ps} {630 ns}} 0
