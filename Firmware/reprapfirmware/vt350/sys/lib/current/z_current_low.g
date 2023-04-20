; /sys/lib/current/z_current_low.g  v2.2
; Called when homing and probing
; Used to set Z motor currents for homing and probing

; Stepper current %
var PCT                 = 60                                                   ; Set the % of the stepper max current you want to be set!

; Don't touch anyting bellow this point!
; -----------------------------------------------------------------------------

; External reduction
if exists(param.C)
  set var.PCT = {param.C}                                                      ; Set var.PCT to the value from the external C parameter

M913 Z{var.PCT}                                                                ; Set Z motors to var.PCT % of their max current

if exists(param.M)                                                             ; param.M passed stands for Message (post echo message)
  echo "Z steppers at " ^ var.PCT ^ "% of max current!"