; /sys/lib/current/xy_current_low.g
; Called when homing and probing
; Used to set X Y motor currents for homing and probing

M913 X55 Y55                                                                   ; Set X Y motors to 55% of their max current
set global.xy_current = move.axes[0].current