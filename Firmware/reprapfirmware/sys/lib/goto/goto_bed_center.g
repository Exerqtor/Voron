; /sys/lib/goto/goto_bed_center.g
; called to move the nozzle to bed center

G90                                                                            ; absolute positioning
G1 X{global.bedx / 2} Y{global.bedy / 2} F6000                                 ; move to the center of the bed