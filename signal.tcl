# Store signal values of the PSR, TBR, and WIM registers into the corresponding interval variables

# constants
set IMPL 0000 	    ;# PSR impl field
set VER 0000  	    ;# PSR ver field
set RESRV 000000	;# PSR reserved field
set TBR_ZERO 0000	;# TBR zero field
set NWINLOG2 3	
set NWINDOWS 8	;# number of windows of the register file
set NREGS [expr $NWINDOWS * 16]	;# number of windowed registers (local and in)

# variables
set sregs x
set psr_cwp x	;# PSR CWP field
set psr_et  x	;# PSR ET field
set psr_ps  x	;# PSR PS field
set psr_s   x	;# PSR S field
set psr_pil x	;# PSR PIL field
set psr_ef  x	;# PSR EF field
set psr_ec  x	;# PSR EC field
set psr_icc x	;# PSR ICC field
set psr x
set tbr_tba x	;# TBR TBA field
set tbr_tt x	;# TBR TT field
set tbr x
set wim x		;# WIM register

# store the PSR register signals to the corresponding variables
when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.cwp} {set psr_cwp [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.cwp}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.et} {set psr_et [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.et}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.ps} {set psr_ps [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.ps}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.s} {set psr_s [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.s}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.pil} {set psr_pil [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.pil}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.ef} {set psr_ef [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.ef}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.ec} {set psr_ec [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.ec}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.icc} {set psr_icc [exa -bin {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.icc}]}

set psr "$IMPL $VER $psr_icc $RESRV $psr_ec $psr_ef $psr_pil $psr_s $psr_ps $psr_et $psr_cwp"

# store the TBR register signals to the corresponding variables
when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.tba} {set tbr_tba [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.tba}]}

when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.tt} {set tbr_tt [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.tt}]}

set tbr "$tbr_tba $tbr_tt $TBR_ZERO"

# store the WIM register signal to the correspondig variable
when {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.wim} {set wim [exa -hex {/tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs.wim}]}

# internal debugging: if any of the variable value has changed, then display it in the command line
trace variable sregs w tracer
trace variable psr_cwp w tracer
trace variable psr_et w tracer
trace variable psr_ps w tracer
trace variable psr_s w tracer
trace variable psr_pil w tracer
trace variable psr_ef w tracer
trace variable psr_ec w tracer
trace variable psr_icc w tracer 
trace variable psr w tracer
trace variable tbr_tba w tracer 
trace variable tbr_tt w tracer 
trace variable wim w tracer
