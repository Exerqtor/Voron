; /sys/filament-change.g  v1.6
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
M291 R"Manual Filament Change" P"Change & prime filament, then press OK." S2
G1 E60 F200                                                                    ; Purge 60mm of filament
G1 Z-40 F800                                                                   ; Drop back down to printing height
G90                                                                            ; Absolute positioning