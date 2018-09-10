# Store the instruction opcode register (decode stage of the pipeline) content

# variables
set clk 0
set fe_pc x		;# fetch stage program counter
set de_pc x		;# decode stage program counter
set dein_inst x	;# decode stage instruction opcode (register input)
set de_inst x	;# decode stage instruction opcode (register output)
set ex_pc x		;# execute stage program counter
set ex_inst x	;# execute stage instruction opcode
set me_pc x		;# memory stage program counter
set me_inst x	;# memory stage instruction opcode
set wr_pc x		;# write stage program counter
set wr_inst x	;# write stage instruction opcode
set holdn 0		;# holdn signal
set ico_mds 1	;# instruction cache memory strobe signal

proc get_inst {name index ops} {
    upvar $name clk
    global now de_inst

    # when rising edge of clk
    if {$clk == 1} then {

	# store holdn and instruction cache memory strobe signal
	set holdn [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/holdn}]
	set ico_mds [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/ico.mds}]

	# when holdn equals to 1 or memory strobe signal equals to 0
	# store decode stage inst. opcode register input value as inst. opcode
	if {(($holdn == 1) || ($ico_mds == 0))} then { 
    set dein_inst [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/dein.inst}]
	    set b 0

          # convert dein_inst variable value to hex and store to variable b
	    # if dein_inst has hex value b gets it, otherwise it gets 0
	    scan $dein_inst %x b
	    
    # when dein_inst has non-numerical value, ignore it
	    if {$b != 0} {
		set de_inst $dein_inst
		puts "de.inst : $de_inst @ $now"
	    }
	 }
    }
}

# store the pipeline stage to the corresponding variables
when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/fe.pc} {set fe_pc [format %x [expr 4*[exa -dec {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/fe.pc}]]]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/de.pc} {set de_pc [format %x [expr 4*[exa -dec {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/de.pc}]]]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.ex.pc} {set ex_pc [format %x [expr 4*[exa -dec {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.ex.pc}]]]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.ex.inst} {set ex_inst [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.ex.inst}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.me.pc} {set me_pc [format %x [expr 4*[exa -dec {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.me.pc}]]]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.me.inst} {set me_inst [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.me.inst}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.wr.pc} {set wr_pc [format %x [expr 4*[exa -dec {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.wr.pc}]]]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.wr.inst} {set wr_inst [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/iuo.debug.wr.inst}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/clk} {set clk [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/clk}]}


# for internal debugging
trace variable fe_pc w tracer ;# fe_pc
trace variable de_pc w tracer ;# de_pc
trace variable ex_pc w tracer ;# ex_pc
trace variable ex_inst w tracer ;# ex_inst
trace variable me_pc w tracer ;# me_pc
trace variable me_inst w tracer ;# me_inst
trace variable wr_pc w tracer ;# wr_pc
trace variable wr_inst w tracer ;# wr_inst
trace variable clk w get_inst ;# de_inst
