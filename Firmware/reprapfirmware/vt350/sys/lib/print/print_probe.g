; /sys/print/print_probe.g  v2.0
; Called when "M98 P"/sys/lib/print/print_probe.g" is sent
; Used to determine if you want to probe a new bed mesh at the start of a print

;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/

;--------------------------------------------------------------------------------------------------------------------------------------

; This macro checks if global.Print_Probe is declared, true/enabled or false/disalbed.
; Based on the status of global.Print_Probe it will either proceed to probe a new mesh, or start the print with default mesh

;--------------------------------------------------------------------------------------------------------------------------------------

; ====================---------------------------------------------------------
; Do the checks
; ====================

;echo "print_probe.g start"

; Check if global.Print_Probe is defined
if exists(global.Print_Probe)
  if global.Print_Probe
    if fileexists("/sys/lib/a_mesh.g")
      M291 P"Pre-print mesh probing enabled, probing new bed mesh!" T4         ; Display message about what's going to happen
      M98 P"/sys/lib/a_mesh.g"
    else
      echo "a_mesh.g missing, aborting!"
      abort
  else
    M291 P"Pre-print mesh probing disabed, using default mesh!" T4             ; Display message about what's going to happen
    G29 S1 P"default_heightmap.csv"                                            ; Load height map file "full_heightmap.csv" and enable mesh bed compensation
else
  echo "global.Print_Probe not defined"
  M291 P"Pre-print mesh probing failed, using default mesh!" T4                ; Display message about what's going to happen
  G29 S1 P"default_heightmap.csv"                                              ; Load height map file "full_heightmap.csv" and enable mesh bed compensation
  
;echo "print_probe.g end"