; /sys/lib/goto/front_center.g
; called to move the nozzle to front center

G90                                                                            ; absolute positioning
G1 X{global.bed_x / 2} Y0 F6000                                                ; move to front center of the bed