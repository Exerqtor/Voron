; /sys/lib/goto/bed_center.g
; called to move the nozzle to bed center

G90                                                                            ; absolute positioning
G1 X{global.bed_x / 2} Y{global.bed_y / 2} F6000                               ; move to the center of the bed