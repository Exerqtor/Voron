; /sys/homez.g  v2.9
; Called to home the Z axis

;---/
; -/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
; THIS MACRO ONLY WORKS WITH RRF 3.5.0b1 AND LATER!!
;--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--/--
;-/

; ====================---------------------------------------------------------
; Settings section
; ====================

; Nozzle clearance (gets overridden if you have global.Nozzle_CL)
var Clearance = 5                                                              ; The "safe" clearance you want to have between the noszzle and bed before moving the printhead

; Probe number
var Probe = 0                                                                  ; The probe you want to use to home the Z axis

; Don't touch anyting bellow this point(unless you know what you're doing)!!
; ====================---------------------------------------------------------
; Prep phase
; ====================

; Nozzle clearance
if exists(global.Nozzle_CL)
  set var.Clearance = {global.Nozzle_CL}

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "homing"

; ====================---------------------------------------------------------
; Lower Z axis
; ====================
if exists(param.Z)                                                             ; param.Z passed means that Z clearance is already dealt with
  ; No need to do anything, the nozzle is already been cleared
  
elif
  if !move.axes[2].homed                                                       ; If Z isn't homed
    ; Lower Z currents
    if fileexists("/sys/lib/current/z_current_low.g")
      M98 P"/sys/lib/current/z_current_low.g"                                  ; Set low Z currents
    else
      M913 Z60                                                                 ; Set Z motors to n% of their max current

    G91                                                                        ; Relative positioning
    G1 Z{var.Clearance} F9000 H1                                               ; Lower Z(bed) relative to current position
    G90                                                                        ; Absolute positioning

    ; Full Z currents
    if fileexists("/sys/lib/current/z_current_high.g")
      M98 P"/sys/lib/current/z_current_high.g"                                 ; Set high Z currents
    else
      M913 Z100                                                                ; Set Z motors to 100% of their max current

  elif move.axes[2].userPosition < {var.Clearance}                             ; If Z is homed but less than var.Clearance
    ; Lower Z currents
    if fileexists("/sys/lib/current/z_current_low.g")
      M98 P"/sys/lib/current/z_current_low.g"                                  ; Set low Z currents
    else
      M913 Z60                                                                 ; Set Z motors to n% of their max current

    G1 Z{var.Clearance} F9000                                                  ; Move to Z var.Clearance

    ; Full Z currents
    if fileexists("/sys/lib/current/z_current_high.g")
      M98 P"/sys/lib/current/z_current_high.g"                                 ; Set high Z currents
    else
      M913 Z100                                                                ; Set Z motors to 100% of their max current

; ====================---------------------------------------------------------
; Home Z axis
; ====================
if exists(param.A)                                                             ; param.A passed means that this is the first part of a homing sequence, so we don't want to lower the currents
  ; No need to do anything, at this point

elif
  if exists(param.C)                                                           ; param.C passed means that the currents are handeled externaly 
    ; No need to do anything, currents have been adjusted already  

  elif
    ; Lower Z currents
    if fileexists("/sys/lib/current/z_current_low.g")
      M98 P"/sys/lib/current/z_current_low.g"                                  ; Set low Z currents
    else
      M913 Z60                                                                 ; Set Z motors to n% of their max current

var maxP = sensors.probes[{var.Probe}].maxProbeCount
M558 K{var.Probe} A2                                                           ; Increase to 2 max probes

; Move to bed center and home Z
M98 P"/sys/lib/goto/bed_center.g"                                              ; Move to bed center
G30 K{var.Probe} Z-99999                                                       ; Probe the center of the bed
M400                                                                           ; Wait for moves to finish

M558 K{var.Probe} A{var.maxP}                                                  ; Restore default max probe amount

; ====================---------------------------------------------------------
; Finish up
; ====================
; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{var.Clearance} F2400                                                      ; Move to Z var.Clearance

; If using Voron TAP, report that probing is completed
if exists(global.TAPPING)
  set global.TAPPING = false
  M402 P0       
if exists(param.A)                                                             ; param.A passed means that this is the first part of a homing sequence, so we don't want to raise the currents
  ; No need to do anything, at this point

elif
  if exists(param.C)                                                           ; param.C passed means that the currents are handeled externaly 
    ; No need to do anything, currents have been adjusted already

  elif
    ; Full XY currents
    if fileexists("/sys/lib/current/xy_current_high.g")
      M98 P"/sys/lib/current/xy_current_high.g"                                ; Set high XY currents
    else
      M913 X100 Y100                                                           ; Set X Y motors to var.100% of their max current
    if fileexists("/sys/lib/current/z_current_high.g")
      M98 P"/sys/lib/current/z_current_high.g"                                   ; Set high Z currents
    else
      M913 Z100                                                                  ; Set Z motors to var.100% of their max current

                                                               ; Return the hotend to the temperature it had before probing

  ;LED status
  if exists(global.sb_leds)
    set global.sb_leds = "ready"