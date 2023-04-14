
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


--vsim ALUv3_tb(TEST)
--vsim registers_tb(TEST)
--vsim ALU_and_registers_tb(TEST)
--vsim memoire_data_tb(TEST)
vsim unite_traitement_tb(TEST)

view signals

add wave -r /*
--add wave *
--add wave -radix hexadecimal -expand -r -label Banc_de_registres /alu_and_registers_tb/reg/Banc
--add wave -radix hexadecimal -expand -r -label Memoire /memoire_data_tb/UUT/memory

run -all
