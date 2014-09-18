transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/treg4bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/tffp.v}

vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/treg4bit_test.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc" treg4bit_test

add wave *
view structure
view signals
run -all
