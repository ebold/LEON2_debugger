# Update the user interface variables

set monlist [list fe_pc de_pc de_inst ex_pc ex_inst me_pc me_inst wr_pc wr_inst \
        psr_cwp psr_et psr_ps psr_s psr_pil psr_ef psr_ec psr_icc tbr_tba tbr_tt wim \
	wp global_1 global_2 global_3 global_4 global_5 global_6 global_7 \
	local_0 local_1 local_2 local_3 local_4 local_5 local_6 local_7 \
	in_0 in_1 in_2 in_3 in_4 in_5 in_6 in_7]

proc monitor {name arrayindex op} {
        global UPDATE
        
	# get the name of the changed variable 
	set rncell $name

       
	if {([string first "local" $rncell] == 0) || ([string first "in" $rncell] == 0)} then {
	    if {$UPDATE == 0} then {
		return
	    }
	}

	# append the name of the user interface, because the text id and cell id on the canvas are stored in it, for example for fe_pc variable
	# fe_pccell variable will hold the text id and cell id. refer to cell.tcl 
	append rncell "cell"
	# make everything global
	global $name $rncell cv
	# extract the ids
	set id [expr $$rncell]
	# b will have the variable contents
	set b [expr $$name]
	# update the variable on the canvas
	$cv itemconfigure [lindex $id 1] -text $b

        if {$name == "wp"} then {
	    global NWINDOWS regs

	    set a [expr (($$name + 1) % $NWINDOWS) * 16]
	    for {set i 0} {$i < 8} {incr i} {
		set localreg "local_"
		append localreg $i
		append localreg "cell"
		
		set inreg "in_"
		append inreg $i
		append inreg "cell"
		
		global $localreg $inreg 
		
		set id [expr $$localreg]
		set b $regs([expr $a + $i])
		$cv itemconfigure [lindex $id 1] -text $b
		
		set id [expr $$inreg]
		set b $regs([expr $a + $i + 8])
		$cv itemconfigure [lindex $id 1] -text $b
	    }
	}
	# un-higlight all boxes
#	unhl
	# highlight the box when the variable changes
#	$cv itemconfigure [lindex $id 0] -outline blue -width 3


	}

# un-highlight the box
proc unhl {} {
	global monlist BOXCOLOR
	foreach i $monlist {
		set rncell $i
		append rncell "cell"
		global $rncell cv
		set id [expr $$rncell]
		$cv itemconfigure [lindex $id 0] -outline $BOXCOLOR -width 0
	}
}

# include a trace on every variable of the monlist 
# whenever a variable changes it calls the monitor procedure to update the value of text on canvas. 
foreach i $monlist {
	trace variable $i w monitor
}

#trace variable updateflag w updateRegs
