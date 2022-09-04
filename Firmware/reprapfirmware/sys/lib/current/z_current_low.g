; /sys/lib/current/z_current_low.g
; Called when homing and probing
; Used to set Z motor currents for homing and probing

M913 Z60                                                                       ; Set Z motors to 60% of their max current
set global.z_current = move.axes[2].current