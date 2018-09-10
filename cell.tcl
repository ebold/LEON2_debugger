# The graphical user interface

# global variables
set CANVAS_H 75
set CANVAS_W 85

set X_POS 1
set Y_POS 1

set INCR_Y 6
set NO_INDEX false
set WITH_INDEX true

set BOXCOLOR black
set FILLCOLOR white
set TEXTCOLOR black

set PC_LEN 10
set INST_LEN 18
set WID 3

set SCALE 1
set SIZE 8

set wp 0

# draw a label
proc makeLabel {canvas xpos ypos label} {
    global Y_POS INCR_Y

    incr Y_POS [expr $INCR_Y - 1]
    set lbl [$canvas create text $xpos $ypos -anchor nw -fill red -text $label]
}

# draw a header
proc makeHeader {canvas xpos ypos header} {
    global X_POS

    incr X_POS 5
    set hdr [$canvas create text $xpos [expr $ypos + 1] -anchor nw -text $header]

}

# draw a cell
proc makeCell {canvas xpos ypos xsize ysize index value} {
    global X_POS BOXCOLOR FILLCOLOR TEXTCOLOR
    
    incr X_POS [expr $xsize + 1]

    set b [$canvas create rectangle 0 0 $xsize $ysize -outline $BOXCOLOR -fill $FILLCOLOR] 
    $canvas move $b $xpos $ypos 

    incr xpos
    incr ypos
    incr xsize -1
    set val [$canvas create text $xpos $ypos -anchor nw -fill $TEXTCOLOR -text $value -width $xsize]

    if {$index != 0} then {
	incr ypos -3
	set indx [$canvas create text $xpos $ypos -anchor nw -fill $TEXTCOLOR -text $index]
    } else { 
	set indx 0
    }

    return [list $b $val]
}

# resize the entire canvas by a scale
proc rescale {cvn factor} {
	global SCALE
	
	# rescale all the boxes 
	$cvn scale all 0 0 $factor $factor
	
	# rescale the text widths, too
	foreach i [$cvn find all] {
		if {[expr ! [string compare "text" [$cvn type $i]]]} {
			set t [$cvn itemcget $i -width]
			set t [expr $t * $factor]
			$cvn itemconfigure $i -width $t
		}
	}
	
	# resize the canvas itself 
	set t [$cvn cget -width]
	$cvn configure -width [expr $t * $factor]
	set t [$cvn cget -height]
	$cvn configure -height [expr $t * $factor]
	
	# update scale 
	set SCALE [expr $SCALE * $factor]
}	

proc newLine {xpos index} {
    global X_POS Y_POS INCR_Y

    set X_POS $xpos

    if {$index} then {
	incr Y_POS $INCR_Y
    } else {
	incr Y_POS 4
    }
}

# make a new window 
catch { destroy .window}
set w [toplevel .window]

# frame 1 will hold the canvas 
set fr1 [frame $w.fr1]		  

# create a canvas
set cv [canvas $fr1.cv -height [expr $CANVAS_H - 5] -width [expr $CANVAS_W - 0]]

# fetch stage
makeLabel $cv $X_POS $Y_POS "-------- FETCH STAGE --------"

#newLine 1 $NO_INDEX

makeHeader $cv $X_POS $Y_POS "PC"
set fe_pccell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "zzzzzzzz" ]

# decode stage

newLine 1 $WITH_INDEX

makeLabel $cv $X_POS $Y_POS "-------- DECODE STAGE --------"
makeHeader $cv $X_POS $Y_POS "PC"
set de_pccell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "zzzzzzzz"]

newLine 1 $NO_INDEX

makeHeader $cv $X_POS $Y_POS "INST"
set de_instcell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "zzzzzzzz"]
makeCell $cv $X_POS $Y_POS $INST_LEN $WID 0 {"LOAD %g1 [%g2]"}

# execute stage

newLine 1 $WITH_INDEX

makeLabel $cv $X_POS $Y_POS "-------- EXECUTE STAGE --------"
makeHeader $cv $X_POS $Y_POS "PC"
set ex_pccell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "zzzzzzzz"]

newLine 1 $NO_INDEX

makeHeader $cv $X_POS $Y_POS "INST"
set ex_instcell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "zzzzzzzz"]
makeCell $cv $X_POS $Y_POS $INST_LEN $WID 0 {"LOAD %g1 [%g2]"}

# memory stage

newLine 1 $WITH_INDEX

makeLabel $cv $X_POS $Y_POS "-------- MEMORY STAGE --------"
makeHeader $cv $X_POS $Y_POS "PC"
set me_pccell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "zzzzzzzz"]

newLine 1 $NO_INDEX

makeHeader $cv $X_POS $Y_POS "INST"
set me_instcell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "zzzzzzzz"]
makeCell $cv $X_POS $Y_POS $INST_LEN $WID 0 {"LOAD %g1 [%g2]"}

