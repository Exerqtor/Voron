; pause.g
; Called when a print from SD card is paused

M83                                                                            ; Relative extruder moves
G1 E-5 F3600                                                                   ; Retract 10mm of filament
G91                                                                            ; Relative positioning
G1 Z5 F360                                                                     ; Lift Z by 5mm
G90                                                                            ; Absolute positioning
G1 X0 Y0 F6000                                                                 ; Go to XY 0
M98 P"/sys/lib/speed/speed_printing.g"                                         ; Restore normal speed & accel
M98 P"/sys/lib/current/xy_current_high.g"                                      ; Restore normal XY currents
M98 P"/sys/lib/current/z_current_high.g"                                       ; Restore normal Z currents