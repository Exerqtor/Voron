; /sys/homeall.g  v2.9
; Called to home all axes
; Configured for sensorless homing / stall detection on a Duet 3 Mini 5+ and LDO-42STH48-2504AC steppers on XY

;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/

; ====================---------------------------------------------------------
; Settings section
; ====================
; Nozzle clearance (gets overridden if you have global.Nozzle_CL)
var Clearance           = 5                                                    ; The "safe" clearance you want to have between the noszzle and bed before moving the printhead

; Don't touch anyting beyond this point(unless you know what you're doing)!!
; ====================---------------------------------------------------------
; Prep phase
; ====================
; Nozzle clearance
if exists(global.Nozzle_CL)
  set var.Clearance = {global.Nozzle_CL}

; Lower Z currents
if fileexists("/sys/lib/current/z_current_low.g")
  M98 P"/sys/lib/current/z_current_low.g"                                      ; Set low Z currents
else
  M913 Z60                                                                     ; Set Z motors to 60% of their max current

; ====================---------------------------------------------------------
; Lower Z axis
; ====================
var z_clear = false                                                            ; Create a variable to indicate if the bed is lowered enough to clear the nozzle or not

; Lower Z if needed
if !move.axes[2].homed                                                         ; If Z isn't homed
  G91                                                                          ; Relative positioning
  G1 Z{var.Clearance} F9000 H1                                                 ; Lower Z(bed) relative to current position
  G90                                                                          ; Absolute positioning
  set var.z_clear = true                                                       ; The nozzle is now clear of the bed

elif move.axes[2].userPosition < {var.Clearance}                               ; If Z is homed but less than var.Clearance
  G1 Z{var.Clearance} F9000                                                    ; Move to Z var.Clearance
  set var.z_clear = true                                                       ; The nozzle is now clear of the bed

; ====================---------------------------------------------------------
; Home all axis
; ====================
if var.z_clear
  M98 P"/sys/homex.g" Z{true} A{true}                                          ; Home X axis, pass param.Z since we allready lowered Z & A to indicate this is part of a homing sequence
  M98 P"/sys/homey.g" Z{true} C{true}                                          ; Home Y axis, pass param.Z since we allready lowered Z & C since XY currents/speeds are also ok
  M98 P"/sys/homez.g" Z{true} C{true}                                          ; Home Z axis, pass param.Z since we allready lowered Z & C since XY currents/speeds are also ok
    
elif
  M98 P"/sys/homex.g" A{true}                                                  ; Home X axis, pass param.A to indicate this is part of a homing sequence
  M98 P"/sys/homey.g" C{true}                                                  ; Home Y axis, pass param.C since XY currents/speeds are also ok
  M98 P"/sys/homez.g" C{true}                                                  ; Home Z axis, pass param.C since XY currents/speeds are also ok
  
; ====================---------------------------------------------------------
; Finish up
; ====================
; Full currents
if fileexists("/sys/lib/current/xy_current_high.g")
  M98 P"/sys/lib/current/xy_current_high.g"                                    ; Set high XY currents
else
  M913 X100 Y100                                                               ; Set X Y motors to var.100% of their max current
if fileexists("/sys/lib/current/z_current_high.g")
  M98 P"/sys/lib/current/z_current_high.g"                                     ; Set high Z currents
else
  M913 Z100                                                                    ; Set Z motors to var.100% of their max current
  
;LED status
if exists(global.sb_leds)
  set global.sb_leds = "ready"