# write stage

newLine 1 $WITH_INDEX

makeLabel $cv $X_POS $Y_POS "-------- WRITE STAGE --------"
makeHeader $cv $X_POS $Y_POS "PC"
set wr_pccell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "zzzzzzzz"]

newLine 1 $NO_INDEX

makeHeader $cv $X_POS $Y_POS "INST"
set wr_instcell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "zzzzzzzz"]
makeCell $cv $X_POS $Y_POS $INST_LEN $WID 0 {"LOAD %g1 [%g2]"}

# control/state register

# %psr reg

set X_POS 36
set Y_POS 1

makeLabel $cv $X_POS $Y_POS "-------- CONTROL/STATE REGISTER --------"
makeHeader $cv $X_POS $Y_POS "%PSR"
set psr_cwpcell [makeCell $cv $X_POS $Y_POS 4 $WID "cwp" "cwp"]
set psr_etcell  [makeCell $cv $X_POS $Y_POS 3 $WID "et"  "et"]
set psr_pscell  [makeCell $cv $X_POS $Y_POS 3 $WID "ps"  "ps"]
set psr_scell   [makeCell $cv $X_POS $Y_POS 3 $WID "s"   "s"]
set psr_pilcell [makeCell $cv $X_POS $Y_POS 3 $WID "pil" "pil"]
set psr_efcell  [makeCell $cv $X_POS $Y_POS 3 $WID "ef"  "ef"]
set psr_eccell  [makeCell $cv $X_POS $Y_POS 3 $WID "ec"  "ec"]
set psr_icccell [makeCell $cv $X_POS $Y_POS 5 $WID "icc" "icc"]

# %tbr reg

newLine 36 $WITH_INDEX

makeHeader $cv $X_POS $Y_POS "%TBR"
set tbr_tbacell [makeCell $cv $X_POS $Y_POS 6 $WID "tba" "tba"]
set tbr_ttcell  [makeCell $cv $X_POS $Y_POS 3 $WID "tt"  "tt"]

# %wim reg

incr X_POS 4

makeHeader $cv $X_POS $Y_POS "%WIM"
set wimcell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID 0 "wim"]

# general purpose regs 
# local[0..3] regs

newLine 36 $WITH_INDEX

makeLabel $cv $X_POS $Y_POS "-------- GENERAL PURP. REGISTER --------"
makeHeader $cv $X_POS $Y_POS "Local"
set local_0cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "0" "local0"]
set local_1cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "1" "local1"]
set local_2cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "2" "local2"]
set local_3cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "3" "local3"]

# local[4..7] regs

newLine 36 $WITH_INDEX

makeHeader $cv $X_POS $Y_POS "Local"
set local_4cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "4" "local4"]
set local_5cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "5" "local5"]
set local_6cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "6" "local6"]
set local_7cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "7" "local7"]

# in[0..3] regs

newLine 36 $WITH_INDEX

makeHeader $cv $X_POS $Y_POS "In"
set in_0cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "0" "in0"]
set in_1cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "1" "in1"]
set in_2cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "2" "in2"]
set in_3cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "3" "in3"]

# in[4..7] regs

newLine 36 $WITH_INDEX

makeHeader $cv $X_POS $Y_POS "In"
set in_4cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "4" "in4"]
set in_5cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "5" "in5"]
set in_6cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "6" "in6"]
set in_7cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "7" "in7"]

# global[0..3] regs

newLine 36 $WITH_INDEX

makeHeader $cv $X_POS $Y_POS "Global"
set global_0cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "0" "00000000"]
set global_1cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "1" "global1"]
set global_2cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "2" "global2"]
set global_3cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "3" "global3"]

# global[4..7] regs

newLine 36 $WITH_INDEX

makeHeader $cv $X_POS $Y_POS "Global"
set global_4cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "4" "global4"]
set global_5cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "5" "global5"]
set global_6cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "6" "global6"]
set global_7cell [makeCell $cv $X_POS $Y_POS $PC_LEN $WID "7" "global7"]

# window pointer
newLine 36 $WITH_INDEX

makeHeader $cv $X_POS $Y_POS "Window"
set wpcell [makeCell $cv $X_POS $Y_POS 4 $WID 0 $wp]

# create a second frame that holds window pointer
set fr2 [frame $w.fr2 -relief raised -border 1]

# everything is small, resize them
rescale $cv $SIZE

# create a scale that identifies window pointer
set sc [scale $fr2.sc -orient horizontal -label Window -from 0 -to [expr $NWINDOWS - 1] -variable wp]

# pack the canvas
pack $cv -side left -anchor w

# pack the scale
pack $sc -side left -anchor w

# pack the frames
pack $fr1 -anchor w
pack $fr2 -anchor w
