; /sys/lib/current/xy_current_low.g  v2.1
; Called when homing and probing
; Used to set X Y motor currents for homing and probing

; Stepper current %
var PCT                 = 80                                                   ; Set the % of the stepper max current you want to be set!

; Don't touch anyting bellow this point!
; -----------------------------------------------------------------------------
M913 X{var.PCT} Y{var.PCT}                                                     ; Set X Y motors to var.PCT % of their max current
echo "X Y steppers at " ^ var.PCT ^ "% of max current!"

if exists(global.xy_current)
  set global.xy_current = move.axes[0].current