; /sys/lib/goto/bed_center.g
; Called to move the nozzle to bed center

G90                                                                            ; Absolute positioning
G1 X{global.bed_x / 2} Y{global.bed_y / 2} F6000                               ; Move to the center of the bed