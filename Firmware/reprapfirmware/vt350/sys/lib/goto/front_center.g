; /sys/lib/goto/front_center.g
; Called to move the nozzle to front center

G90                                                                            ; Absolute positioning
G1 X{global.bed_x / 2} Y0 F6000                                                ; Move to front center of the bed