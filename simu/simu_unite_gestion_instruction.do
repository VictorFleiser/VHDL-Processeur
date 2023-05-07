
vlib work

vcom -2008 ../src/PC_Extender.vhd
vcom -2008 ../src/mux2v1.vhd
vcom -2008 ../src/PC_register.vhd
vcom -2008 ../src/instruction_memory.vhd
vcom -2008 ../src/unite_gestion_instructions.vhd
vcom -2008 unite_gestion_instructions_tb.vhd


vsim unite_gestion_instructions_tb(TEST)

view signals

-- VERIFICATION :
add wave -height 40 -radix ascii -label VERIFICATION /unite_gestion_instructions_tb/OK

-- CLOCK :
add wave -label clk /unite_gestion_instructions_tb/clk

-- RESET :
add wave -label reset /unite_gestion_instructions_tb/reset

-- nPCSel :
add wave -label nPCSel /unite_gestion_instructions_tb/nPCSel

-- Offset :
add wave -radix signed -label Offset /unite_gestion_instructions_tb/Offset

-- PC :
add wave -radix hex -label PC /unite_gestion_instructions_tb/UUT/Addr

-- Instruction :
add wave -radix hex -label Instruction /unite_gestion_instructions_tb/Instruction

-- UNUSED :
--add wave -radix hex -r -label Instruction /unite_gestion_instructions_tb/UUT/instruction_memory/Instruction
--add wave -radix hex *
--add wave -radix hex -r /*


run -all
