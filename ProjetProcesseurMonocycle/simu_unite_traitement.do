
vlib work

vcom -2008 ALUv3.vhd
vcom -2008 registers.vhd
vcom -2008 registers_tb.vhd
vcom -2008 memoire_data.vhd
vcom -2008 memoire_data_tb.vhd
vcom -2008 unite_traitement.vhd
vcom -2008 unite_traitement_tb.vhd


vsim unite_traitement_tb(TEST)

view signals

--add wave -r /*
-- -color "dark green"

-- VERIFICATION
add wave -height 40 -radix ascii -r -label VERIFICATION /unite_traitement_tb/OK

-- CLOCK :
add wave -label clk /unite_traitement_tb/clk

-- RESET :
add wave -label reset /unite_traitement_tb/reset

-- Instruction :
add wave -label instruction /unite_traitement_tb/instr_courante

-- Registers :
add wave -radix hexadecimal -expand -label Banc_de_registres /unite_traitement_tb/UUT/registers/Banc

-- Memory :
add wave -radix hexadecimal -label Memoire_de_registres /unite_traitement_tb/UUT/memory/memory

--add wave *

run -all
