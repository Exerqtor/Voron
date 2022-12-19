; /sys/lib/goto/rear_center.g
; Called to move the nozzle to rear center

G90                                                                            ; Absolute positioning
G1 X{global.bed_x / 2} Y{global.bed_y} F6000                                   ; Move to front center of the bed