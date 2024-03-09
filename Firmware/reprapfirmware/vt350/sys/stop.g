; stop.g  v1.5
; Called when M0 (Stop) is run, when a print file completes normally or is cancelled.

; For E3D Revo Micro

; Reset motion defaults
M566 X{global.def_Xjrk} Y{global.def_Yjrk}                                     ; Set maximum instantaneous speed changes/jerk (mm/min)
M204 P{global.def_PACC} T{global.def_TACC}                                     ; Set printing acceleration and travel accelerations (mm/s²)
M572 D0 S{global.def_PA}                                                       ; Set Pressure Advance

M400                                                                           ; Wait for moves to finish

G90                                                                            ; Absolute positioning
G1 X345 Y345 F9000                                                             ; Move gantry close to home
G1 E2 F800                                                                     ; Extrude slightly to help form a nice tip
G1 E{-global.unload_length} F800                                               ; Retract filament from meltzone
M400                                                                           ; Wait for moves to finish
M140 S0                                                                        ; Turn off heated bed
G10 P0 R0 S0                                                                   ; Set active and standby temps for T0 to 0°C
M106 P0 S0                                                                     ; Turn off the part cooling fan
M106 P2 S0                                                                     ; Turn off the AUX part cooling fans
M106 P3 S0                                                                     ; Turn off the StealthMax S
M106 P6 S0                                                                     ; Turn off the Micro V6´s
M702                                                                           ; Unload filament
M84                                                                            ; Disable steppers
M42 P0 S0                                                                      ; Turn off chamber lights

; Disalbe adaptive probing
set global.Print_Probe = false

; Reset print area
set global.paMinX = 0
set global.paMaxX = {global.bed_x}
set global.paMinY = 0
set global.paMaxY = {global.bed_y}

; Tremp & extruder global handling
set global.bed_temp = 0
set global.chamber_temp = 0
set global.hotend_temp = 0
set global.initial_extruder = 0

set global.first_layer_height = "none"
set global.layer_number = 0

; LED status
if exists(global.sb_leds)
  set global.sb_leds = "ready"