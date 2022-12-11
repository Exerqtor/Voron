; /sys/lib/globals.g
; Called by init.g
; Used to initialize global variables

; Global declarations and defaults values

; ====================---------------------------------------------------------
; Temperature
; ====================

if !exists(global.hotend_temp)
  global hotend_temp = 0

; ====================---------------------------------------------------------
; MISC
; ====================

if !exists(global.unload_length)
  global unload_length = 18                                                    ; The length needed to clear the meltzone of the extruder (as speced by E3D for the Revo)