; /sys/lib/current/xy_current_high.g
; Called when printing
; Used to set X Y motor currents for printing

M913 X100 Y100                                                                 ; Set X Y motors to 100% of their max current
set global.xy_current = move.axes[0].current