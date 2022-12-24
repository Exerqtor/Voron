; /sys/lib/current/z_current_low.g  v2.1
; Called when homing and probing
; Used to set Z motor currents for homing and probing

; Stepper current %
var PCT                 = 60                                                   ; Set the % of the stepper max current you want to be set!

; Don't touch anyting bellow this point!
; -----------------------------------------------------------------------------
M913 Z{var.PCT}                                                                ; Set Z motors to var.PCT % of their max current
echo "Z steppers at " ^ var.PCT ^ "% of max current!"

if exists(global.xy_current)
  set global.z_current = move.axes[2].current