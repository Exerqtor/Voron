; bed_probe_points.g
; called to define probing points when traming the bed

if !exists(param.A)
  M98 P"/sys/lib/goto/bed_center.g"                                            ; Move to bed center

G30 K0 P0 X175 Y345 Z-99999                                                    ; Probe center rear bed
G30 K0 P1 X345 Y5 Z-99999                                                      ; Probe right front bed corner
G30 K0 P2 X5 Y5 Z-99999 S3                                                     ; Probe left front bed corner and calibrate 3 motors