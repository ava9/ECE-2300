transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/lab3.v}
vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/var_clk.v}
vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/tcounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/treg4bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/tffp.v}
vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/hex_to_seven_seg.v}

vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/lab3_test.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc" lab3_test

add wave *
view structure
view signals
run -all
