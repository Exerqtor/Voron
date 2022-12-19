; /sys/lib/speed/speed_probing.g
; Called to set speed and accelerations settings for probing

; Axis accelerations and speeds
M566 X900.00 Y900.00 Z20.00 P1                                                 ; Set maximum instantaneous speed changes (mm/min) and jerk policy
M203 X18000.00 Y18000.00 Z3000.00                                              ; Set maximum speeds (mm/min)
M201 X2000.00 Y2000.00 Z100.00                                                 ; Set accelerations (mm/s²)

; Extruder accelerations and speeds
M566 E3600.00 P1                                                               ; Set maximum instantaneous speed changes (mm/min) and jerk policy
M203 E5000.00                                                                  ; Set maximum speeds (mm/min)
M201 E800.0                                                                    ; Set accelerations (mm/s²)

; Printing and travel accelerations
M204 P500 T2000                                                                ; Set printing acceleration and travel accelerations (mm/s²)