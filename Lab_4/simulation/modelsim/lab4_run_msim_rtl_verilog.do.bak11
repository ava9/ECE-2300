transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/xprt/Desktop/Cornell/Class\ Materials/ECE/ECE\ 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4 {C:/Users/xprt/Desktop/Cornell/Class Materials/ECE/ECE 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4/var_clk.v}
vlog -vlog01compat -work work +incdir+C:/Users/xprt/Desktop/Cornell/Class\ Materials/ECE/ECE\ 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4 {C:/Users/xprt/Desktop/Cornell/Class Materials/ECE/ECE 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4/prandom.v}
vlog -vlog01compat -work work +incdir+C:/Users/xprt/Desktop/Cornell/Class\ Materials/ECE/ECE\ 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4 {C:/Users/xprt/Desktop/Cornell/Class Materials/ECE/ECE 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4/lab4.v}
vlog -vlog01compat -work work +incdir+C:/Users/xprt/Desktop/Cornell/Class\ Materials/ECE/ECE\ 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4 {C:/Users/xprt/Desktop/Cornell/Class Materials/ECE/ECE 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4/hex_to_seven_seg.v}
vlog -vlog01compat -work work +incdir+C:/Users/xprt/Desktop/Cornell/Class\ Materials/ECE/ECE\ 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4 {C:/Users/xprt/Desktop/Cornell/Class Materials/ECE/ECE 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4/address_generator.v}
vlog -vlog01compat -work work +incdir+C:/Users/xprt/Desktop/Cornell/Class\ Materials/ECE/ECE\ 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4 {C:/Users/xprt/Desktop/Cornell/Class Materials/ECE/ECE 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4/countdown.v}

vlog -vlog01compat -work work +incdir+C:/Users/xprt/Desktop/Cornell/Class\ Materials/ECE/ECE\ 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4 {C:/Users/xprt/Desktop/Cornell/Class Materials/ECE/ECE 2300/Lab/lab4_final/lab4_3.24.14/lab4/lab4/lab4_test.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc" lab4_test

add wave *
view structure
view signals
run -all
