; /sys/lib/current/z_current_high.g
; Called when printing
; Used to set Z motor currents for printing

M913 Z100                                                                      ; Set Z motors to 100% of their max current
set global.z_current = move.axes[2].current