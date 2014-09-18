transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {lab3.vo}

vlog -vlog01compat -work work +incdir+C:/Users/Alex/Desktop/lab3 {C:/Users/Alex/Desktop/lab3/lab3_test.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L cycloneii_ver -L gate_work -L work -voptargs="+acc" lab3_test

add wave *
view structure
view signals
run -all
