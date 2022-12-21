; /sys/homeall.g
; Called to home all axes

; LED status
set global.sb_leds = "homing"

; Relative positioning
G91                                                                            ; Relative positioning

; Lower currents, speed & accel
M98 P"/sys/lib/current/xy_current_low.g"                                       ; Set low XY currents
M98 P"/sys/lib/current/z_current_low.g"                                        ; Set low Z currents
M98 P"/sys/lib/speed/speed_probing.g"                                          ; Set low speed & accel

; Lower Z relative to current position if needed
if !move.axes[2].homed                                                         ; If Z ain't homed
  G1 Z{global.Nozzle_CL} F9000 H1                                              ; Lower Z(bed) relative to current position
elif move.axes[2].userPosition < {global.Nozzle_CL}                            ; If Z is homed and less than global.Nozzle_CL
  G1 Z{global.Nozzle_CL} F9000                                                 ; Move to Z global.Nozzle_CL

; Coarse home X or Y
G1 X600 Y600 F2400 H1                                                          ; Move quickly to X or Y endstop(first pass)

; Coarse home X
G1 X600 H1                                                                     ; Move quickly to X endstop(first pass)

; Coarse home Y
G1 Y600 H1                                                                     ; Move quickly to Y endstop(first pass)

; Move away from the endstops
G91                                                                            ; Relative positioning
G1 X-5 Y-5 F9000                                                               ; Go back a few mm
G90                                                                            ; Absolute positioning

; Fine home X
G1 X600 F360 H1                                                                ; Move slowly to X axis endstop(second pass)

; Fine home Y
G1 Y600 H1                                                                     ; Move slowly to Y axis endstop(second pass)

G90                                                                            ; Absolute positioning

; Home Z
M98 P"/sys/lib/goto/bed_center.g"                                              ; Move to bed center
G30 K0 Z-99999                                                                 ; Probe the center of the bed
M400                                                                           ; Wait for moves to finish

; Full currents, speed & accel
M98 P"/sys/lib/current/z_current_high.g"                                       ; Restore normal Z currents
M98 P"/sys/lib/current/xy_current_high.g"                                      ; Set high XY currents
M98 P"/sys/lib/speed/speed_printing.g"                                         ; Restore normal speed & accels

; Uncomment the following lines to lower Z(bed) after probing
G90                                                                            ; Absolute positioning
G1 Z{global.Nozzle_CL} F2400                                                   ; Move to Z global.Nozzle_CL

; If using Voron TAP, report that probing is completed
if exists global.TAPPING
  set global.TAPPING = false
  M402 P0                                                                      ; Return the hotend to the temperature it had before probing

;LED status
set global.sb_leds = "ready"