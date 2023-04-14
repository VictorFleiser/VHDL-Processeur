
vlib work

vcom -2008 ALUv3.vhd
vcom -2008 ALUv3_tb.vhd
vcom -2008 registers.vhd
vcom -2008 registers_tb.vhd
vcom -2008 ALU_and_registers_tb.vhd
vcom -2008 memoire_data.vhd
vcom -2008 memoire_data_tb.vhd
vcom -2008 unite_traitement.vhd
vcom -2008 unite_traitement_tb.vhd


vsim unite_traitement_tb(TEST)

view signals

--add wave -r /*
-- -color "dark green"
add wave -height 40 -radix ascii -r -label VERIFICATION /unite_traitement_tb/OK

add wave -radix hexadecimal -expand -r -label Banc_de_registres /unite_traitement_tb/UUT/registers/Banc
add wave -radix hexadecimal -r -label Memoire_de_registres /unite_traitement_tb/UUT/memory/memory

add wave *

run -all
