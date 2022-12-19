; /sys/lib/speed/speed_printing.g
; Called to set speed and accelerations settings for printing

; Axis accelerations and speeds
M566 X700.00 Y700.00 Z30.00 P1                                                 ; Set maximum instantaneous speed changes (mm/min) and jerk policy
M203 X18000.00 Y18000.00 Z900.00                                               ; Set maximum speeds (mm/min)
M201 X4500.00 Y4500.00 Z150.00                                                 ; Set accelerations (mm/s²)

; Extruder accelerations and speeds
M566 E8000.00 P1                                                               ; Set maximum instantaneous speed changes (mm/min) and jerk policy
M203 E15000.00                                                                 ; Set maximum speeds (mm/min)
M201 E1800.0                                                                   ; Set accelerations (mm/s²)

; Printing and travel accelerations
M204 P3500 T4500                                                               ; Set printing acceleration and travel accelerations (mm/s²)