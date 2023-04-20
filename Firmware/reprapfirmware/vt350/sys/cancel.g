; cancel.g
; Called when a print is cancelled after a pause.

;M98 P"/sys/lib/print/print_end.g"                                              ; Call Macro/Subprogram

M400                                                                           ; Wait for moves to finish
G90                                                                            ; Absolute positioning
G1 X340 Y340 F9000                                                             ; Move gantry close to home
G1 E{-(global.unload_length - 5)} F100                                         ; Retract 37mm of filament (42mm total) to clear the E3D Revo
M400                                                                           ; Wait for moves to finish
M140 S0                                                                        ; Turn off heated bed
;M141 S0                                                                        ; Turn off heated chamber
;T-1                                                                            ; Deselect all tools and set them on standby
G10 P0 R0 S0                                                                   ; Set active and standby temps for T0 to 0°C
M107                                                                           ; Turn off the print cooling fan
M84                                                                            ; Disable steppers