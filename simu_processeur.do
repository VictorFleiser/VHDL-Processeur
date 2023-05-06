
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
vcom -2008 processeur_tb.vhd


vsim processeur_tb(TEST)

view signals

add wave -height 40 -radix ascii -r -label VERIFICATION /processeur_tb/OK   


    --affichage des signaux

-- Reset :
add wave -label reset /processeur_tb/reset

-- Clock :
add wave -label clock /processeur_tb/clk

-- Memoire :
add wave -radix hex -label Memoire /processeur_tb/UUT/unite_traitement/memory/Memory

-- Registres :
add wave -radix hex -label Registres -hexa /processeur_tb/UUT/unite_traitement/registers/Banc

-- unite de gestion de controle :
add wave -radix ascii -r -label instruction /processeur_tb/UUT/instr_courante
add wave -label Reg_W /processeur_tb/UUT/unite_traitement/Rd
add wave -label Reg_A /processeur_tb/UUT/unite_traitement/Rn
add wave -label Reg_B /processeur_tb/UUT/unite_traitement/Rb_IN
add wave -label FLAGS /processeur_tb/UUT/unite_controle/Flags


--tests for flags
--add wave /processeur_tb/UUT/unite_controle/*
--add wave /processeur_tb/UUT/unite_controle/reg_PSR/DATA


--add wave /processeur_tb/UUT/unite_controle/*

--add wave -label TB_memory -radix hex /processeur_tb/TESTS_memory
--add wave -label TB_registers -radix hex /processeur_tb/TESTS_registers
--add wave -label TB_registre_tempo -radix hex /processeur_tb/TESTS_registre_tempo

--add wave *

--add wave -radix hexadecimal -r /*

run -all
