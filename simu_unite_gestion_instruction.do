
vlib work

vcom -2008 PC_Extender.vhd
vcom -2008 mux2v1.vhd
vcom -2008 PC_register.vhd
vcom -2008 instruction_memory.vhd
vcom -2008 unite_gestion_instructions.vhd
vcom -2008 unite_gestion_instructions_tb.vhd


vsim unite_gestion_instructions_tb(TEST)

view signals

add wave -height 40 -radix ascii -r -label VERIFICATION /unite_gestion_instructions_tb/OK
add wave -radix hexadecimal -r -label Instruction /unite_gestion_instructions_tb/UUT/instruction_memory/Instruction

add wave *

--add wave -radix hexadecimal -r /*


run -all
