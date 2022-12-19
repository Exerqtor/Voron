; /sys/homez.g
; called to home the Z axis with sensor K0 / Voron TAP

; LED status
set global.sb_leds = "homing"

; Do nothing if XY is not homed yet
if move.axes[0].homed && move.axes[1].homed
  M98 P"/sys/lib/current/z_current_low.g"                                      ; Set low Z currents
  if !move.axes[2].homed                                                       ; If Z ain't homed
    G1 Z{global.TAP_clearance} F9000 H1                                        ; Lower Z(bed) relative to current position	
  elif move.axes[2].userPosition < {global.TAP_clearance}                      ; If Z is homed and less than global.TAP_clearance
    G1 Z{global.TAP_clearance} F9000                                           ; Move to Z global.TAP_clearance

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
G1 Z{global.TAP_clearance} F2400                                               ; Move to Z global.TAP_clearance

set global.probing = false
M402 P0                                                                        ; Return the hotend to the temperature it had before probing

;LED status
set global.sb_leds = "ready"