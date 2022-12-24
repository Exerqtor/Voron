; /sys/homez.g
; Called to home the Z axis with sensor K0

; Nozzle clearance (gets overridden if you have global.Nozzle_CL)
var Clearance           = 5                                                    ; The "safe" clearance you want to have between the noszzle and bed before moving the printhead

; Don't touch anyting bellow this point(unless you know what you're doing)!!
; -----------------------------------------------------------------------------

if exists(global.Nozzle_CL)
  set var.Clearance = {global.Nozzle_CL}

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "homing"

; Do nothing if XY is not homed yet
if move.axes[0].homed && move.axes[1].homed
  M98 P"/sys/lib/current/z_current_low.g"                                      ; Set low Z currents
  if !move.axes[2].homed                                                       ; If Z ain't homed
    G91                                                                        ; Relative positioning
    G1 Z{var.Clearance} F9000 H1                                               ; Lower Z(bed) relative to current position	
    G90                                                                        ; Absolute positioning
  elif move.axes[2].userPosition < {var.Clearance}                             ; If Z is homed and less than var.Clearance
    G1 Z{var.Clearance} F9000                                                  ; Move to Z var.Clearance

  ; Lower currents
  M98 P"/sys/lib/current/xy_current_low.g"                                     ; Set low XY currents

  ; Move to bed center and home Z
  M98 P"/sys/lib/goto/bed_center.g"                                            ; Move to bed center
  M98 P"/sys/lib/speed/speed_probing.g"                                        ; Set low speed & accel
  G30 K0 Z-99999                                                               ; Probe the center of the bed
  M400                                                                         ; Wait for moves to finish

  ; Full currents, speed & accel
  M98 P"/sys/lib/current/z_current_high.g"                                     ; Restore normal Z currents
  M98 P"/sys/lib/current/xy_current_high.g"                                    ; Set high XY currents
  M98 P"/sys/lib/speed/speed_printing.g"                                       ; Restore normal speed & accels

; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{var.Clearance} F2400                                                      ; Move to Z var.Clearance

; If using Voron TAP, report that probing is completed
if exists(global.TAPPING)
  set global.TAPPING = false
  M402 P0                                                                      ; Return the hotend to the temperature it had before probing

;LED status
if exists(global.sb_leds)
  set global.sb_leds = "ready"