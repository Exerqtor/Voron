; /sys/lib/print/print_start.g
; Called when starting a print
; Used to configure print parameters

; For E3D Revo Micro

;LED status
set global.sb_leds = "heating"

G21                                                                            ; Set units to millimeters
G90                                                                            ; Use absolute coordinates
M83                                                                            ; Use relative distances for extrusion
M220 S100                                                                      ; Reset speed multiplier
M140 S{global.bed_temp}                                                        ; Set bed temperature
M116 H0 S5                                                                     ; Wait for the bed to reach its temperature +/-5°C
G10 P{global.initial_extruder} R{global.hotend_temp} S{global.hotend_temp}     ; Set active and standby temps for the initial tool
M42 P0 S0.3                                                                    ; Turn on chamber lights to 30%
M98 P"/sys/lib/print/print_prep.g"                                             ; Homes all axes and level the bed while everything is hot
G29 S1 P"default_heightmap.csv"                                                ; Load height map file "full_heightmap.csv" and enable mesh bed compensation
M376 H5                                                                        ; Set bed compensation taper to 5mm
T0                                                                             ; Select initial tool
G0 Z{(global.first_layer_height + 5)} F3000                                    ; Drop bed to first layer height + 5mm to reduce pucker factor
M116 H1                                                                        ; Wait hotend to reach it's temperature
M98 P"/sys/lib/print/print_purge.g"                                            ; Purge the nozzle before starting print
M400                                                                           ; Wait for moves to finish

;LED status
set global.sb_leds = "printing"