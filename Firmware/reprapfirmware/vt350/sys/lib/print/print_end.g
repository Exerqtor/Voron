; print_end.g
; Called when ending a print
; Used to configure printer does after a print ends, gets canceled or stopped

M400                                                                           ; Wait for moves to finish
G91                                                                            ; Relative positioning
M83                                                                            ; Extruder relative positioning
G10                                                                            ; Retraction
G1 Z1.00 X20.0 Y20.0 F20000                                                    ; Short quick move to disengage from print
G1 Z10.00 F20000                                                               ; Move Z-Axis 10mm away from part
G90                                                                            ; Absolute positioning
G1 X340 Y340 F9000                                                             ; Move gantry close to home
G1 E2 F800                                                                     ; Extrude slightly to help form a nice tip
G1 E{-(global.unload_length)} F800                                             ; Retract filament from meltzone
M400                                                                           ; Wait for moves to finish
M140 S0                                                                        ; Turn off heated bed
G10 P0 R0 S0                                                                   ; Set active and standby temps for T0 to 0°C
M107                                                                           ; Turn off the print cooling fan
M702                                                                           ; Unload filament
M84                                                                            ; Disable steppers
M42 P0 S0                                                                      ; Turn off chamber lights

; Reset print area
set global.paMinX = 0
set global.paMaxX = {global.bed_x}
set global.paMinY = 0
set global.paMaxY = {global.bed_y}

; Tremp & extruder global handling
set global.bed_temp = "N/A"
set global.chamber_temp = "N/A"
set global.hotend_temp = "N/A"
set global.initial_extruder = "N/A"

set global.first_layer_height = "none"

; LED status
set global.sb_leds = "ready"


set global.job_completion = 1