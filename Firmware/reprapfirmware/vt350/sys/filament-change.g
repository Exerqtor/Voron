; /sys/filament-change.g
; Called when M600 is sent
; Used to do a filament change while printing

M42 P0 S500                                                                    ; Turn on the lights
G10                                                                            ; Retraction
G91                                                                            ; Relative positioning
G1 Z5 F500                                                                     ; Lift Z by 5mm
M98 P"/sys/lib/beep/l.g"                                                       ; Beep
G1 Z35 F800                                                                    ; Lift Z by 35mm
M98 P"/sys/lib/goto/front_right.g"                                             ; Move to front right for filament change
G1 E2 F800                                                                     ; Extrude slightly to help form a nice tip
G1 E{-(global.unload_length)} F800                                             ; Retract filament from meltzone
M400                                                                           ; Wait for moves to finish
M98 P"/sys/lib/beep/xl.g"                                                      ; Beep
M291 R"Mid-print Filament Change" P"Change and purge filament. Resume when after complete." S2
G0 Z-40                                                                        ; Drop back down to printing height
G1 E40 F200                                                                    ; Purge 40mm of filament
G90                                                                            ; Absolute positioning