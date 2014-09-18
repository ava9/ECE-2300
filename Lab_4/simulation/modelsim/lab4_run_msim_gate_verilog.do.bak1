transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {lab4.vo}

vlog -vlog01compat -work work +incdir+D:/Cornell/Freshmen/Academics/Semester\ 2/ECE\ 2300/Pre\ Lab/lab4 {D:/Cornell/Freshmen/Academics/Semester 2/ECE 2300/Pre Lab/lab4/lab4_test.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L cycloneii_ver -L gate_work -L work -voptargs="+acc" lab4_test

add wave *
view structure
view signals
run -all
