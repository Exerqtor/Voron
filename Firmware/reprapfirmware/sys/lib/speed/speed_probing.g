; /sys/lib/speed/speed_probing.g
; called to set speed and accelerations settings for probing

;M566 X900 Y900 Z20 E3600        ; Set maximum instantaneous speed changes (mm/min)
;M203 X18000 Y18000 Z3000 E5000  ; Set maximum speeds (mm/min)
;M201 X2000 Y2000 Z100 E800      ; Set maximum accelerations (mm/s^2) 
;M204 P500 T2000                 ; Set printing acceleration and travel accelerations

; Axis accelerations and speeds
M566 X900.00 Y900.00 Z20.00 P1                                                 ; set maximum instantaneous speed changes (mm/min) and jerk policy
M203 X18000.00 Y18000.00 Z3000.00                                              ; set maximum speeds (mm/min)
M201 X2000.00 Y2000.00 Z100.00                                                 ; set accelerations (mm/s^2)

; Extruder accelerations and speeds
M566 E3600.00 P1                                                               ; set maximum instantaneous speed changes (mm/min) and jerk policy
M203 E5000.00                                                                  ; set maximum speeds (mm/min)
M201 E800.0                                                                    ; set accelerations (mm/s^2)

; Printing and travel accelerations
M204 P500 T2000                                                                ; Set printing acceleration and travel accelerations