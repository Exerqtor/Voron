; bed_probe_points.g
; called to define probing points when traming the bed

G1 X175 F6000                                                                  ; move to X center
G30 K0 P0 X175 Y315 Z-99999                                                    ; probe near center rear leadscrew
G30 K0 P1 X325 Y25 Z-99999                                                     ; probe near front right leadscrew
G30 K0 P2 X25 Y25 Z-99999 S0                                                   ; probe near front left leadscrew  and calibrate all motors