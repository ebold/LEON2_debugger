# Display a value of a Tcl variable, whenever its value changes
proc tracer {name index ops} { 
    global now
    upvar $name v 
    if {$index == ""} {puts "$name: $v @ $now"; return} 
    puts "Array $name ( $index ) is $v($index), ops is $ops" 
}
