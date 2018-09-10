# Store the register file content to an array

# variables
set rf_clk 0 	;# register file clk signal
set rf_wren 0 	;# register file write enable signal
set rf_addr 0 	;# register file write address signal
set rf_data x 	;# register file write data signal
set window 0 	;# window pointer calculated from the write address signal
set UPDATE 1 	;# indicator which identifies whether the values of the 
			;# register file in a graphical interface should be updated
			;# when UPDATE = 1, update the values

# create an array 
for {set i 0} {$i < [expr $NREGS + 8]} {incr i} {
    array set regs [list $i $i]
}


proc register {name index ops} {
    upvar $name clk
    global NWINDOWS NREGS wp now UPDATE regs

    if {$clk == 1} then {   ;# when rising edge of clk
	  # determine write enable signal
        set rf_wren [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/rf0/rfi.wren}] 
	  
 	  # when it is active 
	  if {$rf_wren == 1 } then  { 

	    # store write address and write data to corresponding variables
    set rf_addr [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/rf0/rfi.wraddr}]
    set rf_data [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/rf0/rfi.wrdata}]
              
	    # convert hex (rf_addr) value to dec (rf_addr_d) value
	    scan $rf_addr %x rf_addr_d

	    # and store it to regs array in pos. specified by rf_addr_d variable
	    set regs($rf_addr_d) $rf_data

	    # print stored value on the command line
          puts "regs($rf_addr): $regs($rf_addr) @ $time" 

	    # determine a windowed register (global, local or in registers)
	    # if index value greater than or equal to number of windowed register
	    # the current register belongs to global
	    # otherwise local register (if offset is lower than 8) or 
    # in register (if offset is greater than 7)
	    if {$rf_addr_d >= $NREGS} then { 
		set i [expr $rf_addr_d % $NREGS]

		set regname "global_"
		append regname $i
		global $regname
		set $regname $regs($rf_addr_d)  

		puts "global_$i : $regs($rf_addr) @ $time"
	      } else {
		set window [expr (($rf_addr_d / 16) -1) % $NWINDOWS]
		
		# determine window pointer
		# and if it is not equal to CWP then not needed to update reg. value
		# in the graphical interface
		if {$wp == $window} then {
		      set UPDATE 1
		} else {
		      set UPDATE 0
		}

		# determine offset value for local or in register
		# offset [0-7] -> local[0-7], offset [8-15] -> in [0-7] 
		set offset [expr $rf_addr_d - 16 * (($window + 1) % $NWINDOWS)]		  
		puts "cwp : $window "
		if {$offset >= 8} then {
		      set i [expr $offset % 8]

		      set regname "in_"
		      append regname $i
		      global $regname
		      set $regname $regs($rf_addr_d) 

		      puts "in_$i : $regs($rf_addr) @ $time"
		} else {

		      set regname "local_"
		      append regname $offset
		      global $regname
		      set $regname $regs($rf_addr_d) 

		      puts "local_$offset : $regs($rf_addr) @ $time"
		}
	      }
	}
    }
}   

# store register file clk signal to rf_clk
when {/tbleon/tb/p0/leon0/mcore0/proc0/rf0/clk} {set rf_clk [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/rf0/clk}]}

# for internal debugging
trace variable rf_clk w register
