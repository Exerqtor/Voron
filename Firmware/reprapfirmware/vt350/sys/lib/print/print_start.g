; /sys/lib/print/print_start.g  v2.6
; Called when starting a print (after start.g) at the end of your slicers start code
; Used to configure print parameters

G10 P{global.initial_extruder} R0 S0                                           ; Set active and standby temps for the initial tool
G21                                                                            ; Set units to millimeters
G90                                                                            ; Use absolute coordinates
M83                                                                            ; Use relative distances for extrusion
T0                                                                             ; Select Tool 0
M291 P"Print started, preheating." T10                                         ; Info message
G4 S1                                                                          ; Wait 1 second
M220 S100                                                                      ; Reset speed factor
M221 S100                                                                      ; Reset extrusion factor
M290 R0 S0                                                                     ; Reset baby stepping
M107                                                                           ; Turn off the part cooling fan
if exists(global.sb_leds)
  set global.sb_leds = "heating"                                               ; StealthBurner LED status
M140 S{global.bed_temp}                                                        ; Set bed temperature
M116 H0 S5                                                                     ; Wait for the bed to reach its temperature +/-5°C
G10 P0 S150 R150                                                               ; Set Tool 0 active and standby temps to 150°C
M116 H1                                                                        ; Wait hotend to reach it's temperature
G28                                                                            ; Home all axes
M98 P"bed.g" A{true}                                                           ; Tram the bed if needed
M98 P"/sys/lib/print/print_probe.g/"                                           ; Pre print mesh macro, if it will probe a mesh or not i controlled by global.Print_Probe(true=on, false=off) and select a mesh accordinlgy
M376 H5                                                                        ; Set bed compensation taper to 5mm
G4 S1                                                                          ; Wait 1 sec
G10 P{global.initial_extruder} R{global.hotend_temp} S{global.hotend_temp}     ; Set active and standby temps for the initial tool
if exists(global.sb_leds)
  set global.sb_leds = "heating"                                               ; StealthBurner LED status
M116 H1                                                                        ; Wait hotend to reach it's temperature
M42 P0 S0.3                                                                    ; Turn on chamber lights to 30%
G0 Z{global.first_layer_height + 5} F3000                                      ; Drop bed to first layer height + 5mm to reduce pucker factor
M98 P"/sys/lib/print/print_purge.g"                                            ; Purge the nozzle before starting print
M400                                                                           ; Wait for moves to finish
if exists(global.sb_leds)
  set global.sb_leds = "printing"                                              ; StealthBurner LED status