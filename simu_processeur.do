
vlib work

--unite de traitement :
vcom -2008 ALUv3.vhd
--vcom -2008 ALUv3_tb.vhd                       --Test Bench
vcom -2008 mux2v1.vhd
vcom -2008 extension_signe.vhd
vcom -2008 registers.vhd
--vcom -2008 registers_tb.vhd                   --Test Bench
--vcom -2008 ALU_and_registers_tb.vhd           --Test Bench
vcom -2008 memoire_data.vhd
--vcom -2008 memoire_data_tb.vhd                --Test Bench
vcom -2008 unite_traitement.vhd
--vcom -2008 unite_traitement_tb.vhd            --Test Bench

-- unite de gestion instructions :
vcom -2008 PC_Extender.vhd
--vcom -2008 mux2v1.vhd                         --Already done above
vcom -2008 PC_register.vhd
vcom -2008 instruction_memory.vhd
vcom -2008 unite_gestion_instructions.vhd
--vcom -2008 unite_gestion_instructions_tb.vhd  --Test Bench

-- decodeur d'instructions :
vcom -2008 register_32.vhd
vcom -2008 decodeur_instructions.vhd
vcom -2008 unite_controle.vhd

-- Processeur :
vcom -2008 processeur.vhd


--vsim unite_gestion_instructions_tb(TEST)

--view signals

--add wave -height 40 -radix ascii -r -label VERIFICATION /unite_gestion_instructions_tb/OK
--add wave -radix hexadecimal -r -label Instruction /unite_gestion_instructions_tb/UUT/instruction_memory/Instruction

--add wave *

--add wave -radix hexadecimal -r /*


run -all
