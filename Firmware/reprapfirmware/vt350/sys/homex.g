; /sys/homex.g
; called to home the X axis

; LED status
set global.sb_leds = "homing"

; Setup low speed & accel
M98 P"/sys/lib/speed/speed_probing.g"                                          ; set low speed & accel

; Lower Z(bed) relative to current position
M98 P"/sys/lib/current/z_current_low.g"                                        ; Set low Z currents
if !move.axes[2].homed                                                         ; If Z ain't homed
  G91                                                                          ; Relative positioning
  G1 Z{global.Nozzle_CL} F9000 H1                                              ; Lower Z(bed) relative to current position	
  G90                                                                          ; Absolute positioning
elif move.axes[2].userPosition < {global.Nozzle_CL}                            ; If Z is homed and less than global.Nozzle_CL
  G1 Z{global.Nozzle_CL} F9000                                                 ; Move to Z global.Nozzle_CL
M98 P"/sys/lib/current/z_current_high.g"                                       ; Restore normal Z currents

; Lower AB currents
M98 P"/sys/lib/current/xy_current_low.g"                                       ; Set low XY currents

; Move quickly to X axis endstop and stop there (first pass)
G1 X600 F2400 H1                                                               ; Move quickly to X axis endstop and stop there (first pass)

; Go back a few mm
G91                                                                            ; Relative positioning
G1 X-5 F9000                                                                   ; Go back a few mm
G90                                                                            ; Absolute positioning

; Move slowly to X axis endstop once more (second pass)
G1 X600 F360 H1                                                                ; Move slowly to X axis endstop once more (second pass)

; Restore AB currents
M98 P"/sys/lib/current/xy_current_high.g"                                      ; Restore normal XY currents

; Restore normal speed & accel
M98 P"/sys/lib/speed/speed_printing.g"                                         ; Restore normal speed & accel

; LED status
set global.sb_leds = "ready"